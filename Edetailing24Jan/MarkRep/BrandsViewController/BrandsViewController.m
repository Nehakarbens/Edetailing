//
//  BrandsViewController.m
//  MyDay
//
//  Created by Virupaksha Futane on 30/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "BrandsViewController.h"
#import "GridView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "MDDataPackage.h"
#import "MDDataSharingController.h"
#import "settingViewController.h"

static NSString *kViewerURLScheme = @"com.anant.Mylan";

//static NSString *kViewerURLScheme = @"com.mylan.MyDay";

@interface BrandsViewController ()
@end

@implementation BrandsViewController
@synthesize brands,DownloadArr,gridViewArray,indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Refresh:)
                                                 name:@"Notification"
                                               object:nil];
    
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"isMylan = %hhd",aAppDelegate.isMylan);
    
    
    UIBarButtonItem *aRightbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(Refresh:)];
    aRightbarButton.style = UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *aRightbarButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(Exit:)];
    aRightbarButton1.style = UIBarButtonItemStyleBordered;
    
    NSMutableArray *aBarItems = [[NSMutableArray alloc] init];
    
    [aBarItems addObject:aRightbarButton];
    [aBarItems addObject:aRightbarButton1];
    //    aleftbarButton.possibleTitles = [NSSet setWithObjects:@"Edit", @"Done", nil];
    
    
    
    self.navigationItem.rightBarButtonItems = (NSArray *)aBarItems;
    UIBarButtonItem *alefttbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStyleBordered target:self action:@selector(settingAction:)];
    alefttbarButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem=alefttbarButton;
    
    self.navigationController.delegate = self;
    
    
    self.title = @"Brand View";
    
    
    
    
    if ([aAppDelegate.username length] != 0 && [aAppDelegate.password length] != 0)
    {
   
    BOOL hasInternet = [self checkInternet];
  
    if(hasInternet == TRUE)
    {
        _aDataBaseContent = [[NSMutableArray alloc] init];
        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =
        [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downStatus == %d", 1];
        [request setPredicate:predicate];
        
        _aDataBaseContent =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        
        _ContentIDArray = [[NSMutableArray alloc]init];
        _ContentLastDateDownArr = [[NSMutableArray alloc]init];
        
        //NSLog(@"content Down status: %@",_aDataBaseContent)
        NSLog(@"Acontent = %d",[_aDataBaseContent count]);
        //
        for (Content *aContent in _aDataBaseContent)
        {
            NSLog(@"content Down status:  = %@",aContent.downStatus);
            if (aContent.lastdownloaddate != nil )
            {
                NSLog(@"Content Name :%@",aContent.contentName);
                [_ContentIDArray addObject:aContent.contentId];
                [_ContentLastDateDownArr addObject:aContent.lastdownloaddate];
            }
            
        }
        
        NSString *cidString = [_ContentIDArray componentsJoinedByString:@","];
        NSString *dateString = [_ContentLastDateDownArr componentsJoinedByString:@","];
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DToken"];
        NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    
        
        UrlStr = [NSString stringWithFormat:@"http://www.my-day.in/E-detailingv1/webservices/edetailerXml.php?username=%@&password=%@&date=%@&cid=%@&device_token=%@&type=0",username,password,dateString,cidString,deviceToken];
        
        
        NSLog(@"UrlStr = %@",UrlStr);
        
       // UrlStr =[NSString stringWithFormat:@"%s","http://173.192.152.119/E-detailing/webservices/edetailerXml.php?username=00900034&password=123456&date=2013-12-02 12:47:42&cid=4"];
        
        Parser *parse = [[Parser alloc]init];
        parse.aDelegate = self;
        [parse requestWithUrls:UrlStr];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         indicator.center = self.view.center;
        
        
        _lbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, self.view.frame.size.height/2+20, 200, 30)];
        [_lbl setText:@"Connecting to Server"];
        
        [self.view addSubview:_lbl];
        [self.view addSubview:indicator];
        [indicator startAnimating];
        
        [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
        
//        brands = [[NSMutableArray alloc]initWithArray:aAppDelegate.dbBrandArr];
//        [self loadGridView];
    }
    else // No Internet
    {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = self.view.center;
        
        
        _lbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, self.view.frame.size.height/2+20, 200, 30)];
        [_lbl setText:@"loading local Data"];
        
        [self.view addSubview:_lbl];
        [self.view addSubview:indicator];
        [indicator startAnimating];
        
        [[UIApplication sharedApplication]beginIgnoringInteractionEvents];

        
        [self getDownloadedBrands];
    }
    

    float sizeOfContent = 0;
    UIView *lLast = [_ScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height+150;
    
    sizeOfContent = wd+ht;
    
    _ScrollView.contentSize = CGSizeMake(_ScrollView.frame.size.width, sizeOfContent);
    }
    
    /*
    else
    {
        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Access the app through Content Manager in MyDay" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
     */

}
-(IBAction)settingAction:(id)sender
{
    settingViewController * svc=[[settingViewController alloc]init];
    [self presentViewController:svc animated:YES completion:nil];
    
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}


