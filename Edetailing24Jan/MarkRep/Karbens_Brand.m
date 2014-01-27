//
//  Karbens_Brand.m
//  EDetailing
//
//  Created by Akshay Kunila on 26/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "Karbens_Brand.h"

@implementation Karbens_Brand
@synthesize brandName,brandId,contents;

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.brandName = [decoder decodeObjectForKey:@"brandName"];
        self.brandId = [decoder decodeObjectForKey:@"brandId"];
        self.contents = [decoder decodeObjectForKey:@"contents"];
        self.contStartTime = [decoder decodeObjectForKey:@"contStartTime"];//
        self.contEndTime = [decoder decodeObjectForKey:@"contEndTime"];//
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:brandName forKey:@"brandName"];
    [encoder encodeObject:brandId forKey:@"brandId"];
    [encoder encodeObject:contents forKey:@"contents"];
    [encoder encodeObject:contStartTime forKey:@"contStartTime"];//
    [encoder encodeObject:contEndTime forKey:@"contEndTime"];//
    
}

-(void)dealloc
{
    [brandName release];
    [brandId release];
    [contents release];
    [contEndTime release];
    [contStartTime release];
    [super dealloc];
}


@end
