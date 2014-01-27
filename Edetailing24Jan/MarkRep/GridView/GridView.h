//
//  GridView.h
//  MyDay
//
//  Created by Virupaksha Futane on 30/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridView;
@protocol GridViewDelegate <NSObject>

- (void)didBrandSelected:(GridView *)inGridView;
- (void)didContentSelected:(GridView *)inGridView;
- (void)didSlideViewSelected:(GridView *)inGridView;
- (void)DownlaodButtonpressed:(GridView *)inGridView;
- (void)didContentDetailViewSelected:(GridView *)inGridView;
- (void)didVideoSelected :(GridView *)inGridView;
@end

@interface GridView : UIView {
    
    UIImage *image;
    UIButton *DownloadButton;
    UIProgressView *DownloadProgress;
    UILabel *brandLabel,*Updatelabel;
    
}
@property (nonatomic, retain) UILabel *brandLabel,*Updatelabel;
@property(nonatomic,retain) UIButton *DownloadButton;
@property (nonatomic, retain) NSString *brandName,*UpdateName;
@property(nonatomic,retain) UIImage *image,*image1;
@property(nonatomic,retain) UIProgressView *DownloadProgress;
@property(nonatomic)BOOL GridDownStatus,Hidden;
@property(nonatomic) UIControlState GridState;
@property (nonatomic, assign) id <GridViewDelegate> aDelegate;
- (void)UpdateProgress :(float)value;
- (void)Completed:(int)DownStatus;
@end
