//
//  MRParentViewController.m
//  MarkRep
//
//  Created by virupaksh on 12/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "ContentRefLinksViewController.h"
#import "MRParentViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "Parent.h"
#import "Child.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resizing.h"
#import "NSDateHelper.h"
#import "NSURLHelper.h"
#import "ReferenceViewController.h"
#import "Content.h"
#import "UIColor+Hex.h"
// Data Sharing
#import "MDDataPackage.h"
#import "MDDataSharingController.h"
#import "NSManagedObjectArchiving.h"
#import "Karbens_Brand.h"
#import "Karbens_Content.h"
#import "Karbens_Parent.h"
#import "Karbens_Child.h"
#import "Karbens_Reference.h"
#import "Karbens_datalist.h"
#import "Karbens_Video.h"
#import "Karbens_Summ.h"
#import "TimeRecord.h"

#import "SummaryViewController.h"

static NSString *kViewerURLScheme = @"com.anant.Mylan";

//static NSString *kViewerURLScheme = @"com.mylan.MyDay";

@interface MRParentViewController ()

@property (nonatomic, retain) SlidesSubView *slideSubView;
@property (nonatomic, retain) Child *child;
@property (nonatomic, retain) NSString *parentViewTime,*parentStartTime,*parentEndTime;
@property (nonatomic, retain) NSString *ChildStartTime,*ChildEndTime;

@property (nonatomic, assign) NSTimeInterval parentTimeInterval;
@property (nonatomic, assign) NSTimeInterval childTimeInterval;

@end

@implementation MRParentViewController
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize aParents,timerString,animatedView,ContentID,BrandID,refArray,webView,animatedVideoView,mpPlayer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    refArray =[[NSMutableArray alloc]init];

    
    self.pageControl.hidden = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
   
//    UISwipeGestureRecognizer *aSwipeDownGestureRecg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
//    aSwipeDownGestureRecg.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.view addGestureRecognizer:aSwipeDownGestureRecg];
//    [aSwipeDownGestureRecg release];
//    aSwipeDownGestureRecg = nil;
    
    UISwipeGestureRecognizer *aSwipeUpGestureRecg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    aSwipeUpGestureRecg.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:aSwipeUpGestureRecg];
    [aSwipeUpGestureRecg release];
    aSwipeUpGestureRecg = nil;
    
    self.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"brandName"];
    self.selectedSlideIndex = 0;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.animatedImageView.alpha = 0.0;
 
    [self loadParentThumbs];
    
    [self reloadThumbsForIndex];
    
    UISwipeGestureRecognizer *aTapGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTApGesture:)];
    [self.animatedImageView addGestureRecognizer:aTapGestureRecognizer];
    
    
    [self.parentStopWatchTimer invalidate];
    
    self.parentTimerStartDate = [NSDate date];
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
  
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contentId == %@", ContentID];
    [request setPredicate:predicate];
    
    NSMutableArray *ContentArray =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    Content *aContent = [ContentArray objectAtIndex:0];
    
    aContent.contStartTime =  [dateFormatter stringFromDate:[NSDate date]];
    [aAppDelegate.managedObjectContext save:nil];
    
    NSLog(@"TimerString = %@",timerString);
    if (![timerString isEqualToString:@"FromSlideView"]) {
    
    
    self.parentStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                 target:self
                                                               selector:@selector(startParentTimer)
                                                               userInfo:nil
                                                                repeats:NO];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_slidesScrollView release];
    [_slideDetailsScrollView release];
    [_pageControl release];
    [_animatedImageView release];
    [_popOverView release];
    [_referenceTableView release];
    [_exitButton release];
    [refArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return YES;
}
#pragma mark - swipe down
- (void)swipeDown {
    self.isShowPressed = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    
    self.parentHostView.frame = CGRectMake(0, 0, self.parentHostView.frame.size.width, self.parentHostView.frame.size.height);
    [self.slideDetailsScrollView setFrame:CGRectMake(0,128, self.slideDetailsScrollView.frame.size.width, self.slideDetailsScrollView.frame.size.height)];
    [UIView commitAnimations];
    
}

#pragma mark -  swipeUp
- (void)swipeUp {
    [self exitViewUp];
    self.isShowPressed = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    
    [self.slideDetailsScrollView setFrame:CGRectMake(0,0, self.slideDetailsScrollView.frame.size.width, self.slideDetailsScrollView.frame.size.height)];
    self.parentHostView.frame = CGRectMake(0, -self.parentHostView.frame.size.width, self.parentHostView.frame.size.width, self.parentHostView.frame.size.height);
    [UIView commitAnimations];
}

- (void)exitViewDown {
    //self.isShowPressed = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    
    self.exitView.frame = CGRectMake(984, 50, self.exitView.frame.size.width, self.exitView.frame.size.height);
    //[self.slideDetailsScrollView setFrame:CGRectMake(0,128, self.slideDetailsScrollView.frame.size.width, self.slideDetailsScrollView.frame.size.height)];
    [UIView commitAnimations];
    
}
- (void)exitViewUp {
    //self.isShowPressed = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    
    self.exitView.frame = CGRectMake(984, -self.exitView.frame.size.width,self.exitView.frame.size.width, self.exitView.frame.size.height);
    //[self.slideDetailsScrollView setFrame:CGRectMake(0,128, self.slideDetailsScrollView.frame.size.width, self.slideDetailsScrollView.frame.size.height)];
    [UIView commitAnimations];
    
}
#pragma mark - Add barbutton
- (void)addBarButtons {
    NSMutableArray *aBarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *aLeftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStyleDone target:self action:@selector(showPressed)];
    self.navigationItem.leftBarButtonItem = aLeftBarButton;
    [aBarItems addObject:aLeftBarButton];
    
    UIBarButtonItem *aHomeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(homePressed)];
    [aBarItems addObject:aHomeButton];
    self.navigationItem.leftBarButtonItems = (NSArray *)aBarItems;
    [aHomeButton release];
    aHomeButton = nil;
    [aLeftBarButton release];
    aLeftBarButton = nil;
    [aBarItems release];
    aBarItems = nil;
    
    UIBarButtonItem *aRightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleDone target:self action:@selector(exitPressed)];
    self.navigationItem.rightBarButtonItem = aRightBarButton;
    [aRightBarButton release];
    aRightBarButton = nil;
}

