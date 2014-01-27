//
//  EmailViewController.h
//  EDetailing
//
//  Created by Karbens on 11/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailViewController : UIViewController{
    IBOutlet UILabel *lblEmail;
    NSMutableArray *aParents;
    
}
@property(nonatomic,retain)NSMutableArray *aParents;
@property(nonatomic,retain)IBOutlet UILabel *lblEmail;
@property(nonatomic,retain)IBOutlet UITextField *txtEmailID;
@property(nonatomic,retain)IBOutlet UIButton *btnSend;


-(IBAction)SendPressed:(id)sender;
@end
