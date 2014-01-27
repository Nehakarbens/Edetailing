//
//  DataListViewController.m
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "DataListViewController.h"
#import "SummaryViewController.h"
#import "Content.h"
#import "Utility.h"
#import "DataList.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "TimeRecord.h"
@interface DataListViewController ()

@end

@implementation DataListViewController

@synthesize DataListScrollView,DataSlidesArray,selectedSlideIndex,pageControl,ButtonView,datalistsArr,ContentID,aParents;
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
    [self.view addSubview:DataListScrollView];
    
    DataSlidesArray = [[NSMutableArray alloc]init];
    Content *aContent = [Utility getContentIfExist:ContentID];
    
    datalistsArr = [[NSMutableArray alloc]initWithArray:[[aContent datalist]allObjects]];
    
    
    for (int i=0; i< [[aContent.datalist allObjects] count]; i++)
    {
        DataList *aDataList = [[aContent.datalist allObjects] objectAtIndex:i];
        
        [DataSlidesArray addObject:aDataList];
    }
    
    [self loadDataSlides];
    
    DataListScrollView.delegate = self;
    
    if ([DataSlidesArray count] != 0) {

        //[self.view addSubview:ButtonView];
    
        [self loadButton];
        [[[ButtonView subviews]objectAtIndex:0]SlideSelected];
        
        self.selectedSlideIndex = 0;
        
        self.DLTimerStartDate = [NSDate date];

        self.DLStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(startDataListTimer)
                                                               userInfo:nil
                                                                repeats:NO];
        

    }

    
    
    UIBarButtonItem *aleftbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStyleBordered target:self action:@selector(Summary)];
    aleftbarButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = aleftbarButton;
    
    self.navigationItem.title = @"DataList";
   //    self.DLStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                             target:self
//                                                           selector:@selector(startDataListTimer)
//                                                           userInfo:nil
//                                                            repeats:NO];
    

    

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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        Content *aContent = [Utility getContentIfExist:ContentID];
//        
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
//        
//        aContent.dlendTime =  [dateFormatter1 stringFromDate:[NSDate date]];
//        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [aAppDelegate.managedObjectContext save:nil];
        
        // in the navigation stack.
        
        if (DataSlidesArray.count == 1) {
            [self stopDatalListTimer];
        }
        
    }
    [super viewWillDisappear:animated];
}
-(void)loadDataSlides{
    
    DataListScrollView.pagingEnabled = YES;
    CGFloat x = (self.view.frame.size.width/2) - 480.0;
    NSLog(@"x : %f",x);
    CGFloat y = 50.0;
    
    for (DataList *dataList in DataSlidesArray) {
    
        UIView *aView = [[UIView alloc] init];
        aView.frame = CGRectMake(x, y,980, 600);
        aView.backgroundColor = [UIColor grayColor];
        
        aView.layer.borderColor = [UIColor blackColor].CGColor;
        aView.layer.borderWidth = 2.0;
        aView.layer.shadowColor = [UIColor blackColor].CGColor;
        aView.layer.shadowOffset = CGSizeMake(0, aView.frame.size.height+10);
        aView.layer.shadowOpacity = 0.3;
        aView.tag = [DataSlidesArray indexOfObject:dataList];
        
        if ([dataList.dlType isEqualToString:@"1"])
        {
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,980, 600)];
            [webView loadHTMLString:dataList.dlDescription baseURL:nil];
            [aView addSubview:webView];
            [webView release];
            webView = nil;
        }

        else if ([dataList.dlType isEqualToString:@"2"])
        {
        
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,980, 600)];
            NSData *data = [NSData dataWithContentsOfFile:dataList.dlFilepath];
            UIImage *image = [UIImage imageWithData:data];
            mainImgView.image = image;
            [aView addSubview:mainImgView];
            [mainImgView release];
            mainImgView = nil;
    
        }
        else if ([dataList.dlType isEqualToString:@"3"])
        {
//            MPMoviePlayerController *mpPlayer = [[MPMoviePlayerController alloc] init];
//            [mpPlayer setContentURL:[NSURL fileURLWithPath:dataList.dlFilepath]];
//            [mpPlayer.view setFrame:CGRectMake(0, 0,980, 600)];
//            [mpPlayer setMovieSourceType:MPMovieSourceTypeFile];
//            [mpPlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//            [mpPlayer pause];
            
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,980, 600)];
            NSData *data = [NSData dataWithContentsOfFile:dataList.dlFilepath];
            [webView loadData:data MIMEType: @"application/pdf" textEncodingName: nil baseURL:nil];
            [aView addSubview:webView];
            webView = nil;
            [webView release];
            
           
        }
        
        x = x + self.DataListScrollView.frame.size.width ;
        
        [self.DataListScrollView addSubview:aView];
        self.DataListScrollView.contentOffset = CGPointMake(x, 0);
        [aView release];
        aView = nil;
        
    }
    
    DataListScrollView.contentSize = CGSizeMake(x, 0);
    DataListScrollView.contentOffset = CGPointMake(0, 0);
    
}
- (void)didSlideThumbClicked:(ThumbView *)inThumbView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    int aTag = inThumbView.tag - 1;
    self.selectedSlideIndex = self.selectedSlide;
   // self.selectedSlideIndex = aTag;
    //self.pageControl.currentPage = aTag;
    self.DataListScrollView.contentOffset = CGPointMake(self.DataListScrollView.frame.size.width * aTag, 0);
    [UIView commitAnimations];
    
    
}