-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"Brands View: View WIll APpear Called");
    
    
}

-(IBAction)Exit:(id)sender
{
    MDDataPackage *package = [MDDataPackage dataPackageForCurrentApplicationWithPayload:[NSData dataWithContentsOfURL:nil]];
    [MDDataSharingController sendDataToApplicationWithScheme:kViewerURLScheme
                                                 dataPackage:package
                                           completionHandler:^(BOOL *sent, NSError *error) {
                                               if (sent)
                                               {
                                                   NSLog(@"Data Package Sent");
                                               }
                                               else if (error)
                                               {
                                                   NSLog(@"Error sending data package: %@", [error localizedDescription]);
                                               }
                                           }];
    
    

}

-(IBAction)Refresh:(id)sender{
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([aAppDelegate.username length] == 0 && [aAppDelegate.password length] == 0)
    {
        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Access the app through Content Manager in MyDay" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else
    {
        BOOL hasInternet = [self checkInternet];
        
        if(hasInternet == TRUE)
        {
            _aDataBaseContent = [[NSMutableArray alloc] init];
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            aAppDelegate.isChanged = NO;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity =
            [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
            [request setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downStatus == %d", 1];
            [request setPredicate:predicate];
            
            _aDataBaseContent =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
            
            _ContentIDArray = [[NSMutableArray alloc]init];
            _ContentLastDateDownArr = [[NSMutableArray alloc]init];
            
            //NSLog(@"content Down status: %@",_aDataBaseContent)
            NSLog(@"Acontent = %d",[_aDataBaseContent count]);
            //
            for (Content *aContent in _aDataBaseContent)
            {
                NSLog(@"content Down status:  = %@",aContent.downStatus);
                if (aContent.lastdownloaddate != nil )
                {
                    NSLog(@"Content Name :%@",aContent.contentName);
                    [_ContentIDArray addObject:aContent.contentId];
                    [_ContentLastDateDownArr addObject:aContent.lastdownloaddate];
                }
                
            }
            
            NSString *cidString = [_ContentIDArray componentsJoinedByString:@","];
            NSString *dateString = [_ContentLastDateDownArr componentsJoinedByString:@","];
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DToken"];
            NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
            NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
            
            
            UrlStr = [NSString stringWithFormat:@"http://www.my-day.in/E-detailingv1/webservices/edetailerXml.php?username=%@&password=%@&date=%@&cid=%@&device_token=%@&type=0",username,password,dateString,cidString,deviceToken];
            
            [[UIApplication sharedApplication]beginIgnoringInteractionEvents];

            Parser *parse = [[Parser alloc]init];
            parse.aDelegate = self;
            [parse requestWithUrls:UrlStr];
            
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.center = self.view.center;
            
            
            _lbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, self.view.frame.size.height/2+20, 200, 30)];
            [_lbl setText:@"Connecting to Server"];
            
            [self.view addSubview:_lbl];
            [self.view addSubview:indicator];
            [indicator startAnimating];
            
            
            
            
            //        brands = [[NSMutableArray alloc]initWithArray:aAppDelegate.dbBrandArr];
            //        [self loadGridView];
        }
        else // No Internet
        {
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.center = self.view.center;
            
            
            _lbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, self.view.frame.size.height/2+20, 200, 30)];
            [_lbl setText:@"Loading Local Data"];
            
            [self.view addSubview:_lbl];
            [self.view addSubview:indicator];
            [indicator startAnimating];
            
            [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
            
            [self getDownloadedBrands];
        }
        

    }
}

