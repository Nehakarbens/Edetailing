//
//  ReferenceViewController.h
//  MarkRep
//
//  Created by virupaksh on 21/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface ReferenceViewController : UIViewController <UIWebViewDelegate>{
    
}
@property (retain, nonatomic) IBOutlet UIWebView *referenceWebView;
@property (nonatomic,retain) NSString  *aPath;

@end
