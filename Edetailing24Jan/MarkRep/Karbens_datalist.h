//
//  Karbens_datalist.h
//  EDetailing
//
//  Created by Karbens on 1/9/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_datalist : NSObject<NSCoding>
{
    NSNumber * DLId;
    NSString * DLName;
    
    NSString * DLViewTime;
    NSNumber * DLtimeInterval;
    NSString * DLStartTime;
    NSString * DLEndTime;
    
}


@property (nonatomic, retain) NSNumber * DLId;
@property (nonatomic, retain) NSString * DLName;
@property (nonatomic, retain)NSString * DLViewTime;
@property (nonatomic, retain)NSNumber * DLtimeInterval;
@property (nonatomic, retain)NSString * DLStartTime;
@property (nonatomic, retain)NSString * DLEndTime;


@end
