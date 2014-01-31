//
//  settingViewController.m
//  EDetailing
//
//  Created by Karbens_Mac2 on 21/01/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import "settingViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "Content.h"

@interface settingViewController ()

@end

@implementation settingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.title=@"Setting";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [super dealloc];
}
- (IBAction)clearAction:(id)sender {
    UIAlertView *clearAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are sure you want to clear the credentials?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"YES", nil];
    clearAlert.tag=1;
    clearAlert.delegate=self;
    [clearAlert show];
    
}
- (IBAction)resetAction:(id)sender {
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Are sure you want to reset entire application?Please note all data will be lost."
                                                        delegate:self
                                               cancelButtonTitle:@"NO"
                                               otherButtonTitles:@"YES", nil];
    resetAlert.tag=2;
    resetAlert.delegate=self;
    [resetAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==1) {
        
    
    if (buttonIndex == 0) {
        NSLog(@"cancel");
    }
    else
    {
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        aAppDelegate.username=nil;
        aAppDelegate.password=nil;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"password"];
     

        NSLog(@"YES");
    }
    }
    else if (alertView.tag==2)
    {
        if (buttonIndex == 0) {
            NSLog(@"cancel");
        }
        else
        {
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            aAppDelegate.username=nil;
            aAppDelegate.password=nil;
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"password"];
           
            //NSManagedObjectContext *context1=[aAppDelegate managedObjectContext];
            NSEntityDescription *ent=[NSEntityDescription entityForName:@"Content" inManagedObjectContext:[aAppDelegate managedObjectContext]];
            NSFetchRequest *request=[[NSFetchRequest alloc]init ];
            [request setEntity:ent ];
            NSError *error4;
            NSArray *results=[[aAppDelegate managedObjectContext] executeFetchRequest:request error:&error4] ;
            [request release];
           
            NSLog(@"%@",results);
            
            if (results.count==0) {
                NSLog(@"nothing is there");
            }
            else
            {
                 for (int i=0; i<=(results.count)-1; i++) {
                Content *contentData=[results objectAtIndex:i];
                [self removeFolder:[contentData contentName]];
                 }
            }
                
           
                
                 
              
             
               
            
            [self removeFolder:@"Brands"];

            
            NSArray *contentName=[[NSArray alloc]initWithObjects:@"Brand",@"DataList",@"Summary",@"ControllerToLaunch", nil];
            for (int j=0; j<=[contentName count]-1; j++) {
                NSLog(@"%@",[contentName objectAtIndex:j]);
                [self  deletecontentindatabase:[contentName objectAtIndex:j]];
            }
            [contentName release];
            
            
            [aAppDelegate.dbBrandArr removeAllObjects];
            
        }
        
    }
}




-(void) deletecontentindatabase:(NSString *)entityname
{
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:entityname inManagedObjectContext:aAppDelegate.managedObjectContext]];
//[fetch setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * contentData = [aAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    [fetch release];
    //error handling goes here
    for (NSManagedObject * object in contentData) {
        [aAppDelegate.managedObjectContext deleteObject:object];
    }
    NSError *saveError = nil;
    [aAppDelegate.managedObjectContext save:&saveError];
}


-(void)removeFolder:(NSString *)string
{
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *directory1 = [ documentsDirectory stringByAppendingPathComponent:string];
        //NSString *filePath = [self getDirectory];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:directory1])
        {
            NSError *error;
            if (![fileManager removeItemAtPath:directory1 error:&error])
            {
                NSLog(@"Error removing file: %@", error);
            };
        }
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
