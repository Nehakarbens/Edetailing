//
//  Karbens_Child.m
//  EDetailing
//
//  Created by Akshay Kunila on 27/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "Karbens_Child.h"

@implementation Karbens_Child

@synthesize childEndTime,childid,childName,childStartTime,childViewTime,contentType,timeInterval,type,references;


- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.childEndTime = [decoder decodeObjectForKey:@"childEndTime"];
        self.childid = [decoder decodeObjectForKey:@"childid"];
        self.childName = [decoder decodeObjectForKey:@"childName"];
        self.childStartTime = [decoder decodeObjectForKey:@"childStartTime"];
        self.childViewTime = [decoder decodeObjectForKey:@"childViewTime"];
        self.contentType = [decoder decodeObjectForKey:@"contentType"];
        self.timeInterval = [decoder decodeObjectForKey:@"timeInterval"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.references = [decoder decodeObjectForKey:@"references"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:childEndTime forKey:@"childEndTime"];
    [encoder encodeObject:childid forKey:@"childid"];
    [encoder encodeObject:childName forKey:@"childName"];
    [encoder encodeObject:childStartTime forKey:@"childStartTime"];
    [encoder encodeObject:childViewTime forKey:@"childViewTime"];
    [encoder encodeObject:contentType forKey:@"contentType"];
    [encoder encodeObject:timeInterval forKey:@"timeInterval"];
    [encoder encodeObject:type forKey:@"type"];
    [encoder encodeObject:references forKey:@"references"];
}


@end
