//
//  ContentRefLinksViewController.h
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import <QuickLook/QuickLook.h>
#import "Reference.h"

@interface ContentRefLinksViewController : UIViewController <UIWebViewDelegate,GridViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,QLPreviewItem>
{
    
    NSMutableArray *PdfArray;
    Reference *areference;
}
@property (nonatomic, assign) NSTimeInterval refTimeInterval;
@property (nonatomic, assign) NSInteger secondsAlreadyRun;
@property (retain, nonatomic) NSDate *timerStartDate;
@property (nonatomic, retain) NSString *refStartTime,*refEndTime,*refViewTime,*back;
@property (nonatomic, retain) NSTimer *stopWatchTimer;

@property(nonatomic,retain)NSNumber *ContentID;
@property (nonatomic,retain) NSString *aRefPath ;
@property(nonatomic,retain)NSMutableArray *PdfArray,*aParents;
-(void)didBrandSelected:(GridView *)inGridView;
-(void)startChildTimer:(int)itemTag;
-(void)stopChildTimer ;

@end
