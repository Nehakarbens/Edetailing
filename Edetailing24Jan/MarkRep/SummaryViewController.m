//
//  SummaryViewController.m
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "SummaryViewController.h"
#import "Content.h"
#import "Parent.h"
#import "Child.h"
#import "ThumbView.h"
#import "SlidesSubView.h"
#import "Utility.h"
#import "Summary.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "TimeRecord.h"
@interface SummaryViewController ()

@end

@implementation SummaryViewController
@synthesize aParents,SummaryArray,ContentID;

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
    
    self.pageControl.hidden = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    UISwipeGestureRecognizer *aSwipeDownGestureRecg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
//    aSwipeDownGestureRecg.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.view addGestureRecognizer:aSwipeDownGestureRecg];
//    [aSwipeDownGestureRecg release];
//    aSwipeDownGestureRecg = nil;
    
    UISwipeGestureRecognizer *aSwipeUpGestureRecg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    aSwipeUpGestureRecg.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:aSwipeUpGestureRecg];
    [aSwipeUpGestureRecg release];
    aSwipeUpGestureRecg = nil;
    
    
    SummaryArray = [[NSMutableArray alloc]init];
    Content *aContent = [Utility getContentIfExist:ContentID];
    
    SummaryArray = [[NSMutableArray alloc]initWithArray:[[aContent summary]allObjects]];
    
    if ([SummaryArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No summary for this content" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
    }
    else{
        self.SummTimerStartDate = [NSDate date];
        
        self.SummStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(startSummaryTimer)
                                                               userInfo:nil
                                                                repeats:NO];
        

    [self loadParentThumbs];
    
    [self reloadThumbsForIndex];
   
    }
   [[self navigationController] setNavigationBarHidden:YES animated:YES];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self swipeDown];

    }
}
- (void)swipeDown {
    self.isShowPressed = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    
    self.parentHostView.frame = CGRectMake(0, 0, self.parentHostView.frame.size.width, self.parentHostView.frame.size.height);
    [self.slideDetailsScrollView setFrame:CGRectMake(0,128, self.slideDetailsScrollView.frame.size.width, self.slideDetailsScrollView.frame.size.height)];
    [UIView commitAnimations];
    
}
//-(void) viewWillDisappear:(BOOL)animated {
//    [self stopSummTimer];
////   // if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
////        Content *aContent = [Utility getContentIfExist:ContentID];
////        
////        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
////        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
////        
////        aContent.sumEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
////        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [aAppDelegate.managedObjectContext save:nil];
////        
////        // in the navigation stack.
////        
////    
//    [super viewWillDisappear:animated];
//}
- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([SummaryArray count] != 0)
    {
       [self stopSummTimer];
    }
}
- (void)swipeUp {
    
    self.isShowPressed = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    
    [self.slideDetailsScrollView setFrame:CGRectMake(0,0, self.slideDetailsScrollView.frame.size.width, self.slideDetailsScrollView.frame.size.height)];
    self.parentHostView.frame = CGRectMake(0, -self.parentHostView.frame.size.width, self.parentHostView.frame.size.width, self.parentHostView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - slide thumb delegate
- (void)didSlideThumbClicked:(ThumbView *)inThumbView {
    [self swipeUp];

    [self.SummStopWatchTimer invalidate];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    int aTag = inThumbView.tag - 1;
    self.selectedSlideIndex = aTag;
    self.pageControl.currentPage = aTag;
    //self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.slideDetailsScrollView.contentOffset = CGPointMake(self.slideDetailsScrollView.frame.size.width * aTag, 0);
    [UIView commitAnimations];
    
    self.SummTimerStartDate = [[NSDate date] retain];
   
        
        self.SummStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                     target:self
                                                                   selector:@selector(startSummaryTimer)
                                                                   userInfo:nil
                                                                    repeats:NO];
    
    
}

- (void)loadParentThumbs {
    
    CGFloat xVal = 120.0;
    CGFloat yVal = 10.0;
    CGFloat thumbWidth = 115;
    CGFloat thumbHeight = 115;
 
    
//    NSArray *sortedArray = [(NSArray *)SummaryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(localizedStandardCompare:)]]];
    
    self.pageControl.currentPage = 0;
    //self.pageControl.//.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.numberOfPages = [SummaryArray count];
    int i = 0;
    
    
    NSLog(@"parent name =%d",[SummaryArray count]);
    for(Summary *aSumm in SummaryArray){
        ThumbView *aThumbView = [[ThumbView alloc] init];
        aThumbView.aDelegate = self;
        aThumbView.tag = i+1;
        aThumbView.frame = CGRectMake(xVal ,yVal, thumbWidth, thumbHeight);
        
        UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, thumbWidth, thumbHeight)];
        UIImage *image;
        
        
         if ([aSumm.summType isEqualToString:@"1"])
        {
            NSData *data = [NSData dataWithContentsOfFile:aSumm.summfilePath];
            image = [UIImage imageWithData:data];
            mainImgView.image = image;
            
        }
        else if ([aSumm.summType isEqualToString:@"2"])
        {
            MPMoviePlayerController *mpPlayer = [[MPMoviePlayerController alloc] init];
            [mpPlayer setContentURL:[NSURL fileURLWithPath:aSumm.summfilePath]];
            image=[mpPlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                mainImgView.image = image;
        }
        
        [aThumbView addSubview:mainImgView];
        [mainImgView release];
        mainImgView = nil;
        
        
        
        xVal = xVal + thumbWidth + 10;
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 53, 68, 21)];
        aLabel.text = aSumm.summTitle;
        [aLabel setBackgroundColor:[UIColor clearColor]];
        aLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        aLabel.textColor = [UIColor blackColor];
        aLabel.textAlignment = UITextAlignmentCenter;//NSTextAlignmentCenter;//UITextAlignmentCenter;
        [aThumbView addSubview:aLabel];
        [aLabel release];
        aLabel = nil;
        
        [self.slidesScrollView addSubview:aThumbView];
        
        [aThumbView release];
        aThumbView = nil;
        i++;
    }
    
    [self.slidesScrollView setContentSize:CGSizeMake(xVal, 128)];
}

