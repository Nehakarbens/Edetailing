//
//  SlideViewController.m
//  MyDay
//
//  Created by Karbens on 10/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "SlideViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "GridView.h"
#import "Parent.h"
#import "MasterViewController.h"
#import "SummaryViewController.h"
@interface SlideViewController ()
@end

@implementation SlideViewController
@synthesize sortedArray,SlideArray,DisabledSlideArray,ReEnabledArray,aParents,aHomeButton,ContentID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    SelectedSlideArray = [[NSMutableArray alloc]init];
    ReEnabledArray = [[NSMutableArray alloc]init];

    
    NSMutableArray *aBarItems = [[NSMutableArray alloc] init];
    
    
    aHomeButton = [[UIBarButtonItem alloc] initWithTitle:@"View" style:UIBarButtonItemStyleDone target:self action:@selector(ViewPressed)];
    [aBarItems addObject:aHomeButton];
    
 

    
    
   UIBarButtonItem *aleftbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editMode:)];
    aleftbarButton.style = UIBarButtonItemStyleBordered;
    aleftbarButton.possibleTitles = [NSSet setWithObjects:@"Edit", @"Done", nil];
    [aBarItems addObject:aleftbarButton];
    
    UIBarButtonItem  *aSummButton = [[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStyleDone target:self action:@selector(Summary)];
    [aBarItems addObject:aSummButton];
    
    self.navigationItem.rightBarButtonItems = (NSArray *)aBarItems;
    
    [aleftbarButton release];
    aleftbarButton = nil;
    [aBarItems release];
    aBarItems = nil;
    

    
    // Do any additional setup after loading the view from its nib.
    SlideArray = [[NSMutableArray alloc]initWithArray:aParents];
    DisabledSlideArray = [[NSMutableArray alloc]initWithArray:aParents];
    
//    [aParents release];
//    aParents = nil;
    
    
    sortedArray = [[NSArray alloc]init];
    
//    sortedArray = [(NSMutableArray *)SlideArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(localizedStandardCompare:)]]];

     sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    
    self.title = @"Slides";
    [self loadGridView];
    
    float sizeOfContent = 0;
    UIView *lLast = [_ScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height+30;
    
    sizeOfContent = wd+ht;
    
    _ScrollView.contentSize = CGSizeMake(_ScrollView.frame.size.width, sizeOfContent);
}
- (void)loadGridView {
    
    CGFloat gridViewWidth = 150.0f;
    CGFloat gridViewHeight = 150.0f;
    int i = 0;
    int j = 1;
    int  k=0;
    NSInteger extrarow;
    if (([sortedArray count]%5)<5 ) {
        extrarow = 1;
    }
    else{
        
        extrarow=0;
    }
    NSInteger numberofRows = ([sortedArray count]/5)+extrarow;
    for( j=1; j<=numberofRows ; j++ ) {
		for( i=0; i<5 && k<[sortedArray count]; i++ ) {
            
            GridView *aGridView = [[GridView alloc] init];
            aGridView.tag = k + 1;

            CGRect rect;
            Parent *aParent = [sortedArray objectAtIndex:k++];
            rect = CGRectMake( i *(gridViewWidth+40)+50, (j-1)*(gridViewHeight+25)+50, gridViewWidth, gridViewHeight);

            aGridView.frame = rect;
                        NSLog(@"tag1 = %d",aGridView.tag);
            aGridView.brandName = aParent.parentName;
            aGridView.aDelegate = self;
            
            
            
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, gridViewWidth-3, gridViewHeight-3)];
            NSData *data = [NSData dataWithContentsOfFile:aParent.slideBgPath];
    
                UIImage *image = [UIImage imageWithData:data];
            mainImgView.image = image;
            mainImgView.layer.cornerRadius = 8.0;
            [aGridView addSubview:mainImgView];
            [mainImgView release];
            mainImgView = nil;
            
            
            if ([aParent.isEnabled isEqualToNumber:[NSNumber numberWithInt:1]]) {
                aGridView.alpha = 1.0;
            }
            else{
                aGridView.alpha = 0.5;
            }
            
            aGridView.backgroundColor = [UIColor grayColor];
            aGridView.layer.cornerRadius = 8.0;
            aGridView.layer.borderWidth = 3.0;
            aGridView.layer.borderColor = [UIColor grayColor].CGColor;
            aGridView.layer.shadowColor = [UIColor grayColor].CGColor;
            aGridView.layer.shadowOffset = CGSizeMake(aGridView.frame.size.width, aGridView.frame.size.height);
            [self.ScrollView addSubview:aGridView];
            [aGridView layoutIfNeeded];
            [aGridView release];
            aGridView = nil;
            //i++;
            //j++;
            
        }
        
        
    }
}

