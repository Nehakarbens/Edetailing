//
//  AnimatedView.m
//  MarkRep
//
//  Created by virupaksh on 19/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "AnimatedView.h"

@implementation AnimatedView
@synthesize ImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *aImageView = [[UIImageView alloc]initWithFrame:frame];
        self.ImageView = aImageView;
        self.ImageView.userInteractionEnabled = YES;
        [self addSubview:self.ImageView];

        
        
        // Initialization code
//        UIWebView *aWebView = [[UIWebView alloc] initWithFrame:frame];
//        self.webView = aWebView;
//        self.webView.alpha = 0.0;
//        self.webView.backgroundColor = [UIColor whiteColor];
//        self.webView.scalesPageToFit = YES;
//        self.webView.scrollView.scrollEnabled = YES;
//        [self addSubview:self.webView];
//        [aWebView release];
//        aWebView = nil;
        
        /*
        UIButton *aCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aCloseButton.frame = CGRectMake(0, 0, 32, 32);
        [aCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [aCloseButton addTarget:self action:@selector(ClosePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aCloseButton];
        
        UIButton *aMinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aMinButton.frame = CGRectMake(aCloseButton.frame.origin.x + 32, 0, 32, 32);
        [aMinButton setBackgroundImage:[UIImage imageNamed:@"maximize.png"] forState:UIControlStateNormal];
        [aMinButton addTarget:self action:@selector(minMaxPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aMinButton];
         */
//
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2:)];
        tapGesture.numberOfTapsRequired = 2;
        tapGesture.delegate=self;
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
//
        
    }
    return self;
}

-(void)didWebViewShow{
    _webView.alpha =  1.0;
}

#pragma maek - Actions

- (void)tapAction2:(UITapGestureRecognizer *)iRecg {
    
    if ([self.aDelegate respondsToSelector:@selector(didDoubleTap:)]) {
        [self.aDelegate didDoubleTap:self];
    }
     
     
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



/*
- (void)minMaxPressed:(UIButton *)inSender {
    inSender.selected = !inSender.selected;
    if (inSender.selected) {
        if ([self.aDelegate respondsToSelector:@selector(didMaximizePressed:)]) {
            [self.aDelegate didMaximizePressed:YES];
        }
        [inSender setBackgroundImage:[UIImage imageNamed:@"minimise.png"] forState:UIControlStateNormal];
    }else {
        if ([self.aDelegate respondsToSelector:@selector(didMaximizePressed:)]) {
            [self.aDelegate didMaximizePressed:NO];
        }
        [inSender setBackgroundImage:[UIImage imageNamed:@"maximize.png"] forState:UIControlStateNormal];
    }
}
- (void)ClosePressed:(UIButton *)inSender {
    if ([self.aDelegate respondsToSelector:@selector(didClosePressed)]) {
        [self.aDelegate didClosePressed];
    }
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