#pragma mark - load parents
- (void)loadParentThumbs {

    CGFloat xVal = 120.0;
    CGFloat yVal = 0.0;
    CGFloat thumbWidth = 128;
    CGFloat thumbHeight = 128;
    
//    NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(localizedStandardCompare:)]]];
    
      NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    //NSArray *sortedArray = (NSArray *)aParents;
    
    self.pageControl.currentPage = 0;
    //self.pageControl.//.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.numberOfPages = [sortedArray count];
    int i = 0;
    
    
    NSLog(@"parent name =%d",[sortedArray count]);
        for(Parent *aParent in sortedArray){
        ThumbView *aThumbView = [[ThumbView alloc] init];
        aThumbView.aDelegate = self;
        aThumbView.tag = i+1;
        aThumbView.frame = CGRectMake(xVal ,yVal, thumbWidth, thumbHeight);
      
        UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, thumbWidth, thumbHeight)];
            NSData *data = [NSData dataWithContentsOfFile:aParent.slideBgPath];
            
            UIImage *image = [UIImage imageWithData:data];

            mainImgView.image = image;
        [aThumbView addSubview:mainImgView];
        [mainImgView release];
        mainImgView = nil;
            
            
        
        xVal = xVal + thumbWidth + 10;
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 53, 68, 21)];
        aLabel.text = aParent.parentName;
        [aLabel setBackgroundColor:[UIColor clearColor]];
        aLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        aLabel.textColor = [UIColor blackColor];
        aLabel.textAlignment = UITextAlignmentCenter;//NSTextAlignmentCenter;//UITextAlignmentCenter;
        [aThumbView addSubview:aLabel];
        [aLabel release];
        aLabel = nil;
        
        [self.slidesScrollView addSubview:aThumbView];
            
        [aThumbView release];
        aThumbView = nil;
        i++;
    }
    
    [self.slidesScrollView setContentSize:CGSizeMake(xVal, 128)];
}

#pragma mark - Gesture Recognizer
- (void)handleSingleTApGesture:(UISwipeGestureRecognizer *)iTap {
     NSLog(@"*******");
}

- (void)longTapAction:(UILongPressGestureRecognizer *) tapRec {
    
    NSLog(@"long tap detected");
    [self swipeDown];
    [self exitViewDown];
    //self.exitButton.hidden = NO;
}


#pragma mark - Reload thumb Views
- (void)reloadThumbsForIndex {
    for(UIImageView *aSubView in self.slideDetailsScrollView.subviews){
        [aSubView removeFromSuperview];
    }
    SlidesSubView *aSubview;
    
//    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"AllParents"];
//    NSMutableArray *aParents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
   
    
   // NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(localizedStandardCompare:)]]];
    
    NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    
    NSLog(@"Sorted Error = %@",sortedArray);
    
    //NSArray *sortedArray = (NSArray *)aParents;
    
    CGFloat x = (self.view.frame.size.width/2) - 365.0;
    NSLog(@"x : %f",x);
    CGFloat y = 20.0;
    int parentIndex = 0;
       
    for(Parent *aParent in sortedArray) {
        
        UIView *aView = [[UIView alloc] init];
        aView.frame = CGRectMake(x, y,980, 720);
        aView.backgroundColor = [UIColor grayColor];
        //aView.layer.cornerRadius = 14.0;
        aView.layer.borderColor = [UIColor blackColor].CGColor;
        aView.layer.borderWidth = 2.0;
        aView.layer.shadowColor = [UIColor blackColor].CGColor;
        aView.layer.shadowOffset = CGSizeMake(0, aView.frame.size.height+10);
        aView.layer.shadowOpacity = 0.3;
        
        UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,980, 720)];
        NSData *data = [NSData dataWithContentsOfFile:aParent.slideBgPath];
        
        UIImage *image = [UIImage imageWithData:data];

        mainImgView.image = image;
        [aView addSubview:mainImgView];
        [mainImgView release];
        mainImgView = nil;
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(longTapAction:)];
        longPress.minimumPressDuration = 0.5;
        [aView addGestureRecognizer:longPress];
        [longPress release];


        x = x + self.slideDetailsScrollView.frame.size.width + 256;
        
        CGFloat xVal = 70.0;
        CGFloat yVal = 70.0;
        CGFloat thumbWidth = 200;
        CGFloat thumbHeight = 200;
        int i = 0;
        
        for(Child *aChild in aParent.childs) {
            // UIView *aView = [[UIView alloc] init];
            
            if([aParent.hasChilds boolValue]) {
                aSubview = [[SlidesSubView alloc] init];
                aSubview.tag = i;
                aSubview.aDelegate = self;
                aSubview.frame = CGRectFromString(aChild.frame);

                
                NSURL *url;
                if (![aChild.filePath isEqualToString:nil]) {
                    url = [NSURL fileURLWithPath:aChild.filePath];
                }
                
                UITextField *textView;
                UIImageView *imgView;
                
                UITapGestureRecognizer *webViewTapped;
                NSLog(@"Child Frame = %@,child Name %@",NSStringFromCGRect(aSubview.frame),aChild.childName);
                
                switch ([aChild.contentType integerValue]) {
                    case 2: // Image

                        
                        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, aSubview.frame.size.width, aSubview.frame.size.height)];
                        [imgView setImage:[UIImage imageWithContentsOfFile:aChild.filePath]];
                        [imgView setUserInteractionEnabled:YES];
                        
                        
                        webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:aSubview action:@selector(tapAction:)];
                        webViewTapped.numberOfTapsRequired = 1;
                        webViewTapped.delegate = aSubview;
                        [imgView addGestureRecognizer:webViewTapped];
                        [aSubview addSubview:imgView];
