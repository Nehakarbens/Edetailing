//
//  Karbens_Reference.h
//  EDetailing
//
//  Created by Akshay Kunila on 27/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Reference : NSObject <NSCoding>
{
    NSNumber * referenceId;
    NSString * referenceName;
    
    NSString * referenceViewTime;
    NSNumber * referencetimeInterval;
    NSString * referenceStartTime;
    NSString * referenceEndTime;

}


@property (nonatomic, retain) NSNumber * referenceId;
@property (nonatomic, retain) NSString * referenceName;
@property (nonatomic, retain)NSString * referenceViewTime;
@property (nonatomic, retain)NSNumber * referencetimeInterval;
@property (nonatomic, retain)NSString * referenceStartTime;
@property (nonatomic, retain)NSString * referenceEndTime;


@end
