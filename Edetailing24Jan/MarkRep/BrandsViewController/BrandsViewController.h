//
//  BrandsViewController.h
//  MyDay
//
//  Created by Virupaksha Futane on 30/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
//#import "MRParentViewController.h"
#import "ContentViewController.h"
#import "Parser.h"

@interface BrandsViewController : UIViewController<GridViewDelegate,ParserDelegate,UINavigationControllerDelegate>{
    
         NSString *UrlStr;
     UIActivityIndicatorView *indicator;
    
}

-(IBAction)Refresh:(id)sender;

@property (nonatomic, retain) NSMutableArray *brands,*downloadUrls, *ContentIDArray,*aDataBaseContent,*ContentLastDateDownArr,*gridViewArray;
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (retain, nonatomic)  UIActivityIndicatorView *indicator;
@property (retain, nonatomic) UILabel *lbl;


@property(nonatomic,retain) NSMutableArray *DownloadArr;

@end
