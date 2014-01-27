//
//  SlidesSubView.m
//  MarkRep
//
//  Created by virupaksh on 15/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "SlidesSubView.h"

@implementation SlidesSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - touch delegate

- (void)tapAction:(UITapGestureRecognizer *)iRecg {
    if ([self.aDelegate respondsToSelector:@selector(didSlideSelected:)]) {
        [self.aDelegate didSlideSelected:self];
    }
    
  

}

//- (void)tapAction4:(UITapGestureRecognizer *)iRecg {
//    if ([self.aDelegate respondsToSelector:@selector(didDoubleTap)]) {
//        [self.aDelegate didDoubleTap];
//    }
//    
//    
//    
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
