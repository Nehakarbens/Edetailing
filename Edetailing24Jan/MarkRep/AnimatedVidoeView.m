//
//  AnimatedVidoeView.m
//  EDetailing
//
//  Created by Karbens on 11/28/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "AnimatedVidoeView.h"

@implementation AnimatedVidoeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, 600, 400)];
        self.webView = aWebView;
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.scrollEnabled = YES;
        [self addSubview:self.webView];
        [aWebView release];
        aWebView = nil;
        
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesture.numberOfTapsRequired = 2;
        tapGesture.delegate=self;
        [self.webView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        
        
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)iRecg {
    
    if ([self.aDelegate respondsToSelector:@selector(didDoubleTapVideo:)]) {
        [self.aDelegate didDoubleTapVideo:self];
    }
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.webView loadHTMLString:nil baseURL:nil];
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
