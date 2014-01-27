//
//  Karbens_Child.h
//  EDetailing
//
//  Created by Akshay Kunila on 27/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Child : NSObject <NSCoding>
{

    NSString * childEndTime;
    NSNumber * childid;
    NSString * childName;
    NSString * childStartTime;
    NSString * childViewTime;
    NSNumber * contentType;
    NSNumber * timeInterval;
    NSString * type;
    NSMutableArray *references;


    
}

@property (nonatomic, retain) NSString * childEndTime;
@property (nonatomic, retain) NSNumber * childid;
@property (nonatomic, retain) NSString * childName;
@property (nonatomic, retain) NSString * childStartTime;
@property (nonatomic, retain) NSString * childViewTime;
@property (nonatomic, retain) NSNumber * contentType;

@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSMutableArray *references;

@end
