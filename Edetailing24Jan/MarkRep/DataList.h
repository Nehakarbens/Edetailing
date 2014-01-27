//
//  DataList.h
//  EDetailing
//
//  Created by Karbens on 1/2/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content;

@interface DataList : NSManagedObject

@property (nonatomic, retain) NSString * dlDescription;
@property (nonatomic, retain) NSString * dlFilepath;
@property (nonatomic, retain) NSNumber * dlid;
@property (nonatomic, retain) NSString * dlTopic;
@property (nonatomic, retain) NSString * dlType;
@property (nonatomic, retain) NSString * dlstartTime;
@property (nonatomic, retain) NSString * dlEndTime;
@property (nonatomic, retain) NSString * dlViewTime;
@property (nonatomic, retain) NSNumber * dlTimeInterval;
@property (nonatomic, retain) Content *content;

@end
