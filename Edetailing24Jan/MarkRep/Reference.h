//
//  Reference.h
//  EDetailing
//
//  Created by Karbens on 1/2/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Child;

@interface Reference : NSManagedObject

@property (nonatomic, retain) NSString * contentUrl;
@property (nonatomic, retain) NSString * filepath;
@property (nonatomic, retain) NSNumber * referenceId;
@property (nonatomic, retain) NSString * referenceName;
@property (nonatomic, retain) NSString * refStartTime;
@property (nonatomic, retain) NSString * refEndTime;
@property (nonatomic, retain) NSString * refViewTime;
@property (nonatomic, retain) NSNumber * refTimeInterval;
@property (nonatomic, retain) Child *child;

@end
