//
//  TimeRecord.m
//  EDetailing
//
//  Created by Karbens on 1/16/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import "TimeRecord.h"

@implementation Time


+(unsigned int)converstionofmilliseconds:(NSString*)string
{
    if (![string isEqualToString:nil]) {
        
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSDate *date1 = [dateFormat dateFromString:string];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date1];
    
    unsigned int varhour = ([components hour]*3600000);
    unsigned int varminute = ([components minute]*60000 );
    unsigned int varsecond = ([components second]*1000 );
    unsigned int result= varhour+varminute+varsecond;
    return result;
    }
    else{
        return 0;
    }
    
}

+(NSString *) difference:(unsigned int)starttime  betweenthem :(unsigned int)endtime
{
    unsigned int timeinterval=endtime-starttime;
    
    NSString *resultdiff = [NSString stringWithFormat:@"%u",timeinterval];
    return resultdiff;
}

@end
