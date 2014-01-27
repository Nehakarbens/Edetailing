//
//  ContentViewController.h
//  MyDay
//
//  Created by Akshay Kunila on 03/09/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "MRParentViewController.h"
#import "Parent.h"
#import "Parser.h"
#import "MultipleDownload.h"
#import "ContentDownloader.h"
@class ASINetworkQueue;
@class MultipleDownload;

@interface ContentViewController : UIViewController <GridViewDelegate,ParserDelegate,NSFetchedResultsControllerDelegate,ContentDownloaderDelegate> {
    UIProgressView *DownloadProgressBar;
    ASINetworkQueue *networkQueue;
    BOOL failed,_isFirstTime;
    Parent *aParent;
    //Content *aContent;
    MultipleDownload *downloads;
     NSString *date, *UrlStr;
    ContentDownloader *contDownlaod;
    UILabel *UpdateLable;
    NSUInteger brandIndex;
    NSNumber *brandID;
    NSNumber *contentID;
    BOOL isDetailing;
}
@property (nonatomic,retain)NSNumber *brandID;
@property (assign,nonatomic)NSUInteger brandIndex;
@property (nonatomic,retain)NSNumber *contentID;
@property (nonatomic,assign)BOOL isDetailing;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain) UILabel *UpdateLable;
@property (nonatomic, retain) NSMutableArray *contents,*downloadUrls, *ContentIDArray,*aDataBaseContent,*ContentLastDateDownArr,*gridViewArray;
@property (nonatomic,retain) NSArray * UpdatedContents;
@property(nonatomic,retain) NSMutableDictionary *ContentDict;
@property(nonatomic,retain) NSMutableArray *DownloadArr;
-(void)UpdateProgressBar;

@end
