//
//  Karbens_datalist.m
//  EDetailing
//
//  Created by Karbens on 1/9/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import "Karbens_datalist.h"

@implementation Karbens_datalist

@synthesize DLId,DLName,DLtimeInterval,DLViewTime,DLEndTime,DLStartTime;


- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.DLId = [decoder decodeObjectForKey:@"DLId"];
        self.DLName = [decoder decodeObjectForKey:@"DLName"];
        self.DLStartTime= [decoder decodeObjectForKey:@"DLStartTime"];
        self.DLEndTime= [decoder decodeObjectForKey:@"DLEndTime"];
        self.DLViewTime= [decoder decodeObjectForKey:@"DLViewTime"];
        self.DLtimeInterval= [decoder decodeObjectForKey:@"DLtimeInterval"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:DLId forKey:@"DLId"];
    [encoder encodeObject:DLName forKey:@"DLName"];
    [encoder encodeObject:DLStartTime forKey:@"DLStartTime"];
    [encoder encodeObject:DLEndTime forKey:@"DLEndTime"];
    [encoder encodeObject:DLViewTime forKey:@"DLViewTime"];
    [encoder encodeObject:DLtimeInterval forKey:@"DLtimeInterval"];
}


@end
