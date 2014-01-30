//
//  ContentViewController.m
//  MyDay
//
//  Created by Akshay Kunila on 03/09/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "ContentViewController.h"
#import "GridView.h"
#import <QuartzCore/QuartzCore.h>
#import "SlideViewController.h"
#import "Content.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "Parser.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "MultipleDownload.h"
#import "ContentDownloader.h"
#import "Reachability.h"
#import "ContentDetailViewController.h"
#import <objc/runtime.h>


static UIView *Grid;
@interface ContentViewController ()
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
@end

@implementation ContentViewController

@synthesize contents,DownloadArr,gridViewArray,brandID,brandIndex,contentID,isDetailing  ;
@synthesize fetchedResultsController = _fetchedResultsController;

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
   
    
    //gridViewArray = [[NSMutableArray alloc]init];
    
    

      /*
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

       //UrlStr =[NSString stringWithFormat:@"http://doctoraccess.in/E-detailing/webservices/edetailerXml.php?username=%@&password=%@&date=%@&cid=%@",@"strides",@"strides123",dateString,cidString];
       
        
        UrlStr = [NSString stringWithFormat:@"http://173.192.152.119/E-detailing/webservices/edetailerXml.php?username=00900034&password=123456&date=%@&cid=%@",dateString,cidString];
        
        //UrlStr =[NSString stringWithFormat:@"%s","http://doctoraccess.in/E-detailing/webservices/edetailerXml.php?username=strides&password=strides123&date=&cid="];

         Parser *parse = [[Parser alloc]init];
        [parse requestWithUrls:UrlStr];

        contents = [[NSMutableArray alloc]initWithArray:aAppDelegate.contentArr];//tempContent];
        [self loadGridView];
    }
    else
    {
        [self getDownloadedContents];
    }
     
       */
    
    BOOL hasInternet = [self checkInternet];
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"isMylan = %hhd",aAppDelegate.isMylan);

    if(hasInternet == TRUE)
    {
        Brand *aBrand = [Utility getBrandIfExist:brandID];
        for (NSMutableDictionary *bDict in aAppDelegate.brandArr) {
            
            
            if ([[bDict objectForKey:@"BrandId"] isEqualToString:[NSString stringWithFormat:@"%@",brandID]])
            {
                brandIndex = [aAppDelegate.brandArr indexOfObject:bDict];
            }
        }

        
        //Brand *aBrand = [aAppDelegate.dbBrandArr objectAtIndex:brandIndex];
        
        NSLog(@"brandIndex = %d name = %@ contCount %d",brandIndex,brandID,[[aBrand.contents allObjects] count]);
      
        if(isDetailing == TRUE)
        {
            // Load specific content passed from mylan app
            
            Content *aContent = [Utility getContentIfExist:contentID];
            
            contents = [[NSMutableArray alloc]init];
            
            [contents addObject:aContent];
        }
        else
        {
            // load all contents for the brand selected
            contents = [[NSMutableArray alloc]init];
            
            contents = [[NSMutableArray alloc]initWithArray:[aBrand.contents allObjects]];
         
    }
        if ([contents count]== 0) {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Content does not Exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alertView show];

        }
        else
        {
           [self loadGridView];
        }
        

    }
    else
    {
        
        [self getDownloadedContents];

    }
   
    NSLog(@"contents = %@",contents);
     Brand *aBrand = [Utility getBrandIfExist:brandID];
    self.title = aBrand.brandName;
    NSString *Str = [NSString stringWithFormat:@"< %@",aBrand.brandName];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:Str style: UIBarButtonItemStyleBordered target:self action: @selector(BACK:)];
    
    [[self navigationItem] setLeftBarButtonItem:newBackButton];
    [newBackButton release];
    float sizeOfContent = 0;
    UIView *lLast = [_ScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height+30;
    
    sizeOfContent = wd+ht;
    
    _ScrollView.contentSize = CGSizeMake(_ScrollView.frame.size.width, sizeOfContent);

    
   
}
-(void)getDownloadedContents{
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downStatus == %d", 1];
    [request setPredicate:predicate];
    
    aContents =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (contents == nil)
    {
        contents = [[NSMutableArray alloc]initWithArray:aContents];
    }
    else
    {
        [contents release];
         contents = [[NSMutableArray alloc]initWithArray:aContents];
    }
    
    
    [contents setArray:[[NSSet setWithArray:contents]allObjects]];
    
    if ([contents count]== 0) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Content does not Exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alertView show];
        
    }
    else
    {
        [self loadGridView];
    }
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getContents{
    
    
    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"aContent"];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    if (contents == nil)
    {
        contents = [[NSMutableArray alloc]initWithArray:aContents];
    }
    else
    {
        [contents release];
         contents = [[NSMutableArray alloc]initWithArray:aContents];
    }
    
    
    [contents setArray:[[NSSet setWithArray:contents]allObjects]];
    
    [self loadGridView];

}

