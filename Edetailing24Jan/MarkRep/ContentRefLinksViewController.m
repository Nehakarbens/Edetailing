//
//  ContentRefLinksViewController.m
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "ContentRefLinksViewController.h"
#import "GridView/GridView.h"
#import <QuickLook/QuickLook.h>
#import "AppDelegate.h"
#import "Content.h"
#import "Parent.h"
#import "Child.h"
#import "Reference.h"
#import "Utility.h"
#import "ReferenceViewController.h"
#import "SummaryViewController.h"
#import "TimeRecord.h"
@interface ContentRefLinksViewController ()

@end

@implementation ContentRefLinksViewController
@synthesize PdfArray,ContentID,aRefPath,aParents;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        Content *aContent = [Utility getContentIfExist:ContentID];
//        
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"HH:mm:ss"];
//        
//        aContent.refEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];
//        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [aAppDelegate.managedObjectContext save:nil];
        
        // in the navigation stack.
       // [self stopChildTimer];
        
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([_back isEqualToString:@"ToRef"])
    {
        [self stopChildTimer];
        _back = nil;

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    UIBarButtonItem *aleftbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Summary" style:UIBarButtonItemStyleBordered target:self action:@selector(Summary)];
    aleftbarButton.style = UIBarButtonItemStyleBordered;
     self.navigationItem.rightBarButtonItem = aleftbarButton;

    
    PdfArray = [[NSMutableArray alloc]init];
    aParents = [[NSMutableArray alloc]init];
    

    
    Content *aContent = [Utility getContentIfExist:ContentID];
    
    aParents = [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
    
    for (int i=0; i< [[aContent.parent allObjects] count]; i++)
    {
        Parent *aParent = [[aContent.parent allObjects] objectAtIndex:i];
        
        for (int j = 0; j < [[aParent.childs allObjects]count]; j++) {
            Child *aChild = [[aParent.childs allObjects] objectAtIndex:j];
            
            if (aChild.contentType == [NSNumber numberWithInt:4]) {
                for (int k = 0 ; k < [[aChild.references allObjects]count]; k++) {
                    Reference *Ref = [[aChild.references allObjects]objectAtIndex:k];
                    [PdfArray addObject:Ref];
                }
                
            }
        }
        
    }
    
    [self loadGridView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadGridView {
    
    CGFloat gridViewWidth = 150.0f;
    CGFloat gridViewHeight = 150.0f;
    int i = 0;
    int j = 1;
    int  k=0;
    NSInteger extrarow;
    if (([PdfArray count]%5)<5 ) {
        extrarow = 1;
    }
    else{
        
        extrarow=0;
    }
    NSInteger numberofRows = ([PdfArray count]/5)+extrarow;
    
    for( j=1; j<=numberofRows ; j++ ) {
		for( i=0; i<[PdfArray count]; i++ ) {
            
            GridView *aGridView = [[GridView alloc] init];
            aGridView.tag = k + 1;
            
            CGRect rect;
            Reference *aRef = [PdfArray objectAtIndex:k++];
            aRefPath = aRef.filepath;
            areference = aRef;
            rect = CGRectMake( i *(gridViewWidth+40)+50, (j-1)*(gridViewHeight+25)+50, gridViewWidth, gridViewHeight+50);
            
            aGridView.frame = rect;
            NSLog(@"tag1 = %d",aGridView.tag);
            //aGridView.brandName = aParent.parentName;
            aGridView.aDelegate = self;
            
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, gridViewWidth-10, gridViewHeight-10)];
             
            //NSString *path = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"pdf"];
            
            UIImageView *mainImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, gridViewWidth, gridViewHeight+50)];
           
            

            NSURL *targetURL = [NSURL fileURLWithPath:aRefPath];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)targetURL);
             mainImgView.image = [self imageFromPDFWithDocumentRef:pdf];
            
            NSData *data = [NSData dataWithContentsOfFile:aRefPath];
            [webView loadData:data MIMEType: @"application/pdf" textEncodingName: nil baseURL:nil];
            [webView loadRequest:request];
            
            [aGridView addSubview:mainImgView];
            //[self.view addSubview:webView];
            [webView release];
            webView = nil;
            
            

            aGridView.backgroundColor =
            [UIColor whiteColor];
            aGridView.layer.cornerRadius = 8.0;
            aGridView.layer.borderWidth = 3.0;
            aGridView.layer.borderColor = [UIColor grayColor].CGColor;
            //aGridView.layer.shadowColor = [UIColor grayColor].CGColor;
            aGridView.layer.shadowOffset = CGSizeMake(aGridView.frame.size.width, aGridView.frame.size.height);
            [self.view addSubview:aGridView];
            [aGridView layoutIfNeeded];
            [aGridView release];
            aGridView = nil;
            //i++;
            //j++;
            
        }
        
        
    }
}

