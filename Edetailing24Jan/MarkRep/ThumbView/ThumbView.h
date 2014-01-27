//
//  ThumbView.h
//  MarkRep
//
//  Created by virupaksh on 14/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThumbView;

@protocol ThumbViewDelegate <NSObject>

- (void)didSlideThumbClicked:(ThumbView *)inThumbView;



@end

@interface ThumbView : UIView {
    
}
- (void)SlideSelected;
- (void)SlideDeSelected;
@property (nonatomic, assign) id <ThumbViewDelegate> aDelegate;

@end