- (void)reloadThumbsForIndex {
    for(UIImageView *aSubView in self.slideDetailsScrollView.subviews){
        [aSubView removeFromSuperview];
    }

       CGFloat x = (768/2) - 350.0;
    NSLog(@"x : %f",x);
    CGFloat y = 20.0;
    int parentIndex = 0;
    
    for(Summary *aSumm in SummaryArray) {
        
        UIView *aView = [[UIView alloc] init];
        aView.frame = CGRectMake(x, y,980, 680);
        aView.backgroundColor = [UIColor grayColor];
        aView.layer.borderColor = [UIColor blackColor].CGColor;
        aView.layer.borderWidth = 2.0;
        aView.layer.shadowColor = [UIColor blackColor].CGColor;
        aView.layer.shadowOffset = CGSizeMake(0, aView.frame.size.height+10);
        aView.layer.shadowOpacity = 0.3;
        
        UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,980, 680)];
     
        UIImage *image;
        
        
        if ([aSumm.summType isEqualToString:@"1"])
        {
            NSData *data = [NSData dataWithContentsOfFile:aSumm.summfilePath];
            image = [UIImage imageWithData:data];
            mainImgView.image = image;
             [aView addSubview:mainImgView];
            
        }
        else if ([aSumm.summType isEqualToString:@"2"])
        {
            MPMoviePlayerController *mpPlayer = [[MPMoviePlayerController alloc] init];
            [mpPlayer setContentURL:[NSURL fileURLWithPath:aSumm.summfilePath]];
            [mpPlayer.view setFrame:CGRectMake(0, 0,980, 680)];

            image=[mpPlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [mpPlayer pause];
            [aView addSubview:mpPlayer.view];
        }


     
        [mainImgView release];
        mainImgView = nil;
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(longTapAction:)];
        longPress.minimumPressDuration = 0.5;
        [aView addGestureRecognizer:longPress];
        [longPress release];

        
        x = x + self.slideDetailsScrollView.frame.size.width -20;
        NSLog(@"scrollX = %f",x);


        
        [self.slideDetailsScrollView addSubview:aView];
        self.slideDetailsScrollView.contentOffset = CGPointMake(x, 0);
        [aView release];
        aView = nil;
        parentIndex ++;
    }
    
    self.slideDetailsScrollView.contentSize = CGSizeMake(x, 0);
    self.slideDetailsScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)longTapAction:(UILongPressGestureRecognizer *) tapRec {
    
    NSLog(@"long tap detected");
    [self swipeDown];
      //self.exitButton.hidden = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    
    if (scrollView == self.slideDetailsScrollView)
    {
        self.SummTimerStartDate = [NSDate date];
        [self stopSummTimer];
            
        self.SummStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                         target:self
                                                                       selector:@selector(startSummaryTimer)
                                                                       userInfo:nil
                                                                        repeats:NO];
            
            
        
        self.pageControl.currentPage = lround(scrollView.contentOffset.x /
                                              (scrollView.contentSize.width / self.pageControl.numberOfPages));
        self.selectedSlideIndex = self.pageControl.currentPage;
        
        
    }
}