- (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef {
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFBleedBox);
    //CGRect pageRect = CGRectMake(-10, 0, 200, 300);
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}


-(void)didBrandSelected:(GridView *)inGridView{
    
    ReferenceViewController *aReferenceController = [[ReferenceViewController alloc] initWithNibName:@"ReferenceViewController" bundle:nil];
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:aReferenceController];
    
    aReferenceController.aPath = [[PdfArray objectAtIndex:inGridView.tag-1]filepath];
    self.back = @"ToRef";
    [aReferenceController release];
    [self presentViewController:aNavController animated:YES completion:^{
        //
    }];
    [self startChildTimer:inGridView.tag-1];

//    QLPreviewController *previewController = [[QLPreviewController alloc] init];
//    previewController.dataSource = self;
//    previewController.delegate = self;
//    
//    //previewController.currentPreviewItemIndex = inGridView.tag -1;
//    [self presentModalViewController:previewController animated:YES];
//    [previewController release];
}


-(void)startChildTimer:(int)itemTag{
    
    //Called when tapped on the child
//    
//    
//    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0                                                               target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
//    
//}
//- (void)updateTimer{
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"referenceId = %@",areference.referenceId];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aRefArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    if ([aRefArr count]> 0) {
        
        
        Reference *aRefr = [aRefArr objectAtIndex:0];
        
        areference = aRefr;
        
     
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            self.refStartTime = [dateFormatter1 stringFromDate:[NSDate date]];;
            NSLog(@"Ref Start Time = %@ for Ref %@",aRefr.refStartTime,aRefr.referenceName);
           if (aRefr.refStartTime.length == 0)
           {
               aRefr.refStartTime = self.refStartTime;
             [aAppDelegate.managedObjectContext save:nil];
            }
        
        
        
//        if (aRefr.refViewTime.length > 0) {
//            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[aRefr.refTimeInterval doubleValue]];
//            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//            [dateFormatter1 setDateFormat:@"mm:ss"];
//            [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//            NSString *timeString = [dateFormatter1 stringFromDate:timerDate];
//            aRefr.refViewTime = timeString;
//            // NSLog(@"timeString : %@",timeString);
//            self.refTimeInterval = [aRefr.refTimeInterval doubleValue] + 1;
//        }
//        else {
//            NSDate *currentDate1 = [NSDate date];
//            NSTimeInterval timeInterval = [currentDate1 timeIntervalSinceDate:_timerStartDate];
//            // Add the saved interval
//            timeInterval += self.secondsAlreadyRun;
//            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"mm:ss"];
//            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//            NSString *timeString=[dateFormatter stringFromDate:timerDate];
//            areference.refViewTime = timeString;
//            // NSLog(@"timeString : %@",timeString);
//            self.refTimeInterval = timeInterval;
//            [dateFormatter release];
//            aRefr.refViewTime = timeString;
//        }
//        
//        aRefr.refTimeInterval = [NSNumber numberWithDouble:self.refTimeInterval];
        
        
       
    }
}

-(void)stopChildTimer {
 
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"referenceId = %@",areference.referenceId];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    NSMutableArray *aRefArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    self.refEndTime =  [dateFormatter1 stringFromDate:[NSDate date]];

    
    if ([aRefArr count] > 0)
    {
        unsigned int value1=[Time converstionofmilliseconds:self.refStartTime];
        unsigned int value2=[Time converstionofmilliseconds:self.refEndTime];
        NSString *timediff=[Time difference:value1 betweenthem:value2];
        
        self.refTimeInterval = [timediff doubleValue];

        Reference *aRefr = [aRefArr objectAtIndex:0];
        areference = aRefr;
        
        if ([aRefr.refViewTime length] == 0) {
            self.refViewTime  = timediff;
        }
        else{
            self.refViewTime =[NSString stringWithFormat:@"%d",[timediff intValue]+ [aRefr.refViewTime intValue]];
        }
      
     
        
        aRefr.refEndTime = self.refEndTime;
        aRefr.refViewTime = self.refViewTime;
        aRefr.refTimeInterval =[NSNumber numberWithDouble:self.refTimeInterval];
        
        [aAppDelegate.managedObjectContext save:nil];
        self.refViewTime = nil;
        self.refTimeInterval = 0;
        
        NSLog(@"REF StartTime = %@ , REF End Time = %@ ,REF View Time = %@,REF TimeInterval = %@ for REF = %@",self.refStartTime,self.refEndTime,aRefr.refViewTime,aRefr.refTimeInterval,aRefr.referenceName);

        
        [self.stopWatchTimer invalidate];
    }
    
    
}
-(void)Summary
{
    SummaryViewController *aSummViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    aSummViewController.aParents =  aParents;
    aSummViewController.ContentID = ContentID;

   [self presentModalViewController:aSummViewController animated:YES];
    [aSummViewController release];
    aSummViewController = nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
