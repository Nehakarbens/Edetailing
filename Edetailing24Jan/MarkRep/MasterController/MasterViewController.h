//
//  MasterViewController.h
//  MarkRep
//
//  Created by virupaksh on 12/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterViewController;

@protocol MasterViewDelegate  <NSObject>
- (void)didMasterOptionSelected:(int)index;

@end

@interface MasterViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *masterTableView;
@property (nonatomic, assign) id <MasterViewDelegate> aDelegate;
@end
