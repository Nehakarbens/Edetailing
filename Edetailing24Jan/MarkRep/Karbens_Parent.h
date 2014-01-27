//
//  Karbens_Parent.h
//  EDetailing
//
//  Created by Akshay Kunila on 27/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Parent : NSObject <NSCoding>
{

    NSNumber * hasChilds;
    NSNumber * parentid;
    NSString * parentName;
    NSString * parentViewTime;
   
    NSNumber * timeInterval;
    NSDate * viewDate;
    NSString * parentStartTime;
    NSString * parentEndTime;
    NSMutableArray *childs;
}

@property (nonatomic, retain) NSNumber * hasChilds;
@property (nonatomic, retain) NSNumber * parentid;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) NSString * parentViewTime;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) NSDate * viewDate;
@property (nonatomic, retain) NSString * parentStartTime;
@property (nonatomic, retain) NSString * parentEndTime;
@property (nonatomic, retain) NSMutableArray *childs;

@end
