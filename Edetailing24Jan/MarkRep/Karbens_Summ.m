//
//  Karbens_Summ.m
//  EDetailing
//
//  Created by Karbens on 1/9/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import "Karbens_Summ.h"

@implementation Karbens_Summ

@synthesize SummId,SummName,SummtimeInterval,SummViewTime,SummEndTime,SummStartTime;


- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.SummId = [decoder decodeObjectForKey:@"SummId"];
        self.SummName = [decoder decodeObjectForKey:@"SummName"];
        self.SummStartTime= [decoder decodeObjectForKey:@"SummStartTime"];
        self.SummEndTime= [decoder decodeObjectForKey:@"SummEndTime"];
        self.SummViewTime= [decoder decodeObjectForKey:@"SummViewTime"];
        self.SummtimeInterval= [decoder decodeObjectForKey:@"SummtimeInterval"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:SummId forKey:@"SummId"];
    [encoder encodeObject:SummName forKey:@"SummName"];
    [encoder encodeObject:SummStartTime forKey:@"SummStartTime"];
    [encoder encodeObject:SummEndTime forKey:@"SummEndTime"];
    [encoder encodeObject:SummViewTime forKey:@"SummViewTime"];
    [encoder encodeObject:SummtimeInterval forKey:@"SummtimeInterval"];
   
}

@end
