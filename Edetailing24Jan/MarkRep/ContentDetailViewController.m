//
//  ContentDetailViewController.m
//  EDetailing
//
//  Created by Karbens on 11/7/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "GridView.h"
#import "SlideViewController.h"
#import "DataListViewController.h"
#import "EmailViewController.h"
#import "ContentRefLinksViewController.h"
#import "SummaryViewController.h"
#import "ContentVideosViewController.h"
#import "SlideViewController.h"
#import "MRParentViewController.h"
#import "Utility.h"
#import "Content.h"
#import "AppDelegate.h"
#import "MDDataPackage.h"
#import "MDDataSharingController.h"
#import "Karbens_Brand.h"
#import "Karbens_Content.h"
#import "Karbens_Parent.h"
#import "Karbens_Child.h"
#import "Karbens_Reference.h"
#import "Karbens_datalist.h"
#import "Karbens_Video.h"
#import "Karbens_Summ.h"
#import "TimeRecord.h"

static NSString *kViewerURLScheme = @"com.anant.Mylan";

//static NSString *kViewerURLScheme = @"com.mylan.MyDay";


@interface ContentDetailViewController ()

@end

@implementation ContentDetailViewController
@synthesize aParents,ContentDetails,ContentID,BrandID,ImageArray;

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"isMylan = %hhd",aAppDelegate.isMylan);

    ImageArray = [[NSMutableArray alloc]init];
    
    
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString *Str = [userDefault objectForKey:@"source"];
    if ([Str isEqualToString:@"FromMylan"]) {
        
        
        UIBarButtonItem *ExitButton = [[UIBarButtonItem alloc] initWithTitle: @"Exit" style: UIBarButtonItemStyleBordered target:self action: @selector(Exit:)];
        
        [[self navigationItem] setRightBarButtonItem:ExitButton];
        [ExitButton release];

        
        ContentDetails = [[NSMutableArray alloc]initWithObjects:@"Presentation",@"Videos",@"Reference Link",@"Data List",@"Summary",@"Email",nil];
        ImageArray = [[NSMutableArray alloc]initWithObjects:@"presentation.png",@"video.png",@"reference1b.png",@"Datalists.png",@"summarys.png",@"email.png", nil];
        
        UIViewController *vc = [[self.navigationController viewControllers]objectAtIndex:1];
            
            if([vc isKindOfClass:[ContentViewController class]])
            {
               
            }
            else{
                UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:self action: @selector(BackExit:)];
                
                [[self navigationItem] setLeftBarButtonItem:newBackButton];
                [newBackButton release];
            }
        
      

        

    }
    else{
        ImageArray = [[NSMutableArray alloc]initWithObjects:@"presentation.png",@"video.png",@"reference1b.png",@"Datalists.png",@"summarys.png",@"email.png",@"slideshow.png", nil];
        ContentDetails = [[NSMutableArray alloc]initWithObjects:@"Presentation",@"Videos",@"Reference Link",@"Data List",@"Summary",@"Email" ,@"View Slide",nil];

    }
    
    Content *aContent = [Utility getContentIfExist:ContentID];
    Brand *aBrand = [Utility getBrandIfExist:BrandID];
    self.navigationItem.title =[NSString stringWithFormat:@"%@ - %@",aBrand.brandName,aContent.contentName];
    