- (void)loadButton {

 
    CGFloat xVal = 120.0;
    CGFloat yVal = 70.0;
    CGFloat thumbWidth = 128;
    CGFloat thumbHeight = 50;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [DataSlidesArray count];
    int i = 0;
    
    for (DataList *datalist in DataSlidesArray)
    {
        
        ThumbView *aThumbView = [[ThumbView alloc] init];
        aThumbView.aDelegate = self;
        aThumbView.tag = i+1;
        aThumbView.frame = CGRectMake(xVal ,yVal, thumbWidth, thumbHeight);
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10 ,10, thumbWidth-10, 30)];
        lbl.text = datalist.dlTopic;
        lbl.numberOfLines = 2;
        [aThumbView addSubview:lbl];
        
        xVal = xVal + thumbWidth + 10;
        
        [self.view addSubview:aThumbView];
        [ButtonView addSubview:aThumbView];
        
        [aThumbView release];
        aThumbView = nil;
        i++;
    }
    
    ButtonView.frame = CGRectMake(10, 10, xVal, 50);
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger previousPage = 0;
    ThumbView *aThumbView = [[ThumbView alloc] init];
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
   
      if (previousPage != page) {
        // Page has changed
      
        previousPage = page;
          for (aThumbView in [ButtonView subviews]) {
              if (aThumbView == [[ButtonView subviews]objectAtIndex:previousPage]) {
                 [aThumbView SlideSelected];
                  NSLog(@"PAGE Select= %d",aThumbView.tag-1);
                  self.selectedSlide = aThumbView.tag-1;
                  
 
                  
              }
              else{
                  [aThumbView SlideDeSelected];
                    NSLog(@"PAGE Deselect = %d",aThumbView.tag-1);
//                  self.selectedSlideIndex = aThumbView.tag-1;
////                  self.DLTimerStartDate = [NSDate date];
//                  [self stopDatalListTimer];
                 
//
//                  self.DLStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                                           target:self
//                                                                         selector:@selector(startDataListTimer)
//                                                                         userInfo:nil
//                                                                          repeats:NO];
//                  page = lround(scrollView.contentOffset.x /
//                                                        (scrollView.contentSize.width / self.pageControl.numberOfPages));
                  //self.selectedSlideIndex = aThumbView.tag;

                  
              }
              
          }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    
    if (scrollView == self.DataListScrollView)
    {
        self.DLTimerStartDate = [NSDate date];
        
        [self stopDatalListTimer];
        
        
        
        
        
//       NSInteger  currentPage = lround(scrollView.contentOffset.x /
//                                              (scrollView.contentSize.width /[[DataListScrollView subviews]count]-1));
        
        self.selectedSlideIndex = self.selectedSlide;
        NSLog(@"selectedslideIndex = %d",self.selectedSlideIndex);
        self.DLStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(startDataListTimer)
                                                               userInfo:nil
                                                                repeats:NO];

    }
    
}