//
                        
                        break;
                        
                    case 1: // text
                        textView = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, aSubview.frame.size.width, aSubview.frame.size.height)];
                        textView.text = aChild.text;
                        NSString *stringColor = aChild.textColour;
                        NSUInteger red, green, blue;
                        sscanf([stringColor UTF8String], "#%02X%02X%02X", &red, &green, &blue);
                        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
                        NSLog(@"colr = %@",color);
                        [textView setEnabled:NO];
                        
                        
                        textView.font = [UIFont fontWithName:@"Arial" size:[aChild.textSize floatValue]];
                        [aSubview addSubview:textView];
                        
                        break;
                       case 3:
                       
                        mpPlayer = [[MPMoviePlayerController alloc] init];
                        [mpPlayer setContentURL:url];
                        [mpPlayer.view setFrame:CGRectMake (0, 0, aSubview.frame.size.width, aSubview.frame.size.height)];
                        [mpPlayer setMovieSourceType:MPMovieSourceTypeFile];
                        [mpPlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                        //[mpPlayer requestThumbnailImagesAtTimes:[NSArray arrayWithObject:0]timeOption:MPMovieTimeOptionExact];
                        [mpPlayer pause];
                        

                        
                        webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:aSubview action:@selector(tapAction:)];
                        webViewTapped.numberOfTapsRequired = 1;
                        webViewTapped.delegate = aSubview;
                        [mpPlayer.view addGestureRecognizer:webViewTapped];
                        [aSubview addSubview:mpPlayer.view];

                        
//                        webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:aSubview action:@selector(tapAction:)];
//                        webViewTapped.numberOfTapsRequired = 1;
//                        webViewTapped.delegate = aSubview;
//                        [mpPlayer.view addGestureRecognizer:webViewTapped];
//                        [aSubview addSubview:mpPlayer.view];
                        break;
                    case 4:
//                        aButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//                        aButton.frame = CGRectMake(0, 0, 30, 30);
//                        [aButton addTarget:self action:@selector(referenceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//                        [aSubview addSubview:aButton];
//                        //[aView addSubview:buttonSubview];
                        
                        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, aSubview.frame.size.width, aSubview.frame.size.height)];
                        [imgView setImage:[UIImage imageWithContentsOfFile:aChild.filePath]];
                        [imgView setUserInteractionEnabled:YES];
                        
                        
                        webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:aSubview action:@selector(tapAction:)];
                        webViewTapped.numberOfTapsRequired = 1;
                        webViewTapped.delegate = aSubview;
                        [imgView addGestureRecognizer:webViewTapped];
                        [aSubview addSubview:imgView];
                           [webViewTapped release];
                        break;
                    default:
                        //[aWebView loadRequest:[NSURLRequest requestWithURL:url]];
                        break;
                }
               
                
                UILabel *aTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aSubview.frame.size.height - 20, aSubview.frame.size.width,20)];
                aTimeLabel.backgroundColor  = [UIColor clearColor];
                aTimeLabel.textColor = [UIColor redColor];
                aTimeLabel.tag = 100 + aSubview.tag;
                [aSubview addSubview:aTimeLabel];
                [aTimeLabel release];
                aTimeLabel = nil;
                                
                if (i%1 == 0 && i != 0 && i <= 1) {
                    xVal = 70.0;
                    yVal = yVal + thumbHeight + 70.0;
                }else {
                    xVal = xVal + thumbWidth + 70;
                }
                
                
//                aSubview.layer.cornerRadius = 4.0;
//                aSubview.layer.borderColor = [UIColor blackColor].CGColor;
//                aSubview.layer.borderWidth = 2.0;
                
              [aView addSubview:aSubview];
                
                //Time being to add reference button....
                /*
                if (parentIndex == 1) {//&& ![aChild.filePath isEqualToString:@"Mylan AdD3"]) {
                    
                    SlidesSubView *buttonSubview = [[SlidesSubView alloc] init];
                    buttonSubview.tag = i;
                    buttonSubview.aDelegate = self;
                    buttonSubview.frame = CGRectMake(670, 380, 30, 30);
                    buttonSubview.backgroundColor = [UIColor clearColor];
                    
                    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
                    aButton.frame = CGRectMake(0, 0, 30, 30);
                    [aButton addTarget:self action:@selector(referenceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [buttonSubview addSubview:aButton];
                    [aView addSubview:buttonSubview];
                    [buttonSubview release];
                    buttonSubview = nil;
                }
                 */
                i++;
            }
        }
        
        [self.slideDetailsScrollView addSubview:aView];
        self.slideDetailsScrollView.contentOffset = CGPointMake(x, 0);
        [aView release];
        aView = nil;
        parentIndex ++;
    }
    sortedArray = nil;
    self.slideDetailsScrollView.contentSize = CGSizeMake(x, 0);
    self.slideDetailsScrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark - Actions

