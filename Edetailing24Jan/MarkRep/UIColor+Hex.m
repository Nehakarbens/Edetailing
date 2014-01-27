//
//  UIColor+Hex.m
//  MyDay
//
//  Created by Karbens on 10/29/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
//RGB color with alpha
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}


//RGB color
+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}
@end
