//
//  Karbens_Content.m
//  EDetailing
//
//  Created by Akshay Kunila on 26/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "Karbens_Content.h"

@implementation Karbens_Content

@synthesize contentId,contentName,contStartTime,contEndTime,datalists,Summarys;

@synthesize parent;

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.contentId = [decoder decodeObjectForKey:@"contentId"];
        self.contentName = [decoder decodeObjectForKey:@"contentName"];
        self.contStartTime = [decoder decodeObjectForKey:@"contStartTime"];
        self.contEndTime = [decoder decodeObjectForKey:@"contEndTime"];
        self.parent = [decoder decodeObjectForKey:@"parent"];
        self.datalists = [decoder decodeObjectForKey:@"datalist"];
        self.Summarys = [decoder decodeObjectForKey:@"summary"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:contentId forKey:@"contentId"];
    [encoder encodeObject:contentName forKey:@"contentName"];
    [encoder encodeObject:contStartTime forKey:@"contStartTime"];
    [encoder encodeObject:contEndTime forKey:@"contEndTime"];
    [encoder encodeObject:parent forKey:@"parent"];
    [encoder encodeObject:datalists forKey:@"datalist"];
    [encoder encodeObject:Summarys forKey:@"summary"];
}

-(void)dealloc
{
    [contentId release];
    [contentName release];
    //[downStatus release];
    //[isUpdateAvail release];
    //[lastdownloaddate release];
    [contStartTime release];
    [contEndTime release];
    [parent release];
    
    [super dealloc];
}


@end