- (IBAction)homeButtonPressed:(id)sender {
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
   // [self stopChildTimer];
    [self stopParentTimer];
    //[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)exitButtonPressed:(id)sender {
    
    AppDelegate *aDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (aDelegate.Bid==nil)
    {
        NSLog(@"You need to launch this app from Mylan offline app to exit");
    }
    else
    {
    
    Brand *aBrand = [Utility getBrandIfExist:aDelegate.Bid];
    
    
    Content *aContent = [self getContentData:ContentID];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    aContent.contEndTime =  [dateFormatter stringFromDate:[NSDate date]];

    [aDelegate.managedObjectContext save:nil];
    
        [self stopParentTimer];
        //[self stopChildTimer];

    Karbens_Brand *kBrand     = [[Karbens_Brand alloc] init];
    Karbens_Content *kContent = [[Karbens_Content alloc] init];
//    Karbens_Parent *kParent   = [[Karbens_Parent alloc]init];
//    Karbens_Child *kChild     = [[Karbens_Child alloc]init];
//    Karbens_Reference *kRef   = [[Karbens_Reference alloc]init];
//    Karbens_datalist *kDl     = [[Karbens_datalist alloc]init];
//    Karbens_Summ *kSumm       = [[Karbens_Summ alloc]init];
//    Karbens_Video *kVid       = [[Karbens_Video alloc]init];
        
    
    
    kBrand.contents    = [[NSMutableArray alloc]init];
    kContent.datalists = [[NSMutableArray alloc]init];
    kContent.Summarys  = [[NSMutableArray alloc]init];
    kContent.parent    = [[NSMutableArray alloc]init];
   

    
    
    
    
    kBrand.brandId = aBrand.brandId;//aContent.brand.brandId;
    kBrand.brandName = aBrand.brandName;//aContent.brand.brandName;
    
//    kBrand.brandId = aContent.brand.brandId;
//    kBrand.brandName = aContent.brand.brandName;

    
    kContent.contentId    = aContent.contentId;
    kContent.contentName  = aContent.contentName;
    kContent.contStartTime= aContent.contStartTime;
    kContent.contEndTime  = aContent.contEndTime;
    
    //aContent.brand = aBrand;
    
    for (int i = 0; i<[[aContent.parent allObjects] count]; i++) {
        
        Parent *p = [[aContent.parent allObjects] objectAtIndex:i];
        Karbens_Parent *kParent   = [[Karbens_Parent alloc]init];

        kParent.parentid       = p.parentid;
        kParent.parentName     = p.parentName;
        kParent.hasChilds      = p.hasChilds;
        kParent.parentStartTime= p.parentStartTime;
        kParent.parentEndTime  = p.parentEndTime;
        
//        unsigned int value1=[Time converstionofmilliseconds:kParent.parentStartTime];
//        unsigned int value2=[Time converstionofmilliseconds:kParent.parentEndTime];
//        NSString *timediff=[Time difference:value1 betweenthem:value2];
        
        kParent.parentViewTime = p.parentViewTime;
        
        //kParent.parentViewTime = p.parentViewTime;
        kParent.timeInterval   = p.timeInterval;
        kParent.viewDate       = p.viewDate;
        
        NSLog(@"P Name:%@",p.parentName);
        
        kParent.childs     = [[NSMutableArray alloc]init];
        
        
        for(int j = 0 ; j<[[p.childs allObjects]count];j++)
        {
            Karbens_Child *kChild     = [[Karbens_Child alloc]init];
            Child *c = [[p.childs allObjects ] objectAtIndex:j];
           
            
            NSLog(@"C Name:%@",c.childName);
            
            kChild.childEndTime    = c.childEndTime;
            kChild.childid         = c.childid;
            kChild.childName       = c.childName;
            kChild.childStartTime  = c.childStartTime;
            
//            unsigned int value1=[Time converstionofmilliseconds:kChild.childStartTime];
//            unsigned int value2=[Time converstionofmilliseconds:kChild.childEndTime];
//            NSString *timediff=[Time difference:value1 betweenthem:value2];
            
            kChild.childViewTime = c.childViewTime;
            
           // kChild.childViewTime   = c.childViewTime;
            kChild.contentType     = c.contentType;
            kChild.timeInterval    = c.timeInterval;
            kChild.type            = [c.contentType stringValue];
            
            
            
            
            kChild.references  = [[NSMutableArray alloc]init];
            
            for(int k = 0; k<[[c.references allObjects] count]; k++)
            {
                 Karbens_Reference *kRef   = [[Karbens_Reference alloc]init];
                Reference *r = [[c.references allObjects] objectAtIndex:k];
                NSLog(@"R Name:%@",r.contentUrl);
                
                
                kRef.referenceId           = r.referenceId;
                kRef.referenceName         = r.referenceName;
                kRef.referenceStartTime    = r.refStartTime;
                kRef.referenceEndTime      = r.refEndTime;
                
//                unsigned int value1=[Time converstionofmilliseconds:kRef.referenceStartTime];
//                unsigned int value2=[Time converstionofmilliseconds:kRef.referenceEndTime];
//                NSString *timediff=[Time difference:value1 betweenthem:value2];
                
                kRef.referenceViewTime = r.refViewTime;

                kRef.referencetimeInterval = r.refTimeInterval;
               // kRef.referenceViewTime     = r.refViewTime;
                
                [kChild.references addObject:kRef];

            }
            
            [kParent.childs addObject:kChild];
 
        }
        [kContent.parent addObject:kParent];
        
    }
        
        for (int i = 0; i<[[aContent.datalist allObjects] count]; i++) {
            
            Karbens_datalist *kDl     = [[Karbens_datalist alloc]init];
            DataList *D = [[aContent.datalist allObjects] objectAtIndex:i];
            
            kDl.DLId          = D.dlid;
            kDl.DLName        = D.dlTopic;
            kDl.DLStartTime   = D.dlstartTime;
            kDl.DLEndTime     = D.dlEndTime;
            
//            unsigned int value1=[Time converstionofmilliseconds:kDl.DLStartTime];
//            unsigned int value2=[Time converstionofmilliseconds:kDl.DLEndTime];
//            NSString *timediff=[Time difference:value1 betweenthem:value2];
            
            kDl.DLViewTime = D.dlViewTime;
            
            kDl.DLtimeInterval= D.dlTimeInterval;
           
            [kContent.datalists addObject:kDl];
        
        }
        for (int i = 0; i<[[aContent.summary allObjects] count]; i++) {
            
            Karbens_Summ *kSumm       = [[Karbens_Summ alloc]init];
            Summary *S = [[aContent.summary allObjects] objectAtIndex:i];
            
            kSumm.SummId            = S.summID;
            kSumm.SummName          = S.summTitle;
            kSumm.SummStartTime     = S.summStartTime;
            kSumm.SummEndTime       = S.summEndTime;
            
//            unsigned int value1=[Time converstionofmilliseconds:kSumm.SummStartTime];
//            unsigned int value2=[Time converstionofmilliseconds:kSumm.SummEndTime];
//            NSString *timediff=[Time difference:value1 betweenthem:value2];
//            
            kSumm.SummViewTime = S.summViewTime;
            
            kSumm.SummtimeInterval  = S.summTimeInterval;
            
            
            [kContent.Summarys addObject:kSumm];
            
        }

        
    [kBrand.contents addObject:kContent];
    
    NSLog(@"BrandPackage = %@",kBrand);
        
        for (Karbens_Content *kContent in kBrand.contents)
        {
            
            for (Karbens_Parent *Kpar in kContent.parent)
            {
               NSLog(@"Parent StartTime = %@ , Parent End Time = %@ ,parent View Time = %@,parent TimeInterval = %@ for parentID = %@",Kpar.parentStartTime,Kpar.parentEndTime,Kpar.parentViewTime,Kpar.timeInterval,Kpar.parentName);
                
                for (Karbens_Child *kChild in Kpar.childs)
                {
                    NSLog(@"Child StartTime = %@ , Child End Time = %@ ,Child View Time = %@,Child TimeInterval = %@",kChild.childStartTime,kChild.childEndTime,kChild.childViewTime,kChild.timeInterval);
                    
                    for (Karbens_Reference *kRef in kChild.references)
                    {
                        NSLog(@"Ref StartTime = %@ , Ref End Time = %@, Ref View Time = %@,Ref TimeInterval = %@",kRef.referenceStartTime,kRef.referenceEndTime,kRef.referenceViewTime,kRef.referencetimeInterval);
                        
                    }
                    
                    
                }
                
                
            }
            for (Karbens_datalist *KDL in kContent.datalists)
            {
                
                NSLog(@"DataList StartTime = %@ , DataList End Time = %@,DL View Time = %@,DL TimeInterval = %@",KDL.DLStartTime,KDL.DLEndTime,KDL.DLViewTime,KDL.DLtimeInterval);
                
                
            }
            for (Karbens_Summ *KSumm in kContent.Summarys)
            {
                
                NSLog(@"summ StartTime = %@ , summ End Time = %@,Summ View Time = %@,Summ TimeInterval = %@",KSumm.SummStartTime,KSumm.SummEndTime,KSumm.SummViewTime,KSumm.SummtimeInterval);
                
                
            }
        }

    
    NSData *BrandData = [NSKeyedArchiver archivedDataWithRootObject:kBrand];
      
    MDDataPackage *package = [MDDataPackage dataPackageForCurrentApplicationWithPayload:BrandData];
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
    
    
        [Utility clearSlideViewTimes];
}

- (void)referenceButtonPressed:(NSInteger )SlideTag {

      NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    
    // NSArray *sortedArray = (NSArray *)aParents;
    //NSArray *sortedArray = [(NSArray *)self.aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    
    self.selectedSlideIndex = self.pageControl.currentPage;
    
    
    Parent *aParent  = [sortedArray objectAtIndex:self.selectedSlideIndex];
    
    Child *aChild = [[aParent.childs allObjects] objectAtIndex:SlideTag];

    self.refArray = [[NSMutableArray alloc]init];
    self.refArray = (NSMutableArray *)[aChild.references allObjects];
    
    for(Reference *ref in refArray){
        NSLog(@"refDict = %@",ref.filepath);
    }
    
    
    for(UIView *aPopOverView in self.popOverContentController.view.subviews){
        [aPopOverView removeFromSuperview];
    }
    if (nil == self.popOverContentController) {
        UIViewController *aController = [[UIViewController alloc] init];
        self.popOverContentController = aController;
        [aController release];
        aController = nil;
    }
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    self.popOverView = aView;
    [aView release];
    aView = nil;
    
    UITableView *aTableView = [[UITableView alloc] initWithFrame:self.popOverView.frame];
    self.referenceTableView = aTableView;
    self.referenceTableView.delegate = self;
    self.referenceTableView.dataSource = self;
    [self.popOverView addSubview:self.referenceTableView];
    [aTableView release];
    aTableView = nil;
    
    self.popOverContentController.view = self.popOverView;
   
    CGRect rect = CGRectFromString(aChild.frame);
    
    self.popOverContentController.contentSizeForViewInPopover = CGSizeMake(self.popOverView.frame.size.width,self.popOverView.frame.size.height);
    UIPopoverController *aPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.popOverContentController];
    self.popOverController = aPopoverController;
    [self.popOverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [aPopoverController release];
    aPopoverController = nil;
    
}

#pragma mark - master view delegate
- (void)didMasterOptionSelected:(int)index {
    //[self reloadThumbsForIndex:index];
    self.isShowPressed = YES;
}
#pragma mark - slide thumb delegate
- (void)didSlideThumbClicked:(ThumbView *)inThumbView {
    [self swipeUp];
    [self exitViewUp];
    [self stopChildTimer];
    [self stopParentTimer];
    [self.parentStopWatchTimer invalidate];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    int aTag = inThumbView.tag - 1;
    self.selectedSlideIndex = aTag;
    self.pageControl.currentPage = aTag;
    //self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.slideDetailsScrollView.contentOffset = CGPointMake(self.slideDetailsScrollView.frame.size.width * aTag, 0);
    [UIView commitAnimations];
    
    self.parentTimerStartDate = [[NSDate date] retain];
    if (![timerString isEqualToString:@"FromSlideView"]) {
   
    [self startParentTimer];
        
    self.parentStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                 target:self
                                                               selector:@selector(startParentTimer)
                                                               userInfo:nil
                                                                repeats:NO];
   }
   
}

