//
//  Summary.h
//  EDetailing
//
//  Created by Karbens on 1/3/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content;

@interface Summary : NSManagedObject

@property (nonatomic, retain) NSString * summfilePath;
@property (nonatomic, retain) NSNumber * summID;
@property (nonatomic, retain) NSString * summTitle;
@property (nonatomic, retain) NSString * summType;
@property (nonatomic, retain) NSString * summURL;
@property (nonatomic, retain) NSString * summStartTime;
@property (nonatomic, retain) NSString * summEndTime;
@property (nonatomic, retain) NSNumber * summTimeInterval;
@property (nonatomic, retain) NSString * summViewTime;
@property (nonatomic, retain) Content *content;

@end