//    [aContent release];
//    [aBrand release];
    
   

    [self loadGridView];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)Back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
  
}

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
    
    Content  *aContent  = [ContentArray objectAtIndex:0];
    
    
    return aContent;
}
- (IBAction)Exit:(id)sender
{
    
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
            
            unsigned int value1=[Time converstionofmilliseconds:kParent.parentStartTime];
            unsigned int value2=[Time converstionofmilliseconds:kParent.parentEndTime];
            NSString *timediff=[Time difference:value1 betweenthem:value2];
            
            kParent.parentViewTime = timediff;
            
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
                
                unsigned int value1=[Time converstionofmilliseconds:kChild.childStartTime];
                unsigned int value2=[Time converstionofmilliseconds:kChild.childEndTime];
                NSString *timediff=[Time difference:value1 betweenthem:value2];
                
                kChild.childViewTime = timediff;
                
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
                    
                    unsigned int value1=[Time converstionofmilliseconds:kRef.referenceStartTime];
                    unsigned int value2=[Time converstionofmilliseconds:kRef.referenceEndTime];
                    NSString *timediff=[Time difference:value1 betweenthem:value2];
                    
                    kRef.referenceViewTime = timediff;
                    
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
            
            unsigned int value1=[Time converstionofmilliseconds:kDl.DLStartTime];
            unsigned int value2=[Time converstionofmilliseconds:kDl.DLEndTime];
            NSString *timediff=[Time difference:value1 betweenthem:value2];
            
            kDl.DLViewTime = timediff;
            
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
            
            unsigned int value1=[Time converstionofmilliseconds:kSumm.SummStartTime];
            unsigned int value2=[Time converstionofmilliseconds:kSumm.SummEndTime];
            NSString *timediff=[Time difference:value1 betweenthem:value2];
            
            kSumm.SummViewTime = timediff;
            
            kSumm.SummtimeInterval  = S.summTimeInterval;
            
            
            [kContent.Summarys addObject:kSumm];
            
        }
        
        
        [kBrand.contents addObject:kContent];
        
        for (Karbens_Content *kContent in kBrand.contents)
        {
            
            for (Karbens_Parent *Kpar in kContent.parent)
            {
                NSLog(@"Parent StartTime = %@ , Parent End Time = %@ ,parent View Time = %@,parent TimeInterval = %@ for parentID = %@",Kpar.parentStartTime,Kpar.parentEndTime,Kpar.parentViewTime,Kpar.timeInterval,Kpar.parentid);
                
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

        
        NSLog(@"BrandPackage = %@",[kBrand description]);
        
        
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
    
    
    //[Utility clearSlideViewTimes];
}

-(IBAction)BackExit:(id)sender
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
- (void)loadGridView {
    CGFloat gridViewWidth = 180.0f;
    CGFloat gridViewHeight = 150.0f;
    int i = 0;
    int j = 1;
    int  k=0;
    
    for( j=1; j<=3 ; j++ ) {
		for( i=0; i<5 && k<[ContentDetails count]; i++ ) {
            CGRect rect;
            GridView *aGridView = [[GridView alloc] init];
            
            rect = CGRectMake(i*(gridViewWidth-70)+30, (j-1)*(gridViewHeight+50)+50, gridViewWidth, gridViewHeight);
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            NSString *imageName = [NSString stringWithFormat:@"%@",[ImageArray objectAtIndex:k]];
            mainImgView.image = [UIImage imageNamed:imageName];
            
            [aGridView addSubview:mainImgView];
            
            aGridView.tag = k+1;
            aGridView.frame = rect;
            aGridView.aDelegate = self;
            UILabel *aBrandLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*(gridViewWidth-70)+70, (j-1)*(gridViewHeight+50)+200, 180, 30)];
            aBrandLabel.text = [ContentDetails objectAtIndex:k++];
            [self.view addSubview:aBrandLabel];
            //aGridView.brandName = [ContentDetails objectAtIndex:k++];
            aGridView.backgroundColor = [UIColor grayColor];
            aGridView.layer.cornerRadius = 20.0;
            aGridView.layer.borderWidth = 3.0;
            aGridView.layer.borderColor = [UIColor blackColor].CGColor;
            aGridView.layer.shadowColor = [UIColor grayColor].CGColor;
            aGridView.layer.shadowOffset = CGSizeMake(aGridView.frame.size.width, aGridView.frame.size.height);
            [self.view addSubview:aGridView];
            [aGridView layoutIfNeeded];
            [aGridView release];
            aGridView = nil;
            i++;
        }
    }
}