#pragma mark - sub slide view delegate
- (void)didSlideSelected:(SlidesSubView *)inSlideView {//open child in a web view.................
    
    NSLog(@"slide touched : %d",inSlideView.tag);
    
    self.slideSubView = inSlideView;

   // NSArray *sortedArray = [(NSArray *)self.aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    
      NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    
    // NSArray *sortedArray = (NSArray *)aParents;
    self.selectedSlideIndex = self.pageControl.currentPage;
    Parent *aParent  = [sortedArray objectAtIndex:self.selectedSlideIndex];
    
    Child *aChild = [[aParent.childs allObjects] objectAtIndex:inSlideView.tag];
    
    if ([aChild.contentType isEqualToNumber:[NSNumber numberWithInt:4]])
    {
        NSLog(@"ChildType 4");
        [self referenceButtonPressed:inSlideView.tag];
        
    }
    else
    {
        
        
        if ([aChild.contentType integerValue] == 2) {
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^{
                                 self.animatedView.alpha = 1.0;
                              
                                 
                                 Child *aChild = [[aParent.childs allObjects] objectAtIndex:inSlideView.tag];
                                 self.child = aChild;
                         
                                 UIImage *aImage = [UIImage imageWithContentsOfFile:aChild.filePath];
                                 
                                 float width = aImage.size.width;
                                 float hight = aImage.size.height;
                                 
                                 BOOL doesContain ;
                                
                                 doesContain = [self.view.subviews containsObject:animatedView];
                                 if (doesContain == YES) {
                                     [animatedView removeFromSuperview];
                                 }
                                 
                                 animatedView = [[AnimatedView alloc]initWithFrame:CGRectMake(0, 0, width, hight)];
                                 
                                 animatedView.center =CGPointMake(1024/2, 768/2);
                                 
                                 //animatedView.alpha = 0.0;
                                 animatedView.aDelegate = self;
                                 
                                 [animatedView.ImageView  setImage:aImage];
                                 
                                 
                                 [self.view addSubview: animatedView];
                                 
                                 
                                 animatedView.alpha = 1.0;
                                 self.animatedView.transform=CGAffineTransformMakeScale(1, 1);
                                 //self.animatedView.center = CGPointMake(1024/2, 768/2);
                             }
                             completion:^(BOOL finished){
                             }];
            
           

                             
        }
        else if([aChild.contentType integerValue] == 3)
        {
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:(void (^)(void)) ^{
                                
                                 self.animatedVideoView.alpha = 1.0;
                                 
                                 Child *aChild = [[aParent.childs allObjects] objectAtIndex:inSlideView.tag];
                                 self.child = aChild;
                               
                                 BOOL doesContain ;
 
                                 doesContain = [self.view.subviews containsObject:animatedVideoView];
                                 if (doesContain == YES) {
                                     [animatedVideoView removeFromSuperview];
                                 }
                                
                                 animatedVideoView = [[AnimatedVidoeView alloc]initWithFrame:CGRectMake(0, 0, 600, 600)];
                                 
                                 animatedVideoView.center =CGPointMake(1024/2, 768/2);
                                 
                                 //animatedView.alpha = 0.0;
                                 animatedVideoView.aDelegate = self;
                                 
                                 
                                 NSURL *targetURL = [NSURL fileURLWithPath:aChild.filePath];
                                 NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
                                 
                                 [animatedVideoView.webView loadRequest:request];
                                 [self.view addSubview:animatedVideoView];
                                 animatedVideoView.transform=CGAffineTransformMakeScale(1,1);
                                
                             }
                             completion:^(BOOL finished){
                             }];

                                 
        }

    self.timerStartDate = [[NSDate date] retain];
    
    [self startChildTimer:inSlideView.tag];
    
    }
}