-(void)didFail{
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [indicator stopAnimating];
    _lbl.hidden = YES;
    [indicator release];
    [_lbl release];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Load GridView
- (void)loadGridView {
    
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [indicator stopAnimating];
    _lbl.hidden = YES;
    [indicator release];
    [_lbl release];
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    brands = [[NSMutableArray alloc]initWithArray:aAppDelegate.dbBrandArr];
    
    for (UIView *aView in [_ScrollView subviews]) {
        [aView removeFromSuperview];
    }
    
    CGFloat gridViewWidth = 150.0f;
    CGFloat gridViewHeight = 150.0f;
    int i = 0;
    int j = 1;
    int k = 0;
    
    NSInteger extrarow;
    
    if (([brands count]%5)<5 )
    {
        extrarow = 1;
    }
    else
    {
        
        extrarow=0;
    }
    
    NSInteger numberofRows = ([brands count]/5)+extrarow;
    CGFloat y = 20.0;
    
    NSString *Cname;
    
    for( j=1; j<=numberofRows ; j++ )
    {
		for( i=0; i<5 && k<[brands count]; i++ )
        {
            GridView *aGridView = [[GridView alloc] init];
            aGridView.tag = k + 1;
            Brand *aBrand = [brands objectAtIndex:k++];
            Cname = aBrand.brandName;
            NSLog(@"brand = %@",aBrand);
           
            
            CGRect rect;
            
            rect = CGRectMake( i *(gridViewWidth+40)+50, (j-1)*(gridViewHeight+40)+80, gridViewWidth+20, gridViewHeight+20);
            
            aGridView.frame = rect;
            
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, gridViewWidth+20, gridViewHeight+20)];
            
            if (aBrand.brandImagePath == nil) {
                
                 mainImgView.image = [UIImage imageNamed:@"button frame.png"];
            }
            else{
                NSData *data = [NSData dataWithContentsOfFile:aBrand.brandImagePath];
               
                if (data != nil) {
                    UIImage *image = [UIImage imageWithData:data];
                    mainImgView.image = image;
                    
                }
                else {
                    mainImgView.image = [UIImage imageNamed:@"button frame.png"];
                }

            }
           
            y = y + 50 ;

            
            
            aGridView.Hidden = YES;
            
            [aGridView addSubview:mainImgView];
            
            
            [mainImgView release];
            mainImgView = nil;
            
            aGridView.brandName =Cname;
            
            //aGridView.image1 = [UIImage imageNamed:@"pause.png"];
            
            aGridView.aDelegate = self;
            aGridView.layer.cornerRadius = 8.0;
            aGridView.layer.borderWidth = 3.0;
            aGridView.layer.borderColor = [UIColor whiteColor].CGColor;
            aGridView.layer.shadowColor = [UIColor grayColor].CGColor;
            
            
            [self.ScrollView addSubview:aGridView];
            
            // [self.view addSubview:aGridView];
            //[gridViewArray addObject:aGridView];
            [aGridView layoutIfNeeded];
            [aGridView release];
            aGridView = nil;
            
        }
    }
     self.ScrollView.contentSize = CGSizeMake(0, y);
}


#pragma mark - Brand view delegate
- (void)didBrandSelected:(GridView *)inGridView {
    
    NSLog(@"Brand selected");
    
    
    Brand *aBrand = [brands objectAtIndex:inGridView.tag - 1];
    //[[NSUserDefaults standardUserDefaults] setObject:aBrandName forKey:@"brandName"];
//     [[NSUserDefaults standardUserDefaults] setObject:@"notFromMylan" forKey:@"source"];
    
    
    ContentViewController *aContentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    
    aContentViewController.brandID = [[brands objectAtIndex:inGridView.tag - 1] brandId];
    aContentViewController.brandIndex =  inGridView.tag -1;
    //aContentViewController.contents = [[brands objectAtIndex:inGridView.tag - 1] contents];
    [self.navigationController pushViewController:aContentViewController animated:YES];
    [aContentViewController release];
    aContentViewController = nil;
    
    
}

-(BOOL)checkInternet{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable)
    {
        NSLog(@"No Internet");
        return FALSE;
    }
    else
    {
        NSLog(@"Connecting");
        return TRUE;
    }
    
}

-(void)getDownloadedBrands{
    
   
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableArray *aBrands = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [request setEntity:entity];
    
    aBrands =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (brands == nil)
    {
        brands = [[NSMutableArray alloc]initWithArray:aBrands];
    }
    else
    {
        [brands release];
        brands = [[NSMutableArray alloc]initWithArray:aBrands];
    }
    
    
    [brands setArray:[[NSSet setWithArray:brands]allObjects]];
    
    
    
    [self loadGridView];
    
}


@end