#pragma mark - Load GridView
- (void)loadGridView {
    
    
    CGFloat gridViewWidth = 150.0f;
    CGFloat gridViewHeight = 150.0f;
    int i = 0;
    int j = 1;
    int k = 0;
    
    for (UIView *aView in [_ScrollView subviews]) {
        [aView removeFromSuperview];
    }
    
    NSInteger extrarow;
    if (([contents count]%5)<5 ) {
        extrarow = 1;
    }
    else{
        
        extrarow=0;
    }
    NSInteger numberofRows = ([contents count]/5)+extrarow;

   
    NSString *Cname;
    
    for( j=1; j<=numberofRows ; j++ )
    {
		for( i=0; i<5 && k<[contents count]; i++ )
        {
            GridView *aGridView = [[GridView alloc] init];
            aGridView.tag = k + 1;
         
                Content *aContent = [contents objectAtIndex:k++];
                Cname = aContent.contentName;
          
          
            CGRect rect;
            
             rect = CGRectMake( i *(gridViewWidth+40)+50, (j-1)*(gridViewHeight+40)+80, gridViewWidth+20, gridViewHeight+20);
            
            aGridView.frame = rect;
            
            UIImageView *mainImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, gridViewWidth+20, gridViewHeight+20)];
            
            
            NSMutableArray *aParents = [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
            
            NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
            
            
            Parent *aPar = [sortedArray objectAtIndex:0];
            
            if (aPar.slideBgPath == nil) {
                
                mainImgView.image = [UIImage imageNamed:@"button frame.png"];
            }
            else{
                NSData *data = [NSData dataWithContentsOfFile:aPar.slideBgPath];
                if (data != nil) {
                    UIImage *image = [UIImage imageWithData:data];
                    mainImgView.image = image;

                }
                else {
                    mainImgView.image = [UIImage imageNamed:@"button frame.png"];
                }
                
            }

            
            if ([aContent.isUpdateAvail isEqualToNumber:[NSNumber numberWithInteger:1]])
            {
                aGridView.UpdateName = @"U";
//                UpdateLable = [[UILabel alloc]initWithFrame:CGRectMake(118, 10, 15, 15)];
//                UpdateLable.text = @"U";
//                UpdateLable.textColor = [UIColor blackColor];
//                UpdateLable.backgroundColor = [UIColor clearColor];
//                [mainImgView addSubview:UpdateLable];
            }
            
            UIImage *image1;

            if ([aContent.downStatus isEqualToNumber:[NSNumber numberWithInt:0]]) // Yet to download
            {
                NSLog(@"Yet to download : %@",aContent.contentName);
                image1 = [UIImage imageNamed:@"download.png"];
                [aGridView Completed:0];
            }
            else if([aContent.downStatus isEqualToNumber:[NSNumber numberWithInt:2]]) // incomplete download
            {
                // Resume button here
                
                NSLog(@"Resume to download : %@",aContent.contentName);
                
                image1 = [UIImage imageNamed:@"resume.png"];
                [aGridView Completed:2];
                [aGridView bringSubviewToFront:aGridView.DownloadProgress];
                [aGridView bringSubviewToFront:aGridView.DownloadButton];
            }
            else
            {
                NSLog(@"Already downloaded");
//                Parent *aP = [[[aContent parent]allObjects]objectAtIndex:0];
////                NSData *data = [NSData dataWithContentsOfFile:[aP slideBgPath]];
////                UIImage *image = [UIImage imageWithData:data];
////
////                mainImgView.image = image;
                if ([aContent.isUpdateAvail isEqualToNumber:[NSNumber numberWithInteger:1]])
                {
                    
                    image1 = [UIImage imageNamed:@"download.png"];
                    [aGridView bringSubviewToFront:aGridView.Updatelabel];
                    [aGridView bringSubviewToFront:aGridView.DownloadProgress];
                    [aGridView bringSubviewToFront:aGridView.DownloadButton];
                }
                else
                    image1 = [UIImage imageNamed:@""];
                    [aGridView Completed:1];
            }
            
   
            
            aGridView.image = image1;

            aGridView.Hidden = YES;
            
            [aGridView addSubview:mainImgView];

            
            [mainImgView release];
            mainImgView = nil;
            
          //  aGridView.tag = i + 1;
            
            aGridView.brandName =Cname;
            
            
            aGridView.image1 = [UIImage imageNamed:@"pause.png"];
            
            aGridView.aDelegate = self;
            aGridView.layer.cornerRadius = 8.0;
            aGridView.layer.borderWidth = 3.0;
            aGridView.layer.borderColor = [UIColor whiteColor].CGColor;
            aGridView.layer.shadowColor = [UIColor grayColor].CGColor;
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(longTapAction:)];
            longPress.minimumPressDuration = 1.0;
            [aGridView addGestureRecognizer:longPress];
            [longPress release];

            [self.ScrollView addSubview:aGridView];

           // [self.view addSubview:aGridView];
            [gridViewArray addObject:aGridView];
            [aGridView layoutIfNeeded];
            [aGridView release];
            aGridView = nil;
            
        }
    }
}
- (void)longTapAction:(UILongPressGestureRecognizer *) tapRec
{
    if (tapRec.state == UIGestureRecognizerStateEnded)
    {
     
        NSLog(@"long tap detected on Content = %@",tapRec.view);
    
        Content *aContent = [contents objectAtIndex:tapRec.view.tag -1 ];
   
        if ([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:1]] || [aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:2]])
        {
   
            UIAlertView *Deletealert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to Delete this content?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [Deletealert show];
            objc_setAssociatedObject(Deletealert, &Grid, tapRec.view, OBJC_ASSOCIATION_RETAIN);
            Deletealert.tag = 2;

        }
    }
   
}