-(void)startChildTimer:(int)itemTag{
    
    //Called when tapped on the child
    if (![timerString isEqualToString:@"FromSlideView"]) {
        
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateTimer)
                                   userInfo:nil
                                    repeats:NO];
    }
}
- (void)updateTimer {
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"childid = %@",self.child.childid];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aChildArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    if ([aChildArr count]> 0) {
        
        
        Child *aChild = [aChildArr objectAtIndex:0];
        
        self.child = aChild;
        
        if (aChild.childStartTime.length == 0) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            self.ChildStartTime =  [dateFormatter1 stringFromDate:[NSDate date]];
            aChild.childStartTime = self.ChildStartTime;
            NSLog(@"Child Start Time = %@ for child %@",aChild.childStartTime,aChild.childName);
            
        }
        
        
        
        if (aChild.childViewTime.length > 0) {
            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[aChild.timeInterval doubleValue]];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"mm:ss"];
            [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
            NSString *timeString = [dateFormatter1 stringFromDate:timerDate];
            aChild.childViewTime = timeString;
            // NSLog(@"timeString : %@",timeString);
            self.childTimeInterval = [aChild.timeInterval doubleValue] + 1;
        }
        else {
            NSDate *currentDate1 = [NSDate date];
            NSTimeInterval timeInterval = [currentDate1 timeIntervalSinceDate:_timerStartDate];
            // Add the saved interval
            timeInterval += self.secondsAlreadyRun;
            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
            NSString *timeString=[dateFormatter stringFromDate:timerDate];
            self.child.childViewTime = timeString;
            // NSLog(@"timeString : %@",timeString);
            self.childTimeInterval = timeInterval;
            [dateFormatter release];
            aChild.childViewTime = timeString;
        }
        
        aChild.timeInterval = [NSNumber numberWithDouble:self.childTimeInterval];
        
        
        [aAppDelegate.managedObjectContext save:nil];
    }
}