-(void)startSummaryTimer {
    
//    NSDate *currentDate1 = [NSDate date];
//    
//    
//    //[aAppDelegate.managedObjectContext save:nil];
//    
//    NSTimeInterval timeInterval = [currentDate1 timeIntervalSinceDate:self.SummTimerStartDate];
//    // Add the saved interval
//    timeInterval += self.SummsecondsAlreadyRun;
//    
//    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"mm:ss"];
//    
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//    
//    self.SummTimeInterval = timeInterval;
    
    Content *aContent = [Utility getContentIfExist:ContentID];
    
    NSArray *aSummaryArray = [[NSMutableArray alloc]initWithArray:[[aContent summary]allObjects]];
    
    Summary *aSumm = [aSummaryArray objectAtIndex:self.selectedSlideIndex];
    NSLog(@"ASummStart = %@",aSumm);
    
    NSLog(@"Intial Summ Start Time = %@ for summ %d",aSumm.summStartTime,self.selectedSlideIndex);
    
  
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        //[dateFormatter1 setDateFormat:@"HH:mm:ss"];
        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
        
        self.SummStartTime =  [dateFormatter1 stringFromDate:[NSDate date]];
        NSLog(@"summStartTime %@ for summ %d",self.SummStartTime,self.selectedSlideIndex);
    if (aSumm.summStartTime.length == 0)
    {
         [self SaveSelectedSumm:aSumm.summID];
    }
    
    
//    if (aSumm.summViewTime.length == 0)
//    {
//        NSString *timeString = [dateFormatter stringFromDate:timerDate];
//        self.SummViewTime = timeString;
//    }
//    else
//    {
//        
//        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[aSumm.summTimeInterval doubleValue]];
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"mm:ss"];
//        [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//        NSString *timeString = [dateFormatter1 stringFromDate:timerDate];
//        self.SummViewTime = timeString;
//        // NSLog(@"timeString : %@",timeString);
//        self.SummTimeInterval = [aSumm.summTimeInterval doubleValue] + 1;
//    }
    
   
    
}

- (void *)SaveSelectedSumm:(NSNumber *)inSummId {
    
    Summary *asumm = nil;
    
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"summID = %@",inSummId];
    
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aSummArray = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    if (aSummArray.count) {
        asumm = [aSummArray objectAtIndex:0];
        if (asumm.summStartTime.length == 0)
        {
            asumm.summStartTime = self.SummStartTime;
            
        }
    }
    
}

-(void)stopSummTimer{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    //[dateFormatter1 setDateFormat:@"dd,MMM,yyyy HH:mm:ss "];
    
    
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    
    self.SummEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
    
    unsigned int value1=[Time converstionofmilliseconds:self.SummStartTime];
    unsigned int value2=[Time converstionofmilliseconds:self.SummEndTime];
    NSString *timediff=[Time difference:value1 betweenthem:value2];
    
    self.SummTimeInterval = [timediff doubleValue];

    
    Content *aContent = [Utility getContentIfExist:ContentID];
    
    NSArray *ArraySumm = [[NSMutableArray alloc]initWithArray:[[aContent summary]allObjects]];
    
    Summary *aSumm = [ArraySumm objectAtIndex:self.selectedSlideIndex];
 
    if ([aSumm.summViewTime length] ==0) {
        self.SummViewTime  = timediff;
    }
    else{
        self.SummViewTime =[NSString stringWithFormat:@"%d",[timediff intValue]+ [aSumm.summViewTime intValue]];
    }

    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"summID = %@",aSumm.summID];
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *aSummEntity = [NSEntityDescription entityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [aFetchRequest setEntity:aSummEntity];
    
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aSummArray = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    if (aSummArray.count) {
        aSumm = [aSummArray objectAtIndex:0];
        aSumm.summEndTime = self.SummEndTime;
        aSumm.summViewTime = self.SummViewTime;
        aSumm.summTimeInterval = [NSNumber numberWithDouble:self.SummTimeInterval];
        [aAppDelegate.managedObjectContext save:nil];

    }
    self.SummViewTime = nil;
    self.SummTimeInterval = 0;
    
    NSLog(@"Summ StartTime = %@ , Summ End Time = %@ ,Summ View Time = %@,Summ TimeInterval = %@ for SummID = %@",self.SummStartTime,self.SummEndTime,aSumm.summViewTime,aSumm.summTimeInterval,aSumm.summTitle);

    [self.SummStopWatchTimer invalidate];
    
    // Called when swiped out of current parent
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
     [_slideDetailsScrollView release];
    [_slidesScrollView release];
    [_pageControl release];
    [_parentHostView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSlideDetailsScrollView:nil];
    [self setSlidesScrollView:nil];
    [self setPageControl:nil];
    [self setParentHostView:nil];
    [super viewDidUnload];
}
@end
