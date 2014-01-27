//
//  MRParentViewController.h
//  MarkRep
//
//  Created by virupaksh on 12/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
//#import "MasterDetailsViewController.h"
#import "ThumbView.h"
#import "AnimatedView.h"
#import "AnimatedVidoeView.h"
#import "SlidesSubView.h"
#import "TimeRecorder.h"
#import <QuickLook/QuickLook.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MRParentViewController : UIViewController<MasterViewDelegate,ThumbViewDelegate,SlidesSubViewDelegate,AnimatedViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,AnimatedVideoViewDelegate> {
    
    int currentDisplayedTag;
    BOOL isSelect;
    NSMutableDictionary *StateDict;
    NSMutableArray *aParents;
        
}
@property(nonatomic,retain)NSMutableArray *aParents;
@property (nonatomic, retain) MasterViewController *masterViewController;
@property (nonatomic, retain) UINavigationController *masterNavController;

//@property (nonatomic, retain) MasterDetailsViewController *detailsViewController;
@property (nonatomic ,retain) UINavigationController *masterDetailsNavController;

@property (retain, nonatomic) IBOutlet UIScrollView *slidesScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *slideDetailsScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIImageView *animatedImageView;

@property (nonatomic, retain) AnimatedView *animatedView;
@property (nonatomic,retain) AnimatedVidoeView *animatedVideoView;

@property (nonatomic, assign) BOOL isShowPressed;
@property (nonatomic, assign) int selectedSlideIndex;

@property (retain, nonatomic) IBOutlet UIView *popOverView;
@property (retain, nonatomic) IBOutlet UITableView *referenceTableView;

@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) UIViewController *popOverContentController;

@property (nonatomic, retain) NSTimer *stopWatchTimer;
@property (nonatomic, assign) NSInteger secondsAlreadyRun;
@property (retain, nonatomic) NSDate *timerStartDate;

@property (nonatomic, retain) NSTimer *parentStopWatchTimer;
@property (nonatomic, assign) int      parentSecondsAlreadyRun;
@property (nonatomic, retain) NSDate   *parentTimerStartDate;

@property (retain, nonatomic) IBOutlet UIView *parentHostView;
@property (retain, nonatomic) IBOutlet UIView *exitView;
@property (retain, nonatomic) IBOutlet UIButton *exitButton;
@property (nonatomic,retain) UIWebView *webView ;
@property (nonatomic,retain) MPMoviePlayerController *mpPlayer;

@property(nonatomic,retain)NSString *timerString,*back;

@property(nonatomic,retain) NSNumber *ContentID;
@property(nonatomic,retain) NSNumber *BrandID;

@property (nonatomic,retain) NSMutableArray *refArray;

#pragma mark - Actions
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)exitButtonPressed:(id)sender;

@end