-(void)stopChildTimer {
    self.slideSubView.timeLabel = (UILabel *)[self.slideSubView viewWithTag:100 + self
                                              .slideSubView.tag];
    self.slideSubView.timeLabel.text = self.child.childViewTime;
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"childid = %@",self.child.childid];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aChildArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    
    if ([aChildArr count] > 0)
    {
        Child *aChild = [aChildArr objectAtIndex:0];
        self.child = aChild;
        
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
        
        self.ChildEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
        aChild.childEndTime = self.ChildEndTime;
        NSLog(@"Child End Time = %@ for child %@",aChild.childEndTime,aChild.childName);
        
        [aAppDelegate.managedObjectContext save:nil];
        
        
        [self.stopWatchTimer invalidate];
    }
    
}

-(void)startParentTimer {
    
//    NSDate *currentDate1 = [NSDate date];
//  
//    NSTimeInterval timeInterval = [currentDate1 timeIntervalSinceDate:self.parentTimerStartDate];
//    // Add the saved interval
//    timeInterval += self.parentSecondsAlreadyRun;
//    
//    NSLog(@"TimeInterval = %f,ParentSec = %d",timeInterval,self.parentSecondsAlreadyRun);
//   
//    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"mm:ss"];
//    
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//    
//    self.parentTimeInterval = timeInterval;
    
    NSArray *aParentList = [self getParentList];
    
    Parent *aParent = [aParentList objectAtIndex:self.selectedSlideIndex];
    

        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
        
        self.parentStartTime =  [dateFormatter1 stringFromDate:[NSDate date]];
    
        
        if (aParent.parentStartTime.length == 0)
        {
        
            [self getSelectedParent:aParent.parentid];
             NSLog(@"ParentStartTime %@ for Slide %d",self.parentStartTime,self.selectedSlideIndex);
   
        }
    
    
//    if (aParent.parentViewTime.length == 0)
//    {
//        NSString *timeString = [dateFormatter stringFromDate:timerDate];
//        self.parentViewTime = timeString;
//        
//    }
//    else
//    {
//      
//        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[aParent.timeInterval doubleValue]];
//       
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//       
//        //[dateFormatter1 setDateFormat:@"mm:ss"];
//       
//       // [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//       
//        NSString *timeString = [dateFormatter1 stringFromDate:timerDate];
//        
//        self.parentViewTime = timeString;
//        
//        self.parentTimeInterval = [aParent.timeInterval doubleValue] + 1;
//    }

  

}

-(void)stopParentTimer{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
   
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    
    self.parentEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];

    unsigned int value1=[Time converstionofmilliseconds:self.parentStartTime];
    unsigned int value2=[Time converstionofmilliseconds:self.parentEndTime];
    NSString *timediff=[Time difference:value1 betweenthem:value2];
    
    self.parentTimeInterval = [timediff doubleValue];
    
  
    NSArray *aParentList = [self getParentList];
    Parent *aParent = [aParentList objectAtIndex:self.selectedSlideIndex];
    
    if ([aParent.parentViewTime length] ==0) {
        self.parentViewTime  = timediff;
    }
    else{
        self.parentViewTime =[NSString stringWithFormat:@"%d",[timediff intValue]+ [aParent.parentViewTime intValue]];
    }
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"parentid = %@",aParent.parentid];
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [aFetchRequest setEntity:aParentEntity];
    
    [aFetchRequest setPredicate:aPredicate];
   
    NSMutableArray *aParentArray = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    if (aParentList.count) {
        
        aParent = [aParentArray objectAtIndex:0];
        
        aParent.parentEndTime = self.parentEndTime;
        aParent.parentViewTime = self.parentViewTime;
        aParent.timeInterval = [NSNumber numberWithDouble:self.parentTimeInterval];
        
       // NSLog(@"ParentEndTime %@ for Slide %d",self.parentEndTime,self.selectedSlideIndex);

        [aAppDelegate.managedObjectContext save:nil];
    }
    self.parentViewTime = nil;
    self.parentTimeInterval = 0;
    
    NSLog(@"Parent StartTime = %@ , Parent End Time = %@ ,parent View Time = %@,parent TimeInterval = %@ for parentname = %@",self.parentStartTime,self.parentEndTime,aParent.parentViewTime,aParent.timeInterval,aParent.parentName);
    
    [self.parentStopWatchTimer invalidate];
        
    // Called when swiped out of current parent

}


