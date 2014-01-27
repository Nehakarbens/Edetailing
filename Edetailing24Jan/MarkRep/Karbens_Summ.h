//
//  Karbens_Summ.h
//  EDetailing
//
//  Created by Karbens on 1/9/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Summ : NSObject <NSCoding>
{
    NSNumber * SummId;
    NSString * SummName;
    
    NSString * SummViewTime;
    NSNumber * SummtimeInterval;
    NSString * SummStartTime;
    NSString * SummEndTime;
    
}


@property (nonatomic, retain) NSNumber * SummId;
@property (nonatomic, retain) NSString * SummName;
@property (nonatomic, retain)NSString * SummViewTime;
@property (nonatomic, retain)NSNumber * SummtimeInterval;
@property (nonatomic, retain)NSString * SummStartTime;
@property (nonatomic, retain)NSString * SummEndTime;

@end
