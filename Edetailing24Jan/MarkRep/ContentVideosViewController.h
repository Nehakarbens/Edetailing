//
//  ContentVideosViewController.h
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "AnimatedVidoeView.h"
#import "Child.h"
@interface ContentVideosViewController : UIViewController<GridViewDelegate,UIGestureRecognizerDelegate,AnimatedVideoViewDelegate>{
    NSMutableArray *aParents;
    Child *achild;
}
@property (nonatomic, assign) NSTimeInterval childTimeInterval;
@property (nonatomic, assign) NSInteger secondsAlreadyRun;
@property (retain, nonatomic) NSDate *timerStartDate;
@property (nonatomic, retain) NSString *ChildStartTime,*ChildEndTime;
@property (nonatomic, retain) NSTimer *stopWatchTimer;

@property(nonatomic,retain)NSMutableArray *VideoArray;
@property(nonatomic,assign)NSMutableArray *aParents;
@property(nonatomic,retain)NSNumber *ContentID;
@property (nonatomic,retain) NSString *aVideoPath ;
@property (nonatomic,retain)AnimatedVidoeView *animatedVideoView;

@end
