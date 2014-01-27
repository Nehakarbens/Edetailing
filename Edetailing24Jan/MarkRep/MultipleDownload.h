//
//  MultipleDownload.h
//
//  Created by Akshay Kunila on 14/09/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleDownload : NSObject {
	
    NSMutableArray *urls;
	NSMutableDictionary *requests;
	NSMutableArray *receivedDatas;
	NSInteger finishCount;
	id delegate;
	
}

@property (nonatomic,retain) NSMutableArray *urls;
@property (nonatomic,retain) NSMutableDictionary *requests;
@property (nonatomic,retain) NSMutableArray *receivedDatas;
@property NSInteger finishCount;
@property (retain) id delegate;


- (id)initWithUrls:(NSArray *)aUrls;
- (void)requestWithUrls:(NSArray *)aUrls;
- (NSData *)dataAtIndex:(NSInteger)idx;
- (NSString *)dataAsStringAtIndex:(NSInteger)idx;
- (void)setDelegate:(id)val;
- (id)delegate;

@end

@interface NSObject (MultipleDownloadDelegateMethods)

-(void)didFailDownloadWithError:(NSError*)error;
- (void)didFinishDownload:(NSNumber*)idx;
- (void)didFinishAllDownload;

@end
