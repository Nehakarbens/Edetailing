//
//  Karbens_Reference.m
//  EDetailing
//
//  Created by Akshay Kunila on 27/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "Karbens_Reference.h"

@implementation Karbens_Reference
@synthesize referenceId,referenceName,referencetimeInterval,referenceViewTime,referenceEndTime,referenceStartTime;


- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.referenceId = [decoder decodeObjectForKey:@"referenceId"];
        self.referenceName = [decoder decodeObjectForKey:@"referenceName"];
        self.referenceStartTime= [decoder decodeObjectForKey:@"referenceStartTime"];
        self.referenceEndTime= [decoder decodeObjectForKey:@"referenceEndTime"];
        self.referenceViewTime= [decoder decodeObjectForKey:@"referenceViewTime"];
        self.referencetimeInterval= [decoder decodeObjectForKey:@"referencetimeInterval"];
       
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
 
    [encoder encodeObject:referenceId forKey:@"referenceId"];
    [encoder encodeObject:referenceName forKey:@"referenceName"];
    [encoder encodeObject:referenceStartTime forKey:@"referenceStartTime"];
    [encoder encodeObject:referenceEndTime forKey:@"referenceEndTime"];
    [encoder encodeObject:referenceViewTime forKey:@"referenceViewTime"];
    [encoder encodeObject:referencetimeInterval forKey:@"referencetimeInterval"];
   
}


@end