-(void)didFailDownloadWithError:(NSError*)error{

        NSLog(@"Request failed");
}

- (void)didFinishDownload:(NSMutableDictionary*)request{
    
    //NSLog(@"Request complete %@",request);
    
   // ((_bytesReceived/(float)_expectedBytes)*100)/100;
    
    GridView *gridView =[[request objectForKey:@"Content"]objectForKey:@"IndexOfContent"];
    float totalContent  =[[[request objectForKey:@"Content"]objectForKey:@"TotalContent"] floatValue];
    float DownloadContent  =[[[request objectForKey:@"Content"]objectForKey:@"DownloadContent"] floatValue];
    float progressCount  = [[[request objectForKey:@"Content"]objectForKey:@"downloadprogress"] floatValue];
    
    float downloadedContent = totalContent  - DownloadContent;
    
    
    NSLog(@"totalContent = %f",totalContent);
    NSLog(@"DownloadContent = %f",DownloadContent);
    NSLog(@"progressCount = %f",progressCount);
    
    float progressValue = ((1/totalContent) * downloadedContent) + (1/totalContent) * progressCount;
    
    //float processIncrement = ((DownloadContent/totalContent)*100)/100;

    
    NSLog(@"processInc = %f",progressValue);
    [gridView UpdateProgress:progressValue];
    
    if ((downloadedContent+progressCount) == totalContent) {
//        NSMutableDictionary *aContentDict = [request objectForKey:@"Content"];
        [gridView Completed:1];
        [gridView UpdateProgress:1];
        
//        gridView.brandLabel.text = [aContentDict objectForKey:@"contentName"];
//        
//        NSNumber *Cid = [aContentDict objectForKey:@"contentID"];
//        
//        Content *aContent = [Utility getContentIfExist:Cid] ;
//        
//        NSMutableArray *aParents = [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
//        
//        NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
//        
//        if ([sortedArray count] != 0) {
//            
//            Parent *aPar = [sortedArray objectAtIndex:0];
//            
//            NSData *data = [NSData dataWithContentsOfFile:aPar.slideBgPath];
//            UIImage *image = [UIImage imageWithData:data];
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 170, 170)];
//            [imageView setImage:image];
//            
//            [gridView addSubview:imageView];
//            [gridView bringSubviewToFront:gridView.brandLabel];
//
//        }
        
        
        
    }
    
   // DownloadProgressBar.progress = DownloadProgressBar.progress +.1;
    
}

