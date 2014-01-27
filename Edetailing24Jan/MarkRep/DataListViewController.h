//
//  DataListViewController.h
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbView.h"
@interface DataListViewController : UIViewController< ThumbViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>{
    NSMutableArray *DataSlidesArray;
}
@property (retain, nonatomic)  NSMutableArray *DataSlidesArray,*datalistsArr,*aParents;
@property (retain, nonatomic) IBOutlet UIScrollView *DataListScrollView;
@property (nonatomic, assign) int selectedSlideIndex;
@property (nonatomic, assign) int selectedSlide;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIView *ButtonView;
@property(nonatomic,retain)NSNumber *ContentID;

@property (nonatomic, retain) NSTimer *DLStopWatchTimer;
@property (nonatomic, assign) int      DLecondsAlreadyRun;
@property (nonatomic, retain) NSDate   *DLTimerStartDate;

@property (nonatomic, retain) NSString *DLViewTime,*DLStartTime,*DLEndTime;
@property (nonatomic, assign) NSTimeInterval DLTimeInterval;


- (void) didSlideSelected;
@end