- (void)didDoubleTapVideo:(AnimatedVidoeView *)inAnimVideoView{
    
    NSLog(@"Close on double tap");
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.animatedVideoView.alpha = 0.0;
                         self.animatedVideoView.transform=CGAffineTransformMakeScale(0.0, 0.0);
                         [self.animatedVideoView.webView loadHTMLString:nil baseURL:nil];
                         
                        
                        
                         [mpPlayer setMovieSourceType:MPMovieSourceTypeFile];
                         [mpPlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                         //[mpPlayer requestThumbnailImagesAtTimes:[NSArray arrayWithObject:0]timeOption:MPMovieTimeOptionExact];
                         [mpPlayer pause];

                     }
                     completion:^(BOOL finished){
                         // self.animatedView.transform=CGAffineTransformIdentity;
                     }];
    if (![timerString isEqualToString:@"FromSlideView"]) {
        [self stopChildTimer];
    }
    
}
- (void)didDoubleTap:(AnimatedView *)inAnimView{
    
    NSLog(@"Close on double tap");
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.animatedView.alpha = 0.0;
                         self.animatedView.transform=CGAffineTransformMakeScale(0.0, 0.0);
                        // self.animatedView.center = CGPointMake(1024/2, 768/2);
                         // NSLog(@"fram for confirmation is : %@",nsstr);
                     }
                     completion:^(BOOL finished){
                         // self.animatedView.transform=CGAffineTransformIdentity;
                     }];
    if (![timerString isEqualToString:@"FromSlideView"]) {
    [self stopChildTimer];
    }
    
}



#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    
    if (scrollView == self.slideDetailsScrollView)
    {
        self.parentTimerStartDate = [NSDate date];
         if (![timerString isEqualToString:@"FromSlideView"])
         {
             [self stopChildTimer];
             [self stopParentTimer];
             [self startParentTimer];
        
             self.parentStopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(startParentTimer)
                                                             userInfo:nil
                                                              repeats:NO];
             
             
         }
        self.pageControl.currentPage = lround(scrollView.contentOffset.x /
                                              (scrollView.contentSize.width / self.pageControl.numberOfPages));
        self.selectedSlideIndex = self.pageControl.currentPage;
        
        
    }
}

#pragma nark - Get Parents
- (NSArray *)getParentList {
    
    NSNumber *Cid = ContentID;
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contentId = %@", Cid];
    [request setPredicate:predicate];
    
    NSMutableArray *ContentArray =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    ///NSLog(@"cont = %@",[[[ContentArray objectAtIndex:0] parent] allObjects] );
    //    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"AllParents"];
    
    NSArray *dBParents = [[[ContentArray objectAtIndex:0] parent] allObjects];
    
    NSArray *sortedArray = [(NSArray *)dBParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    
    NSArray *aParentList = sortedArray;
    return aParentList;
}

#pragma mark - Get Content
- (Content *)getContentData :(NSNumber *)Cid{
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //NSFetchRequest *request = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"aContent"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contentId = %@", ContentID];
    [request setPredicate:predicate];
    
    NSMutableArray *ContentArray =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];

    //NSMutableArray *aContentList = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];

    Content  *aContent  = [ContentArray objectAtIndex:0];

    
    // [aParents sortUsingDescriptors:<#(NSArray *)#>]
    //NSArray *aParentList = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"parentName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    
    return aContent;
}

#pragma mark - Get Selected Parent
- (Parent *)getSelectedParent:(NSNumber *)inParentId {
    
    Parent *aParent = nil;
    
    
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"parentid = %@",inParentId];
    
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aParentList = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    if (aParentList.count) {
         aParent = [aParentList objectAtIndex:0];
        aParent.parentStartTime = self.parentStartTime;
//        aParent.parentViewTime = self.parentViewTime;
//        aParent.timeInterval = [NSNumber numberWithDouble:self.parentTimeInterval];
        [aAppDelegate.managedObjectContext save:nil];
    }
    return aParent;
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.refArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *aCellId = @"cellID";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:aCellId];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCellId] autorelease];
        
    }
    Reference *ref = [self.refArray objectAtIndex:indexPath.row];
    
    if ([ref.referenceName isEqualToString:@""]) {
        cell.textLabel.text = @"Reference";
        
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",ref.referenceName];
    }
    //cell.textLabel.text = @"Reference 1";
    return cell;
}


#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"refArray = %@",self.refArray);
    
    
    Reference *ref = [self.refArray objectAtIndex:indexPath.row];
    NSString *refpath = ref.filepath;
    
    [self.popOverController dismissPopoverAnimated:YES];

    ReferenceViewController *aReferenceController = [[ReferenceViewController alloc] initWithNibName:@"ReferenceViewController" bundle:nil];
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:aReferenceController];
    
    aReferenceController.aPath = refpath;
    [aReferenceController release];
    [self presentViewController:aNavController animated:YES completion:^{
        //
    }];
   
}
- (IBAction)Summary:(id)sender {
    
    [self stopParentTimer];
    _back = @"toSummary";
    SummaryViewController *aSummViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    aSummViewController.aParents =  aParents;
    aSummViewController.ContentID = ContentID;
    
    [self presentModalViewController:aSummViewController animated:YES];
    [aSummViewController release];
    aSummViewController = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    if ([_back isEqualToString:@"toSummary"]) {
        [self startParentTimer];
        _back = nil;
    }
}

- (void)viewDidUnload {
    [self setExitButton:nil];
    [super viewDidUnload];
}



@end
