//
//  AnimatedVidoeView.h
//  EDetailing
//
//  Created by Karbens on 11/28/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AnimatedVidoeView;


@protocol AnimatedVideoViewDelegate<NSObject>

//- (void)didMaximizePressed:(BOOL)isMaximize;
//- (void)didClosePressed;
- (void)didDoubleTapVideo:(AnimatedVidoeView *)inAnimView;

@end

@interface AnimatedVidoeView : UIView <UIGestureRecognizerDelegate>{
    
}
@property (nonatomic, assign) id <AnimatedVideoViewDelegate> aDelegate;
@property (nonatomic, retain) UIWebView *webView;



@end
