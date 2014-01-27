//
//  Karbens_Brand.h
//  EDetailing
//
//  Created by Akshay Kunila on 26/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Brand : NSObject <NSCoding>
{
    NSString * brandName;
    NSNumber * brandId;
    NSMutableArray *contents;
    NSString * contStartTime;//
    NSString * contEndTime;//
}

@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSNumber * brandId;
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) NSString * contStartTime;//
@property (nonatomic, retain) NSString * contEndTime;//

@end
