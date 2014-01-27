//
//  SummaryViewController.h
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbView.h"
@interface SummaryViewController : UIViewController<ThumbViewDelegate>
{
    NSMutableArray *aParents;
}
@property (nonatomic, assign) BOOL isShowPressed;

@property (nonatomic,assign) NSMutableArray *aParents,*SummaryArray;
@property (nonatomic,retain) NSNumber *ContentID;
@property (retain, nonatomic) IBOutlet UIView *parentHostView;

@property (retain, nonatomic) IBOutlet UIScrollView *slideDetailsScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (retain, nonatomic) IBOutlet UIScrollView *slidesScrollView;

@property (nonatomic, retain) NSTimer *SummStopWatchTimer;
@property (nonatomic, assign) int      SummsecondsAlreadyRun;
@property (nonatomic, retain) NSDate   *SummTimerStartDate;

@property (nonatomic, retain) NSString *SummViewTime,*SummStartTime,*SummEndTime;
@property (nonatomic, assign) NSTimeInterval SummTimeInterval;

@property (nonatomic, assign) int selectedSlideIndex;

@end
