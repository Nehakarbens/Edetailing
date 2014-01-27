//
//  Karbens_Video.h
//  EDetailing
//
//  Created by Karbens on 1/9/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Video : NSObject <NSCoding>
{
    NSNumber * VideoId;
    NSString * VideoName;
    
    NSString * VideoViewTime;
    NSNumber * VideotimeInterval;
    NSString * VideoStartTime;
    NSString * VideoEndTime;
    
}


@property (nonatomic, retain) NSNumber * VideoId;
@property (nonatomic, retain) NSString * VideoName;
@property (nonatomic, retain)NSString * VideoViewTime;
@property (nonatomic, retain)NSNumber * VideotimeInterval;
@property (nonatomic, retain)NSString * VideoStartTime;
@property (nonatomic, retain)NSString * VideoEndTime;


@end