-(void)didSlideViewSelected:(GridView *)inGridView{
    if (state == UIControlStateSelected) {
//        sortedArray = [(NSMutableArray *)SlideArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(localizedStandardCompare:)]]];

         NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
        
        NSLog(@"tag2 = %d",inGridView.tag);
        if (inGridView.alpha == 1.0) {
            inGridView.alpha = 0.5;
            GridState = UIControlStateSelected;
            [ReEnabledArray removeObject:[sortedArray objectAtIndex:inGridView.tag-1]];
            
            if (![SelectedSlideArray containsObject:[sortedArray objectAtIndex:inGridView.tag-1]]) {
                [SelectedSlideArray addObject:[sortedArray objectAtIndex:inGridView.tag-1]];
            }
                  }
        else if(inGridView.alpha == 0.5){
            inGridView.alpha = 1.0;
            GridState = UIControlStateNormal;
            [SelectedSlideArray removeObject:[sortedArray objectAtIndex:inGridView.tag-1]];
            if (![ReEnabledArray containsObject:[sortedArray objectAtIndex:inGridView.tag-1]]) {
                [ReEnabledArray addObject:[sortedArray objectAtIndex:inGridView.tag-1]];
                
                
            }
        }
    }
    
    
}
- (IBAction)editMode:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"Edit"])
    {
        sender.title = @"Done";
        state = UIControlStateSelected;
        [aHomeButton setEnabled:NO];
        
    }
    else
    {
        sender.title = @"Edit";
        state = UIControlStateNormal;
        [aHomeButton setEnabled:YES];
        [DisabledSlideArray removeObjectsInArray:SelectedSlideArray];
        [DisabledSlideArray addObjectsFromArray:ReEnabledArray];
        [DisabledSlideArray setArray:[[NSSet setWithArray:DisabledSlideArray]allObjects]];
        
        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        for (Parent *aParent in aParents) {
            if ([DisabledSlideArray containsObject:aParent]) {
                aParent.isEnabled =  [NSNumber numberWithInt:1];
                
                
            }
            else
            {
                aParent.isEnabled = [NSNumber numberWithInt:0];
            }
            
        }
        [aAppDelegate.managedObjectContext save:nil];
        
    }
}

-(void)Summary
{
    SummaryViewController *aSummViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    aSummViewController.aParents =  aParents;
    aSummViewController.ContentID = ContentID;

    [self presentModalViewController:aSummViewController animated:YES];
    [aSummViewController release];
    aSummViewController = nil;

}

-(void)ViewPressed{
  
    NSMutableArray *parentArr = [[NSMutableArray alloc]init];
    for (Parent *aParent in aParents) {
        if ([aParent.isEnabled isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [parentArr addObject:aParent];
        }
   

    }
    
    MRParentViewController *aParentViewController = [[MRParentViewController alloc] initWithNibName:@"MRParentViewController" bundle:nil];
    aParentViewController.timerString = @"FromSlideView";
    aParentViewController.ContentID = ContentID;
    aParentViewController.aParents = parentArr;
    
    [self.navigationController pushViewController:aParentViewController animated:YES];
    
    [aParentViewController release];
    aParentViewController = nil;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_ScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