-(void)didFailDownload:(NSMutableDictionary*)Queue{
    
    NSLog(@"Fail Download");
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    GridView *gridView =[[Queue objectForKey:@"Content"]objectForKey:@"IndexOfContent"];
    UIImage *image1 = [UIImage imageNamed:@"resume.png"];
    gridView.image = image1;

    [gridView.DownloadButton setImage:[UIImage imageNamed:@"resume.png"] forState:UIControlStateNormal];
    
    NSUInteger indx = [[_ContentDict objectForKey:@"index"]integerValue];
    
    [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Downloading"];
    
    
    [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Downloading"];
    
    [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx
      ] setObject:@"YES" forKey:@"Paused"];

//    [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx
//      ] setObject:@"YES" forKey:@"Paused"];
}

- (void)didFinishAllDownload{

    NSLog(@"All download complete");
    
//    [gridView UpdateProgress:progressValue];
    
  
    
     //UpdateLable.text = @"";
    
//    for(UIView *view in [self.view subviews])
//    {
//        [view removeFromSuperview];
//    }
//    
//    [self getContents];
    
    
    
}
-(void)didFinishAllDownload:(NSMutableDictionary *)Queue{
    NSLog(@"All download complete Queue");
      AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    GridView *gridView =[[Queue objectForKey:@"Content"]objectForKey:@"IndexOfContent"];
    
      NSMutableDictionary *aContentDict = [Queue objectForKey:@"Content"];
    
    gridView.brandLabel.text = [aContentDict objectForKey:@"contentName"];
    
    NSNumber *Cid = [aContentDict objectForKey:@"contentID"];
    
    Content *aContent = [Utility getContentIfExist:Cid] ;
    
    NSUInteger indx = [[_ContentDict objectForKey:@"index"]integerValue];
    
    [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Downloading"];
    
    NSMutableArray *aParents = [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
    
    NSArray *sortedArray = [(NSArray *)aParents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Parentid" ascending:YES]]];
    
    if ([sortedArray count] != 0) {
        
        Parent *aPar = [sortedArray objectAtIndex:0];
        
        NSData *data = [NSData dataWithContentsOfFile:aPar.slideBgPath];
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 170, 170)];
        [imageView setImage:image];
        
        [gridView addSubview:imageView];
    }
        [gridView bringSubviewToFront:gridView.brandLabel];
        [gridView bringSubviewToFront:gridView.DownloadButton];
        [gridView bringSubviewToFront:gridView.DownloadProgress];
        
    

}

#pragma mark - Brand view delegate
- (void)didContentSelected:(GridView *)inGridView {
    
    
    Content *aContent = [contents objectAtIndex:inGridView.tag -1 ];
    

    
    if ([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:0]])
    {

//        UIAlertView *Downlaodalert = [[UIAlertView alloc]initWithTitle:@"Downlaod First" message:@"Content is not downloaded,Please Download it first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [Downlaodalert show];
        
        UIAlertView *DownloadAlert = [[UIAlertView alloc]initWithTitle:@"Download" message:@"Content is not downloaded,Do you want to download this content?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        DownloadAlert.tag = 3;
        objc_setAssociatedObject(DownloadAlert, &Grid, inGridView, OBJC_ASSOCIATION_RETAIN);

        [DownloadAlert show];
        [DownloadAlert release];
        

    }
    else  if ([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:1]])
    {
        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to go back? Download will be Interrupted if any." delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
//        alertView.tag = 1;
//        [alertView show];
        
        NSNumber *Cid = aContent.contentId;
        
        ContentDetailViewController *aContentDetail = [[ContentDetailViewController alloc] initWithNibName:@"ContentDetailViewController" bundle:nil];
        aContentDetail.BrandID = brandID;
        aContentDetail.aParents = [[NSMutableArray alloc]initWithArray:[[aContent parent]allObjects]];
             aContentDetail.ContentID = Cid;
        //[self presentModalViewController:aContentDetail animated:YES];
        [self.navigationController pushViewController:aContentDetail animated:YES];
        [aContentDetail release];
        aContentDetail = nil;
        

    }
    else if([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:2]])
    {
        UIAlertView *Downlaodalert = [[UIAlertView alloc]initWithTitle:@"Downlaod First" message:@"Content is not downloaded completely,Please download it first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Downlaodalert show];
        
    }

    
}




-(void)DownlaodButtonpressed:(GridView *)inGridView{
    
    
    if(DownloadArr== nil)
    {
        DownloadArr = [[NSMutableArray alloc] init];
    }

    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if(aAppDelegate.isChanged)
    {
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@" Content on Server has changed" message:@" Please Refresh and Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
    [inGridView.DownloadProgress setHidden:NO];
    
     _downloadUrls =[[NSMutableArray alloc]init];
    _ContentDict = [[NSMutableDictionary alloc]init];
    
    for (NSMutableDictionary *bDict in aAppDelegate.brandArr) {
        
        
        if ([[bDict objectForKey:@"BrandId"] isEqualToString:[NSString stringWithFormat:@"%@",brandID]])
        {
            NSMutableArray *CDict = [bDict objectForKey:@"contents"];
            for (NSMutableDictionary *cDict in CDict){
                
                if (contentID == nil) // Edetailing
                {
                    
                    Content *aContent = [contents objectAtIndex:inGridView.tag -1];
                    
                    if([[cDict objectForKey:@"contentID"]isEqualToString:[NSString stringWithFormat:@"%@",aContent.contentId]])
                    {
                        _ContentDict = cDict;
                        NSLog(@"Index = %lu",(unsigned long)[CDict indexOfObject:cDict]);
                        NSString *indx =[NSString stringWithFormat:@"%lu",(unsigned long)[CDict indexOfObject:cDict]];
                        [_ContentDict setObject:indx forKey:@"index"];
                    }
                    
                }
                else // Mylan
                {
                if ([[cDict objectForKey:@"contentID"] isEqualToString:[NSString stringWithFormat:@"%@",contentID]])
                {
                    _ContentDict = cDict;
                    [_ContentDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[CDict indexOfObject:cDict]] forKey:@"index"];
                }
                }
            }
            
        }
        
        
    }
    NSLog(@"ContentDict Count = %d",[_ContentDict count]);
    
    
    [_ContentDict setObject:inGridView forKey:@"IndexOfContent"];
    [_ContentDict setObject:brandID forKey:@"brandID"];
    
    NSMutableDictionary *aBrand = [aAppDelegate.brandArr objectAtIndex:brandIndex];
    [_ContentDict setObject:aBrand forKey:@"brand"];

    
    if ([[_ContentDict objectForKey:@"Downloading"] isEqualToString:@"YES"]) // Pause Action
    {
        
        // cancel download
        
        [inGridView.DownloadButton setImage:[UIImage imageNamed:@"resume.png"] forState:UIControlStateNormal];
        
        
        for (int i=0; i<[DownloadArr count]; i++)
        {
            contDownlaod = [DownloadArr objectAtIndex:i];
            
            if (contDownlaod.contentIndex == inGridView.tag-1)
            {
                NSLog(@"Cancel all download");
               
                for (ASIHTTPRequest *req in contDownlaod.networkQueue.operations)
                {
                    [contDownlaod.networkQueue requestFailed:req];
                    [req setDelegate:nil];
                    [req cancel];
                    
                    
                }
                [networkQueue setDelegate:nil];
                [contDownlaod.networkQueue cancelAllOperations];
                
            }
        }
        
       

        
         NSUInteger indx = [[_ContentDict objectForKey:@"index"]integerValue];
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Downloading"];
        
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Downloading"];
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx
          ] setObject:@"YES" forKey:@"Paused"];

        inGridView.image = [UIImage imageNamed:@"resume.png"];
        
        
    }
    else if([[_ContentDict objectForKey:@"Paused"] isEqualToString:@"YES"]) // Resume Action
    {
        // Start download
        
        contDownlaod  = [[ContentDownloader alloc] init];
        contDownlaod.aDelegate = self;
        contDownlaod.contentIndex = inGridView.tag -1;
        
        //** create dictionary structure of what is yet to be downloaded in the content  **//
        NSLog(@"pause download");
        
        [contDownlaod DownloadContentObject:_ContentDict];
        
        [DownloadArr addObject:contDownlaod];

        
        NSUInteger indx = [[_ContentDict objectForKey:@"index"]integerValue];

        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:inGridView forKey:@"IndexOfContent"];
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"YES" forKey:@"Downloading"];
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Paused"];

        
      
        [inGridView.DownloadButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
    }
    else // Fresh Download
    {
        NSUInteger indx = [[_ContentDict objectForKey:@"index"]integerValue];
         [inGridView.DownloadButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        

        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"YES" forKey:@"Downloading"];
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:@"NO" forKey:@"Paused"];
        
        [[[[aAppDelegate.brandArr objectAtIndex:brandIndex]objectForKey:@"contents"] objectAtIndex:indx] setObject:inGridView forKey:@"IndexOfContent"];

        
        
        contDownlaod  = [[ContentDownloader alloc] init];
        contDownlaod.aDelegate = self;
        contDownlaod.contentIndex = inGridView.tag -1;
        
        //[DownloadProgressBar setTag:contDownlaod.contentIndex];
        [contDownlaod DownloadContentObject:_ContentDict];
        
        [DownloadArr addObject:contDownlaod];
        //contDownlaod = nil
        
        
    }
    }
    

}
-(void)UpdateProgressBar:(NSNotification *)notification{
    NSLog(@"tag = %d",DownloadProgressBar.tag);
    DownloadProgressBar.progress = 0.1+ DownloadProgressBar.progress;
     NSLog(@"progress = %f",DownloadProgressBar.progress);
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
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

//-(void) viewWillDisappear:(BOOL)animated
//{
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are You Sure ,you wants to Go Back,Download will be Interrupted" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
//        alertView.tag = 1;
//        [alertView show];
//        
//        [contDownlaod PausedContentObject];
//    }
////    [super viewWillDisappear:animated];
//}


-(IBAction)BACK:(id)sender{
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL isDownloading;
    for (NSMutableDictionary *bDict in aAppDelegate.brandArr) {
        
        
        if ([[bDict objectForKey:@"BrandId"] isEqualToString:[NSString stringWithFormat:@"%@",brandID]])
        {
            NSMutableArray *CDict = [bDict objectForKey:@"contents"];
            for (NSMutableDictionary *cDict in CDict){
                if ([[cDict objectForKey:@"Downloading"] isEqualToString:@"YES"]) // Pause Action
                {
                    isDownloading = TRUE;
                    break;
                }
                else
                {
                    isDownloading = FALSE;
                    
                }
            }
        }
    }
    
    if (isDownloading == TRUE) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to go back? Download will be Interrupted if any." delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
        alertView.tag = 1;
        [alertView show];

    }
    else{
         [self.navigationController popViewControllerAnimated:YES];
    }
   
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1)
    {
        
        if (buttonIndex == 0) {
            //[contDownlaod PausedContentObject];
            for (int i=0; i<[DownloadArr count]; i++)
            {
                contDownlaod = [DownloadArr objectAtIndex:i];
                
                NSLog(@"Cancel all download");
                [contDownlaod.networkQueue cancelAllOperations];

                for (ASIHTTPRequest *req in contDownlaod.networkQueue.operations)
                    {
                        [contDownlaod.networkQueue requestFailed:req];
                        [req setDelegate:nil];
                        [req cancel];
                        
                        
                    }
                    [networkQueue setDelegate:nil];
                
                
            }

            
            [self.navigationController popViewControllerAnimated:YES];
    }
    
        
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            GridView *inGridView= objc_getAssociatedObject(alertView, &Grid);
            Content *aContent = [contents objectAtIndex:inGridView.tag -1];
            [Utility deleteContent:aContent.contentId];
            [contents removeObject:aContent];
            [self loadGridView];
           
        }
    }
    
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            GridView *inGridView= objc_getAssociatedObject(alertView, &Grid);
            [self DownlaodButtonpressed:inGridView];
            
            
        }
    }
   
}

-(void) viewWillDisappear:(BOOL)animated {
    // if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
    
    // in the navigation stack.
    
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [_ScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
