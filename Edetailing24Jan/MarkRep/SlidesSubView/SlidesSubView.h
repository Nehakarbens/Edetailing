//
//  SlidesSubView.h
//  MarkRep
//
//  Created by virupaksh on 15/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlidesSubView;

@protocol SlidesSubViewDelegate <NSObject>

- (void)didSlideSelected:(SlidesSubView *)inSlideView;

//-(void)didDoubleTap;

@end

@interface SlidesSubView : UIView<UIGestureRecognizerDelegate> {
    
}
@property (nonatomic, assign) id <SlidesSubViewDelegate> aDelegate;
@property (nonatomic, assign) UILabel *timeLabel;
@end