-(void)startDataListTimer {
    
//    NSDate *currentDate1 = [NSDate date];
//
//    NSTimeInterval timeInterval = [currentDate1 timeIntervalSinceDate:self.DLTimerStartDate];
//    // Add the saved interval
//    timeInterval += self.DLecondsAlreadyRun;
//    
//    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"mm:ss"];
//    
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//    
//    self.DLTimeInterval = timeInterval;
    

    Content *aContent = [Utility getContentIfExist:ContentID];
    
    NSArray *aDatatListArray = [[NSMutableArray alloc]initWithArray:[[aContent datalist]allObjects]];
    
    DataList *aDataList = [aDatatListArray objectAtIndex:self.selectedSlideIndex];

    
  
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];

        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
        
        self.DLStartTime =  [dateFormatter1 stringFromDate:[NSDate date]];
        NSLog(@"DLStartTime %@ for DL %d",self.DLStartTime,self.selectedSlideIndex);
    
        if (aDataList.dlstartTime.length == 0)
        {
            [self SaveSelectedDatalist:aDataList.dlid];
    
        }
    
    
//    if (aDataList.dlViewTime.length == 0)
//    {
//        NSString *timeString = [dateFormatter stringFromDate:timerDate];
//        self.DLViewTime = timeString;
//    }
//    else
//    {
//        
//        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[aDataList.dlTimeInterval doubleValue]];
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"mm:ss"];
//        [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//        NSString *timeString = [dateFormatter1 stringFromDate:timerDate];
//        self.DLViewTime = timeString;
//        // NSLog(@"timeString : %@",timeString);
//        self.DLTimeInterval = [aDataList.dlTimeInterval doubleValue] + 1;
//    }
    
   
    
}

- (void *)SaveSelectedDatalist:(NSNumber *)inDLId {
    
    DataList *adatalist = nil;
  
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"dlid = %@",inDLId];
    
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aDatalistArray = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    if (aDatalistArray.count) {
        adatalist = [aDatalistArray objectAtIndex:0];
        if (adatalist.dlstartTime.length == 0)
        {
            adatalist.dlstartTime = self.DLStartTime;
//            adatalist.dlViewTime = self.DLViewTime;
//            adatalist.dlTimeInterval = [NSNumber numberWithDouble:self.DLTimeInterval];
            [aAppDelegate.managedObjectContext save:nil];
        }
    }
    
}

-(void)stopDatalListTimer{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    
    self.DLEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
    
    unsigned int value1=[Time converstionofmilliseconds:self.DLStartTime];
    unsigned int value2=[Time converstionofmilliseconds:self.DLEndTime];
    NSString *timediff=[Time difference:value1 betweenthem:value2];
    
    self.DLTimeInterval = [timediff doubleValue];
    
    
    

    Content *aContent = [Utility getContentIfExist:ContentID];
    
    NSArray *ArrayDataList = [[NSMutableArray alloc]initWithArray:[[aContent datalist]allObjects]];

    DataList *aDatalist = [ArrayDataList objectAtIndex:self.selectedSlideIndex];
  
    if ([aDatalist.dlViewTime length] ==0) {
        self.DLViewTime  = timediff;
    }
    else{
        self.DLViewTime =[NSString stringWithFormat:@"%d",[timediff intValue]+ [aDatalist.dlViewTime intValue]];
    }

    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"dlid = %@",aDatalist.dlid];
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *aDLEntity = [NSEntityDescription entityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [aFetchRequest setEntity:aDLEntity];
    
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aDLArray = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    if (aDLArray.count) {
        aDatalist = [aDLArray objectAtIndex:0];
        aDatalist.dlEndTime = self.DLEndTime;
        aDatalist.dlViewTime = self.DLViewTime;
        aDatalist.dlTimeInterval = [NSNumber numberWithDouble:self.DLTimeInterval];

        NSLog(@"DLEndTime %@ for Slide %d",self.DLEndTime,self.selectedSlideIndex);
        
        [aAppDelegate.managedObjectContext save:nil];
    }
    self.DLViewTime = nil;
    self.DLTimeInterval = 0;
    
    NSLog(@"DataList StartTime = %@ , DataList End Time = %@ ,DataList View Time = %@,DataList TimeInterval = %@ for parentID = %@",self.DLStartTime,self.DLEndTime,aDatalist.dlViewTime,aDatalist.dlTimeInterval,aDatalist.dlTopic);

    [self.DLStopWatchTimer invalidate];
    
    // Called when swiped out of current parent
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [DataListScrollView release];
    [ButtonView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDataListScrollView:nil];
    [self setButtonView:nil];
    [super viewDidUnload];
}
@end
