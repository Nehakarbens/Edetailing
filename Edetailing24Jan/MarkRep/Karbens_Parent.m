//
//  Karbens_Parent.m
//  EDetailing
//
//  Created by Akshay Kunila on 27/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "Karbens_Parent.h"

@implementation Karbens_Parent
@synthesize  hasChilds,parentid,parentName,parentViewTime;
@synthesize timeInterval,viewDate,parentStartTime,parentEndTime,childs;

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.hasChilds = [decoder decodeObjectForKey:@"hasChilds"];
        self.parentid = [decoder decodeObjectForKey:@"parentid"];
        self.parentName = [decoder decodeObjectForKey:@"parentName"];
        self.parentViewTime = [decoder decodeObjectForKey:@"parentViewTime"];
        self.timeInterval = [decoder decodeObjectForKey:@"timeInterval"];
        self.viewDate = [decoder decodeObjectForKey:@"viewDate"];
        self.parentStartTime = [decoder decodeObjectForKey:@"parentStartTime"];
        self.parentEndTime = [decoder decodeObjectForKey:@"parentEndTime"];
        self.childs = [decoder decodeObjectForKey:@"childs"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:hasChilds forKey:@"hasChilds"];
    [encoder encodeObject:parentid forKey:@"parentid"];
    [encoder encodeObject:parentName forKey:@"parentName"];
    [encoder encodeObject:parentViewTime forKey:@"parentViewTime"];
    [encoder encodeObject:timeInterval forKey:@"timeInterval"];
    [encoder encodeObject:viewDate forKey:@"viewDate"];
    [encoder encodeObject:parentStartTime forKey:@"parentStartTime"];
    [encoder encodeObject:parentEndTime forKey:@"parentEndTime"];
    [encoder encodeObject:childs forKey:@"childs"];
}

-(void)dealloc
{
    [hasChilds release];
    [parentid release];
    [parentName release];
    [parentViewTime release];
    [timeInterval release];
    [viewDate release];
    [parentStartTime release];
    [parentEndTime release];
    [childs release];
    
    [super dealloc];
}



@end
