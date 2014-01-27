//
//  ContentVideosViewController.m
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "ContentVideosViewController.h"
#import "GridView.h"
#import "AppDelegate.h"
#import "Content.h"
#import "Parent.h"
#import "Child.h"
#import "Reference.h"
#import "Utility.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SlidesSubView.h"
#import "SummaryViewController.h"
@interface ContentVideosViewController ()

@end

@implementation ContentVideosViewController
@synthesize VideoArray,ContentID,aVideoPath,animatedVideoView,aParents;
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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *aleftbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStyleBordered target:self action:@selector(Summary)];
    self.navigationItem.rightBarButtonItem = aleftbarButton;

    
   // VideoArray = [[NSMutableArray alloc]initWithObjects:@"Mylan AdD3.mp4", nil];
    
    VideoArray = [[NSMutableArray alloc]init];
    aParents = [[NSMutableArray alloc]init];
    
    Content *aContent = [Utility getContentIfExist:ContentID];
    
    aParents = [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
    
    for (int i=0; i< [[aContent.parent allObjects] count]; i++)
    {
        Parent *aParent = [[aContent.parent allObjects] objectAtIndex:i];
        
        for (int j = 0; j < [[aParent.childs allObjects]count]; j++) {
            Child *aChild = [[aParent.childs allObjects] objectAtIndex:j];
            
            if (aChild.contentType == [NSNumber numberWithInt:3]) {
                
                [VideoArray addObject:aChild];
            }
        }
        
    }

    
    [self loadGridView];
    
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
       Content *aContent = [Utility getContentIfExist:ContentID];
      
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
        
        aContent.vidEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [aAppDelegate.managedObjectContext save:nil];
       
        // in the navigation stack.
        
    }
    [super viewWillDisappear:animated];
}
- (void)loadGridView {
    
    CGFloat gridViewWidth = 150.0f;
    CGFloat gridViewHeight = 150.0f;
    int i = 0;
    int j = 1;
    int  k=0;
    NSInteger extrarow;
    if (([VideoArray count]%5)<5 ) {
        extrarow = 1;
    }
    else{
        
        extrarow=0;
    }
    NSInteger numberofRows = ([VideoArray count]/5)+extrarow;
    
    for( j=1; j<=numberofRows ; j++ ) {
		for( i=0;i<5 && k<[VideoArray count]; i++ ) {
        
            GridView *aGridView = [[GridView alloc] init];
            aGridView.tag = k + 1;
            
            CGRect rect;
            Child *achild = [VideoArray objectAtIndex:k++];
            aVideoPath = achild.filePath;
            rect = CGRectMake( i *(gridViewWidth+40)+50, (j-1)*(gridViewHeight+25)+50, gridViewWidth+30, gridViewHeight);
            
            aGridView.frame = rect;
            aGridView.aDelegate = self;
            
            
            NSURL *targetURL = [NSURL fileURLWithPath:aVideoPath];

            MPMoviePlayerController *mpPlayer = [[MPMoviePlayerController alloc] init];
            [mpPlayer setContentURL:targetURL];
            [mpPlayer.view setFrame:CGRectMake(0, 0, gridViewWidth+30, gridViewHeight)];
            [mpPlayer setMovieSourceType:MPMovieSourceTypeFile];
            [mpPlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [mpPlayer pause];
            
            [aGridView addSubview:mpPlayer.view];
            

            
            aGridView.backgroundColor =
            [UIColor whiteColor];
            aGridView.layer.cornerRadius = 8.0;
            aGridView.layer.borderWidth = 3.0;
            aGridView.layer.borderColor = [UIColor grayColor].CGColor;
            aGridView.layer.shadowOffset = CGSizeMake(aGridView.frame.size.width, aGridView.frame.size.height);
            [self.view addSubview:aGridView];
            [aGridView layoutIfNeeded];
            [aGridView release];
            aGridView = nil;
            
        }
        
        
    }
}

-(void)Summary
{
    SummaryViewController *aSummViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    aSummViewController.aParents = aParents;
    aSummViewController.ContentID = ContentID;

    [self presentModalViewController:aSummViewController animated:YES];
    [aSummViewController release];
    aSummViewController = nil;
    
}
-(void)didVideoSelected:(GridView *)inGridView{
    NSLog(@"Video Selected");
    
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 30, 600,600)];
//    NSString *urlStr = [VideoArray objectAtIndex:inGridView.tag-1];
//  NSURL *targetURL = [NSURL fileURLWithPath:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:(void (^)(void)) ^{
                         
                        BOOL doesContain;
                         
                         doesContain = [self.view.subviews containsObject:animatedVideoView];
                         if (doesContain == YES) {
                             [animatedVideoView removeFromSuperview];
                         }
                         
                         animatedVideoView = [[AnimatedVidoeView alloc]initWithFrame:CGRectMake(0, 0, 600, 600)];
                         animatedVideoView.tag = inGridView.tag-1;
                         animatedVideoView.center =CGPointMake(1024/2, 768/2);
                         
                         //animatedView.alpha = 0.0;
                         animatedVideoView.aDelegate = self;
                         
                         Child *aChild = [VideoArray objectAtIndex:inGridView.tag-1];
                         achild = aChild;
                         NSString *urlStr = aChild.filePath;
                         NSURL *targetURL = [NSURL fileURLWithPath:urlStr];
                         NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
                        
                         [animatedVideoView.webView loadRequest:request];
                         [self.view addSubview:animatedVideoView];
                         
                         //[self.animatedVideoView.webView loadRequest:[NSURLRequest requestWithURL:aUrl]];
                         
                         
                         animatedVideoView.transform=CGAffineTransformMakeScale(1,1);
                         
                     }
                     completion:^(BOOL finished){
                     }];
    
    self.timerStartDate = [[NSDate date] retain];
    [self startChildTimer:inGridView.tag-1];
    
    
}



