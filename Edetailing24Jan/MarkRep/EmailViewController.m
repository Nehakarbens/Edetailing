//
//  EmailViewController.m
//  EDetailing
//
//  Created by Karbens on 11/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "EmailViewController.h"
#import "SummaryViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
@interface EmailViewController ()

@end

@implementation EmailViewController
@synthesize txtEmailID,lblEmail,btnSend,aParents;

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
    [super viewDidLoad];
    
    UIBarButtonItem *aleftbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStyleBordered target:self action:@selector(Summary)];
    self.navigationItem.rightBarButtonItem = aleftbarButton;

    //UILabel
    lblEmail = [[UILabel alloc]initWithFrame:CGRectMake(250, 70, 80, 30)];
    lblEmail.text = @"Email";
    lblEmail.textColor = [UIColor blueColor];
    
    //Email Text field
    txtEmailID = [[UITextField alloc]initWithFrame:CGRectMake(330, 70, 300, 30)];
    txtEmailID.borderStyle = UITextBorderStyleRoundedRect;
    txtEmailID.placeholder = @"Email ID";
    
    
    //Send Button
    btnSend = [[UIButton alloc]initWithFrame:CGRectMake(360, 140, 80, 30)];
    btnSend.backgroundColor = [UIColor blueColor];
   
    [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(SendPressed:)forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:lblEmail];
    [self.view addSubview:txtEmailID];
    [self.view addSubview:btnSend];
    // Do any additional setup after loading the view from its nib.
}
//-(void) viewWillDisappear:(BOOL)animated {
//    // if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//    Content *aContent = [Utility getContentIfExist:ContentID];
//    
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateFormat:@"hh:mm:ss"];
//    
//    aContent.sumEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
//    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [aAppDelegate.managedObjectContext save:nil];
//    
//    // in the navigation stack.
//    
//    
//    [super viewWillDisappear:animated];
//}
-(void)Summary
{
    SummaryViewController *aSummViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    aSummViewController.aParents =  aParents;
    //aSummViewController.ContentID = ContentID;

    [self presentModalViewController:aSummViewController animated:YES];
    [aSummViewController release];
    aSummViewController = nil;
    
}
-(IBAction)SendPressed:(id)sender{
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
