//
//  ContentDownloader.h
//  MyDay
//
//  Created by Karbens on 10/31/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

@class ASINetworkQueue;


@protocol ContentDownloaderDelegate

-(void)didFailDownloadWithError:(NSError*)error;
- (void)didFinishDownload:(NSMutableDictionary*)request;
- (void)didFinishAllDownload:(NSMutableDictionary *)Queue;
//- (void)didFinishAllDownload;

@end


@interface ContentDownloader : NSObject

{
    ASINetworkQueue *networkQueue;
    UIProgressView *progressBar;
    int contentIndex;
    BOOL failed;
    BOOL _isIntrpted;
    id aDelegate;
    int dwnProgress;
    

}
@property(nonatomic,retain) ASINetworkQueue *networkQueue;
@property(nonatomic,assign) id <ContentDownloaderDelegate> aDelegate;
@property(nonatomic,assign) int contentIndex;
@property(nonatomic,assign) int dwnProgress;
@property(nonatomic,retain)NSMutableArray *QueueArray,*ChildContentURLArray,*ReferenceURLArray;
@property(nonatomic,retain)NSString *ErrorString;

-(void)PausedContentObject;
-(void)DownloadContentObject :(NSMutableDictionary *)aContent;

@end

