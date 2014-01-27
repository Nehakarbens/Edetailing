//
//  Utility.h
//  MarkRep
//
//  Created by virupaksh on 13/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Content,Parent,Child,Brand,Reference,DataList,Summary;


@interface Utility : NSObject {
   
}
@property(nonatomic,retain) NSMutableArray *contents;

#pragma mark - Fetch Contents
+ (NSMutableArray *)getContentsFromPlist;
+ (NSMutableArray *)getContentsFromPlist2;
+ (NSMutableArray *)getParsedContents:(NSMutableArray *) brandArray;


#pragma mark - Clear slideview times
+ (void)clearSlideViewTimes;
+ (Brand *)getBrandIfExist:(NSNumber *)bid;
- (BOOL *)checkContentExist:(NSNumber *)cid;
+ (Content *)getContentIfExist:(NSNumber *)cid;
+ (Parent *)getParentIfExist:(NSNumber *)pid;
+ (Child *)getChildIfExist:(NSNumber *)cid;
+ (Reference *)getRefIfExist:(NSNumber *)rid;
+ (DataList *)getDataListIfExist:(NSNumber *)Did;
+ (Summary *)getSummaryIfExist:(NSNumber *)sid;

+ (BOOL )checkIfBrandFilePathExist:(NSNumber *)Bid;
+ (BOOL )checkIfChildFilePathExist:(NSNumber *)cid;
+ (BOOL )checkIfParentFilePathExist:(NSNumber *)pid;
+ (BOOL )checkIfReferenceFilePathExist:(NSNumber *)rid;
+ (BOOL )checkIfDataListFilePathExist:(NSNumber *)did;
+ (BOOL )checkIfSummaryFilePathExist:(NSNumber *)Summid;


+ (NSMutableArray *)getAllContents;
+ (NSMutableArray *)getAllBrands;
+ (BOOL)deleteContent:(NSNumber *)cid;
+ (BOOL)deleteParents:(NSNumber *)cid;

+ (Content *)getContentIfExist:(NSNumber *)cid :(NSNumber *)bid;
+ (NSMutableArray *)getBrandsforContent:(NSNumber *)cid;
@end
