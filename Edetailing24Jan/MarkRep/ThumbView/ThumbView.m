//
//  ThumbView.m
//  MarkRep
//
//  Created by virupaksh on 14/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "ThumbView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThumbView
@synthesize aDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        // Initialization code
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, self.frame.size.height+10);
        self.layer.shadowOpacity = 0.3;
    
    }
    return self;
}

#pragma mark - touch delegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.aDelegate respondsToSelector:@selector(didSlideThumbClicked:)]) {
        [self.aDelegate didSlideThumbClicked:self];
    }
}

- (void)SlideSelected{
    NSLog(@"--1---");
    self.backgroundColor = [UIColor grayColor];
}
- (void)SlideDeSelected{
    NSLog(@"-----");
    self.backgroundColor = [UIColor lightGrayColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
