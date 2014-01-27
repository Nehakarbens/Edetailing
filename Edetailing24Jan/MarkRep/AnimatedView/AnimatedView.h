//
//  AnimatedView.h
//  MarkRep
//
//  Created by virupaksh on 19/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimatedView;


@protocol AnimatedViewDelegate<NSObject>

//- (void)didMaximizePressed:(BOOL)isMaximize;
//- (void)didClosePressed;
- (void)didDoubleTap:(AnimatedView *)inAnimView;


@end



@interface AnimatedView : UIView <UIGestureRecognizerDelegate>{
    
}
@property (nonatomic, retain) UIImageView *ImageView;
@property (nonatomic, assign) id <AnimatedViewDelegate> aDelegate;
@property (nonatomic, retain) UIWebView *webView;
- (void)tapAction2:(UITapGestureRecognizer *)iRecg;
-(void)didWebViewShow;
@end
