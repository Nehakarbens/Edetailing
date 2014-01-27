//
//  Karbens_Content.h
//  EDetailing
//
//  Created by Akshay Kunila on 26/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karbens_Content : NSObject <NSCoding>
{
    NSNumber * contentId;
    NSString * contentName;
    NSString * contStartTime;
    NSString * contEndTime;
    NSMutableArray *parent;
    NSMutableArray *datalists,*Summarys;
    
}

@property (nonatomic, retain) NSNumber * contentId;
@property (nonatomic, retain) NSString * contentName;
@property (nonatomic, retain) NSString * contStartTime;
@property (nonatomic, retain) NSString * contEndTime;
@property (nonatomic, retain) NSMutableArray *parent,*Summarys,*datalists;

@end



//NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notes];

//NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];