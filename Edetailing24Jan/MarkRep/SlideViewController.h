//
//  SlideViewController.h
//  MyDay
//
//  Created by Karbens on 10/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "Parent.h"

@interface SlideViewController : UIViewController<GridViewDelegate>
{
    UIButton *customButton;
    UIControlState state,GridState;
    NSMutableArray *SelectedSlideArray,*DisabledSlideArray;
    NSIndexSet *Set;
    UIBarButtonItem *aHomeButton;

   // NSArray *sortedArray;
}
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (nonatomic,retain) NSMutableArray *SlideArray,*DisabledSlideArray,*ReEnabledArray,*aParents;
@property(nonatomic,retain)NSArray *sortedArray;
@property(nonatomic,retain)UIBarButtonItem *aHomeButton;
@property(nonatomic,retain)NSNumber *ContentID;
-(void)didSlideViewSelected:(GridView *)inGridView;
-(void)Summary;

@end
