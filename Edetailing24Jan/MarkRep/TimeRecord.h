//
//  TimeRecord.h
//  EDetailing
//
//  Created by Karbens on 1/16/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject

+(unsigned int )converstionofmilliseconds:(NSString*)string;
+(NSString *) difference:(unsigned int)starttime  betweenthem :(unsigned int)endtime;
@end
