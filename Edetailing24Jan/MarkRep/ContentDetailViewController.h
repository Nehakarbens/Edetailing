//
//  ContentDetailViewController.h
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"

@interface ContentDetailViewController : UIViewController<GridViewDelegate>
{
    NSMutableArray *ContentDetails,*ImageArray;
    NSNumber *ContentID;
    NSNumber *BrandID;
    NSUserDefaults *userDefault;
}
@property(nonatomic,retain) NSMutableArray *ContentDetails,*aParents,*ImageArray;
@property(nonatomic ,retain)NSNumber *ContentID;
@property(nonatomic,retain) NSNumber *BrandID;
@property(nonatomic, copy) NSArray *viewControllers;

-(IBAction)BackExit:(id)sender;
- (IBAction)Exit:(id)sender ;
- (void)didContentDetailViewSelected:(GridView *)inGridView;
@end