-(void)startChildTimer:(int)itemTag{
    
    //Called when tapped on the child
    
    
   self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0                                                               target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
    
}
- (void)updateTimer{
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"childid = %@",achild.childid];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aChildArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    if ([aChildArr count]> 0) {
        
        
        Child *aChild = [aChildArr objectAtIndex:0];
        
        achild = aChild;
        
        if (aChild.childStartTime.length == 0) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            aChild.childStartTime = [dateFormatter1 stringFromDate:[NSDate date]];;
            NSLog(@"Child Start Time = %@ for child %@",aChild.childStartTime,aChild.childName);
            
        }
        
        
        
        if (aChild.childViewTime.length > 0) {
            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[aChild.timeInterval doubleValue]];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"mm:ss"];
            [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
            NSString *timeString = [dateFormatter1 stringFromDate:timerDate];
            aChild.childViewTime = timeString;
            // NSLog(@"timeString : %@",timeString);
            self.childTimeInterval = [aChild.timeInterval doubleValue] + 1;
        }
        else {
            NSDate *currentDate1 = [NSDate date];
            NSTimeInterval timeInterval = [currentDate1 timeIntervalSinceDate:_timerStartDate];
            // Add the saved interval
            timeInterval += self.secondsAlreadyRun;
            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
            NSString *timeString=[dateFormatter stringFromDate:timerDate];
            achild.childViewTime = timeString;
            // NSLog(@"timeString : %@",timeString);
            self.childTimeInterval = timeInterval;
            [dateFormatter release];
            aChild.childViewTime = timeString;
        }
        
        aChild.timeInterval = [NSNumber numberWithDouble:self.childTimeInterval];
        
        
        [aAppDelegate.managedObjectContext save:nil];
    }
}

-(void)stopChildTimer {
//    self.slideSubView.timeLabel = (UILabel *)[self.slideSubView viewWithTag:100 + self
//                                              .slideSubView.tag];
//    self.slideSubView.timeLabel.text = self.child.childViewTime;
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"childid = %@",achild.childid];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aChildArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    
    if ([aChildArr count] > 0)
    {
        Child *aChild = [aChildArr objectAtIndex:0];
        achild = aChild;
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
        
        self.ChildEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
        aChild.childEndTime = self.ChildEndTime;
        NSLog(@"Child End Time = %@ for child %@",aChild.childEndTime,aChild.childName);
        
        [aAppDelegate.managedObjectContext save:nil];
        
        
        [self.stopWatchTimer invalidate];
    }
    
}

- (void)didDoubleTapVideo:(AnimatedVidoeView *)inAnimVideoView{
    
    NSLog(@"Close on double tap");
    [self stopChildTimer];
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         [self.animatedVideoView.webView loadHTMLString:nil baseURL:nil];
                         self.animatedVideoView.alpha = 0.0;
                         self.animatedVideoView.transform=CGAffineTransformMakeScale(0.0, 0.0);
                         
                     }
                     completion:^(BOOL finished){
                         // self.animatedView.transform=CGAffineTransformIdentity;
                     }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
