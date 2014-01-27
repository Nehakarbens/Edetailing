//
//  Karbens_Video.m
//  EDetailing
//
//  Created by Karbens on 1/9/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import "Karbens_Video.h"

@implementation Karbens_Video
@synthesize VideoId,VideoName,VideotimeInterval,VideoViewTime,VideoEndTime,VideoStartTime;


- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.VideoId = [decoder decodeObjectForKey:@"VideoId"];
        self.VideoName = [decoder decodeObjectForKey:@"VideoName"];
        self.VideoStartTime= [decoder decodeObjectForKey:@"VideoStartTime"];
        self.VideoEndTime= [decoder decodeObjectForKey:@"VideoEndTime"];
        self.VideoViewTime= [decoder decodeObjectForKey:@"VideoViewTime"];
        self.VideotimeInterval= [decoder decodeObjectForKey:@"VideotimeInterval"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:VideoId forKey:@"VideoId"];
    [encoder encodeObject:VideoName forKey:@"VideoName"];
    [encoder encodeObject:VideoStartTime forKey:@"VideoStartTime"];
    [encoder encodeObject:VideoEndTime forKey:@"VideoEndTime"];
    [encoder encodeObject:VideoViewTime forKey:@"VideoViewTime"];
    [encoder encodeObject:VideotimeInterval forKey:@"VideotimeInterval"];

    
}

@end
