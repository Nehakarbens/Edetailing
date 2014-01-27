//
//  GridView.m
//  MyDay
//
//  Created by Virupaksha Futane on 30/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "GridView.h"

@implementation GridView
@synthesize image,DownloadButton,DownloadProgress,brandLabel,Updatelabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews {
    if (self.brandLabel == nil) {
        
    
  
        UILabel *aBrandLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,65, 130, 30)];
        self.brandLabel = aBrandLabel;
        
        self.brandLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.brandLabel.minimumScaleFactor = 8.0;
        self.brandLabel.adjustsFontSizeToFitWidth = YES;
        self.brandLabel.numberOfLines = 2;
        
        
        UILabel *UpdateLable = [[UILabel alloc]initWithFrame:CGRectMake(122, 10, 15, 15)];        Updatelabel = UpdateLable;
        Updatelabel.text = self.UpdateName;
        Updatelabel.textColor = [UIColor blackColor];
        Updatelabel.backgroundColor = [UIColor clearColor];
        
        brandLabel.backgroundColor = [UIColor clearColor];
        brandLabel.textColor = [UIColor whiteColor];
        brandLabel.text = self.brandName;
        brandLabel.textAlignment = UITextAlignmentCenter;
        self.GridState = UIControlStateNormal;
        self.GridDownStatus = YES;
        
        DownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        DownloadButton.frame = CGRectMake(115, 138, 60, 20);
        
        [DownloadButton setImage:image forState:UIControlStateNormal];
        [DownloadButton setImage:_image1 forState:UIControlStateSelected];

        [DownloadButton addTarget:self action:@selector(DownlaodButtonpressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //self.DownloadButton = DownloadButton;
        DownloadProgress= [[UIProgressView alloc]initWithFrame:CGRectMake(10, 145, 120, 15)];        [DownloadProgress setHidden:YES];
        //[DownloadProgressBar setProgress:(float) animated:<#(BOOL)#>]
        [aBrandLabel release];
        
        aBrandLabel = nil;
        [self addSubview:DownloadButton];
        [self addSubview:self.brandLabel];
        [self addSubview:self.Updatelabel];
        [self addSubview:DownloadProgress];
    }
    [super layoutSubviews];
}
#pragma mark - touch delegate

- (void)DownlaodButtonpressed:(GridView *)inGridView
{
    if ([self.aDelegate respondsToSelector:@selector(DownlaodButtonpressed:)]) {
        [self.aDelegate DownlaodButtonpressed:self];
        
        
    }
    
}

- (void)UpdateProgress:(float)value
{
    NSLog(@"value = %f",value);
    DownloadProgress.progress = value;
}
- (void)Completed:(int)DownStatus
{
   
       if (DownStatus == 0) {
        DownloadProgress.hidden = YES;
        DownloadButton.hidden = NO;
        
    }
    else if (DownStatus == 1){
        DownloadProgress.hidden = YES;
        DownloadButton.hidden = YES;
        Updatelabel.text = @"";

    }
    else if (DownStatus == 2){
        DownloadProgress.hidden = YES;
        DownloadButton.hidden = NO;
        
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.aDelegate respondsToSelector:@selector(didBrandSelected:)]) {
        [self.aDelegate didBrandSelected:self];
    }
    
    if ([self.aDelegate respondsToSelector:@selector(didContentSelected:)]) {
        
        [self.aDelegate didContentSelected:self];
        //self.GridDownStatus = YES;
    }
    
    if ([self.aDelegate respondsToSelector:@selector(didSlideViewSelected:)]) {
        [self.aDelegate didSlideViewSelected:self];
    }
    
    if ([self.aDelegate respondsToSelector:@selector(didContentDetailViewSelected:)]) {
        [self.aDelegate didContentDetailViewSelected:self];
    }
    
    if ([self.aDelegate respondsToSelector:@selector(didVideoSelected:)]) {
        [self.aDelegate didVideoSelected:self];
    }

    
}



@end