- (void)didContentDetailViewSelected:(GridView *)inGridView{
    
    NSMutableArray *ParentArr = [[NSMutableArray alloc]init];
    Content *aContent = [Utility getContentIfExist:ContentID];
    for (Parent *aParent in [[aContent parent]allObjects]) {
        if ([aParent.isEnabled isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [ParentArr addObject:aParent];
        }
        
    }
    
    if (inGridView.tag == 1) {
        //prestn
        MRParentViewController *aParentViewController = [[MRParentViewController alloc] initWithNibName:@"MRParentViewController" bundle:nil];
        aParentViewController.BrandID = BrandID;
        aParentViewController.timerString = @"FormPresent";
        aParentViewController.aParents = ParentArr;
        aParentViewController.ContentID = ContentID;
        [self.navigationController pushViewController:aParentViewController animated:YES];
        
        [aParentViewController release];
        aParentViewController = nil;

        
    }
    if (inGridView.tag == 2) {
        //videos

        ContentVideosViewController *aVideoViewController = [[ContentVideosViewController alloc] initWithNibName:@"ContentVideosViewController" bundle:nil];
        
        aVideoViewController.ContentID =  ContentID;
        [self.navigationController pushViewController:aVideoViewController animated:YES];
        [aVideoViewController release];
        aVideoViewController = nil;
        
        Content *content = [Utility getContentIfExist:ContentID];
        if (content.vidStrTime == nil) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            aContent.vidStrTime =  [dateFormatter1 stringFromDate:[NSDate date]];
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [aAppDelegate.managedObjectContext save:nil];

        }
         

    }
    if (inGridView.tag == 3) {
//        //Reference Link
        ContentRefLinksViewController *aRefViewController = [[ContentRefLinksViewController alloc] initWithNibName:@"ContentRefLinksViewController" bundle:nil];
        aRefViewController.ContentID = ContentID;
        
        [self.navigationController pushViewController:aRefViewController animated:YES];
        [aRefViewController release];
        aRefViewController = nil;
        
        Content *content = [Utility getContentIfExist:ContentID];
        if (content.refStrTime == nil) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            aContent.refStrTime =  [dateFormatter1 stringFromDate:[NSDate date]];
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [aAppDelegate.managedObjectContext save:nil];
            
        }

    }
    
    if (inGridView.tag == 4) {
       // Data List
        DataListViewController *aDataList = [[DataListViewController alloc] initWithNibName:@"DataListViewController" bundle:nil];
        aDataList.ContentID = ContentID;
        aDataList.aParents = aParents;
        [self.navigationController pushViewController:aDataList animated:YES];
        [aDataList release];
        aDataList = nil;
        
        Content *content = [Utility getContentIfExist:ContentID];
        if (content.dlStrTime == nil) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            aContent.dlStrTime =  [dateFormatter1 stringFromDate:[NSDate date]];
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [aAppDelegate.managedObjectContext save:nil];
            
        }
        
    }
    if (inGridView.tag == 7) {
        //View Slides
        Content *aContent = [Utility getContentIfExist:ContentID];
        
        SlideViewController *aParentViewController = [[SlideViewController alloc] initWithNibName:@"SlideViewController" bundle:nil];
        aParentViewController.ContentID = ContentID;
        aParentViewController.aParents =  [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
        [self.navigationController pushViewController:aParentViewController animated:YES];
        [aParentViewController release];
        aParentViewController = nil;
        
        
        
    }
    if (inGridView.tag == 6) {
        //Email
        EmailViewController *aEmailViewController = [[EmailViewController alloc] initWithNibName:@"EmailViewController" bundle:nil];
        aEmailViewController.aParents = aParents;
        [self.navigationController pushViewController:aEmailViewController animated:YES];
        [aEmailViewController release];
        aEmailViewController = nil;
        Content *content = [Utility getContentIfExist:ContentID];
        if (content.emailStrTime == nil) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            aContent.emailStrTime =  [dateFormatter1 stringFromDate:[NSDate date]];
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [aAppDelegate.managedObjectContext save:nil];
            
        }

    }
    if (inGridView.tag == 5) {
        //Email
        SummaryViewController *aSummViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
          aSummViewController.aParents =  aParents;
        aSummViewController.ContentID = ContentID;
          [self presentModalViewController:aSummViewController animated:YES];
        //[self.navigationController pushViewController:aSummViewController animated:YES];
        [aSummViewController release];
        aSummViewController = nil;
        
        Content *content = [Utility getContentIfExist:ContentID];
        if (content.sumStrTime == nil) {
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm:ss"];
            
            aContent.sumStrTime =  [dateFormatter1 stringFromDate:[NSDate date]];
            AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [aAppDelegate.managedObjectContext save:nil];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
