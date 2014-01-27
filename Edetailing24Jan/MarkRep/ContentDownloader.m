//
//  ContentDownloader.m
//  MyDay
//
//  Created by Karbens on 10/31/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "ContentDownloader.h"
#import "Content.h"
#import "Parent.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "Child.h"
#import "AppDelegate.h"
#import "Utility.h"

@implementation ContentDownloader
@synthesize contentIndex,QueueArray,networkQueue,aDelegate,ChildContentURLArray,ReferenceURLArray,dwnProgress,ErrorString;


- (id)initWithUrls:(NSArray *)aUrls {
    if ((self = [self init]))
		[self requestWithUrls:aUrls];
	
    
	return self;
}

- (void)requestWithUrls:(NSArray *)aUrls {
    
}

-(void)DownloadContentObject :(NSMutableDictionary *)aContent
{
    dwnProgress = 0;
    NSLog(@"Content Name= %@",[aContent objectForKey:@"contentName"]);
    NSMutableArray * ParentURL  = [[NSMutableArray alloc]init];
    QueueArray = [[NSMutableArray alloc]init];
    ChildContentURLArray = [[NSMutableArray alloc]init];
    NSMutableArray *bURLArray = [[NSMutableArray alloc]init];

    int i = 0;
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *ContentFolder = [documentDirectory stringByAppendingPathComponent:[aContent objectForKey:@"contentName"]];
    
     NSFileManager *fileManager = [[NSFileManager alloc] init];
    
     NSString *BrandFolder = [documentDirectory stringByAppendingPathComponent:@"Brands"];
    
    if (![fileManager fileExistsAtPath:BrandFolder
                          isDirectory:NO])
    
    {
    [fileManager createDirectoryAtPath:BrandFolder
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    }
    
    if (![[aContent objectForKey:@"Paused"] isEqualToString:@"YES"])//fresh download
    {
        // Resume operation so do not repeat already completed operations
        
        
        if ([fileManager fileExistsAtPath:ContentFolder
                              isDirectory:NO])
        {
            [fileManager removeItemAtPath:ContentFolder error:nil];
            
        }
        [fileManager createDirectoryAtPath:ContentFolder
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
        
        
        
    }
    if ([[aContent objectForKey:@"updateAvail"] isEqualToString:@"YES"])//fresh download
    {
        // Resume operation so do not repeat already completed operations
        
        //aContent.contentName];
        
        if ([fileManager fileExistsAtPath:ContentFolder
                              isDirectory:NO])
        {
            [fileManager removeItemAtPath:ContentFolder error:nil];
            
        }
        [fileManager createDirectoryAtPath:ContentFolder
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
        
        
        Content *mContent;
        
//        mContent = [Utility getContentIfExist:[NSNumber numberWithInt:[[aContent valueForKey:@"contentID"]integerValue]]:[NSNumber numberWithInt:[[aContent valueForKey:@"brandID"]integerValue]]];
        mContent = [Utility getContentIfExist:[NSNumber numberWithInt:[[aContent valueForKey:@"contentID"]integerValue]]];
        
        [Utility deleteParents:mContent.contentId];
        
          }
    

        
    networkQueue = [[ASINetworkQueue alloc]init];

    
    [networkQueue setUserInfo:[NSDictionary dictionaryWithObject:aContent forKey:@"Content"]];
    if (!networkQueue)
    {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    failed = NO;
    
    [networkQueue setRequestDidFinishSelector:@selector(imageFetchrequestComplete:)];
    [networkQueue setQueueDidFinishSelector:@selector(imageFetchComplete:)];
    
    [networkQueue setShouldCancelAllRequestsOnFailure:YES];
    [networkQueue setShowAccurateProgress:YES];
    
    [networkQueue setRequestDidFailSelector:@selector(RequestFailed:)];
    [networkQueue setDelegate:self];
    
    
if (![[aContent objectForKey:@"contentName"]isEqualToString:nil]) {

    NSMutableDictionary *abrand = [aContent objectForKey:@"brand"];
    NSString *URLString = [abrand objectForKey:@"brandImageURl"];
    
    NSString *urlStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //aParent.contentUrl;
    NSURL *urlBrand = [NSURL URLWithString:urlStr];
    
    [QueueArray addObject:URLString];
    

    if (![Utility checkIfBrandFilePathExist:[abrand objectForKey:@"BrandId"]])
    {
        [bURLArray addObject:URLString];
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:urlBrand];
        
        NSString* theFileName = [urlStr lastPathComponent];
        
        
        NSString *mediaPath = [BrandFolder stringByAppendingPathComponent:theFileName];
        
        
        [request setDownloadDestinationPath:mediaPath];
        
        
       // [networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
        
        
        [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:abrand,aContent,nil] forKeys:[NSArray arrayWithObjects:@"brand",@"Content" ,nil]]];
        
        [networkQueue addOperation:request];

    }
    
    }
    NSMutableArray *ParentArr = [[NSMutableArray alloc]init];
    ParentArr = [aContent objectForKey:@"Parents"];//aContent.parent;
    
    
    for(NSMutableDictionary *aParent in ParentArr)
    
    {
            
        NSString *URLString = [aParent objectForKey:@"Parenturl"];
            
        NSString *urlStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
            
        [QueueArray addObject:URLString];
            
//            if (!networkQueue)
//            {
//                networkQueue = [[ASINetworkQueue alloc] init];
//            }
//            failed = NO;
//            
//            [networkQueue setRequestDidFinishSelector:@selector(imageFetchrequestComplete:)];
//            [networkQueue setQueueDidFinishSelector:@selector(imageFetchComplete:)];
//            
//            [networkQueue setShouldCancelAllRequestsOnFailure:YES];
//            [networkQueue setShowAccurateProgress:YES];
//            
//            [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
//            [networkQueue setDelegate:self];
//            
            
            
            if (![Utility checkIfParentFilePathExist:[aParent objectForKey:@"Parentid"]])
            {
                ASIHTTPRequest *request;
                request = [ASIHTTPRequest requestWithURL:url];
                
                [ParentURL addObject:[aParent objectForKey:@"Parenturl"]];
                
                
                
                
                NSString *ParentPhotoFolder = [ContentFolder stringByAppendingPathComponent:[aParent objectForKey:@"parentName"]];
                
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                if (![[aContent objectForKey:@"Paused"] isEqualToString:@"YES"])//fresh download
                {
                    
                    
                    if ([fileManager fileExistsAtPath:ParentPhotoFolder
                                          isDirectory:NO])
                    {
                        [fileManager removeItemAtPath:ParentPhotoFolder error:nil];
                    }
                    
                    [fileManager createDirectoryAtPath:ParentPhotoFolder
                           withIntermediateDirectories:NO
                                            attributes:nil
                                                 error:nil];
                }
                
                
                NSString *mediaPath = [ParentPhotoFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[aParent objectForKey:@"parentName"]]];//
                
                
                [request setDownloadDestinationPath:mediaPath];
                
                
               // [networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
                
                
                [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aParent,aContent,nil] forKeys:[NSArray arrayWithObjects:@"parent",@"Content" ,nil]]];
                
                [networkQueue addOperation:request];
            }
            
            
            
            
            NSString *hasChilds = [aParent objectForKey:@"parentChldStatus"];
            
            if ([hasChilds isEqualToString:@"1"])
                           {
                
                NSMutableArray *child =  [aParent objectForKey:@"childs"];
                
                for (NSMutableDictionary *aChild in child)
                {
                    NSString *ChildType = [aChild objectForKey:@"ChildType"];
                    
                    if ([ChildType isEqualToString:@"2"] || [ChildType isEqualToString:@"3"])
                        
                    {
                         [QueueArray addObject:[aChild objectForKey:@"ChildURL"]];
                        
                        if (![Utility checkIfChildFilePathExist:[aChild objectForKey:@"Childid"]])
                        {
                            ASIHTTPRequest *request;
                            
                            [ChildContentURLArray addObject:[aChild objectForKey:@"ChildURL"]];
                            
                           

                            
                            NSString *urlStr = [[aChild objectForKey:@"ChildURL"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            
                            
                            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                            
                            NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                            NSString *ContentPhotoFolder = [documentDirectory stringByAppendingPathComponent:[aContent objectForKey:@"contentName"]];
                         
                            NSString *ParentPhotoFolder = [ContentPhotoFolder stringByAppendingPathComponent:[aParent objectForKey:@"parentName"]];
                            
                            NSString* theFileName = [urlStr lastPathComponent];
                            
                            
                            NSString *mediaPath = [ParentPhotoFolder stringByAppendingPathComponent:theFileName];
                            
                            [request setDownloadDestinationPath:mediaPath];
                            
                            [request setDownloadProgressDelegate:self];
                            
                            
                            
                            [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aChild,aContent,nil] forKeys:[NSArray arrayWithObjects:@"CHILD",@"Content" ,nil]]];
                           
                            [networkQueue addOperation:request];
                        }
                        
                        
                        
                    }
                    
                    
                    
                    if([ChildType isEqualToString:@"4"])
                        
                    {
                        [QueueArray addObject:[aChild objectForKey:@"ChildURL"]];

                        if (![Utility checkIfChildFilePathExist:[aChild objectForKey:@"Childid"]])
                        {
                            ASIHTTPRequest *request;
                            
                            [ChildContentURLArray addObject:[aChild objectForKey:@"ChildURL"]];
                            
                            

                            NSString *urlStr = [[aChild objectForKey:@"ChildURL"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            
                            
                            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                          
                            
                            NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                            NSString *ContentPhotoFolder = [documentDirectory stringByAppendingPathComponent:[aContent objectForKey:@"contentName"]];
                           
                            
                            NSString *ParentPhotoFolder = [ContentPhotoFolder stringByAppendingPathComponent:[aParent objectForKey:@"parentName"]];
                            
                            NSString *mediaPath = [ParentPhotoFolder stringByAppendingPathComponent:[aChild objectForKey:@"ChildName"]];
                            
                            [request setDownloadDestinationPath:mediaPath];
                            
                            [request setDownloadProgressDelegate:self];
                            
                            
                            
                            [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aChild,aContent,nil] forKeys:[NSArray arrayWithObjects:@"CHILD",@"Content" ,nil]]];
                            
                            
                            [networkQueue addOperation:request];
                        }
                        ReferenceURLArray = [[NSMutableArray alloc] init];
                        
                        NSMutableArray *references =  [aChild objectForKey:@"references"];
                        
                        for (NSMutableDictionary *aReference in references)
                        {
                            
                            [QueueArray addObject:[[aReference objectForKey:@"ReferenceUrl"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            
                            if (![Utility checkIfReferenceFilePathExist:[aReference objectForKey:@"Referenceid"]])
                            {
                                ASIHTTPRequest *request;
                                [ReferenceURLArray addObject:[aReference objectForKey:@"ReferenceUrl"]];
                                
                                NSString *urlStr = [[aReference objectForKey:@"ReferenceUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                
                                NSLog(@"urlStr = %@",urlStr);
                                
                                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                                
                                NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                NSString *ContentPhotoFolder = [documentDirectory stringByAppendingPathComponent:[aContent objectForKey:@"contentName"]];
                                
                                NSString *ParentPhotoFolder = [ContentPhotoFolder stringByAppendingPathComponent:[aParent objectForKey:@"parentName"]];
                                NSString *pathChild = [NSString stringWithFormat:@"%@%@",[aChild objectForKey:@"ChildName"],@"Ref"];
                                NSString *ChildRef = [ParentPhotoFolder stringByAppendingPathComponent:pathChild];
                                
                                if ([fileManager fileExistsAtPath:ChildRef
                                                      isDirectory:NO])
                                {
                                    [fileManager removeItemAtPath:ChildRef error:nil];
                                }
                                
                                [fileManager createDirectoryAtPath:ChildRef
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:nil];
                                
                                NSString *path = [NSString stringWithFormat:@"%@%@",[aChild objectForKey:@"ChildName"],[aReference objectForKey:@"Referenceid"]];
                                NSString *mediaPath = [ChildRef stringByAppendingPathComponent:path];
                                
                                
                                [request setDownloadDestinationPath:mediaPath];
                                
                                [request setDownloadProgressDelegate:self];
                                
                                [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aReference,aContent,nil] forKeys:[NSArray arrayWithObjects:@"REFERENCE",@"Content",nil]]];
                                
                                [networkQueue addOperation:request];
                            }
                            
                            
                        }
                    }
                }
            }
            i++;
            
        }

    
    NSMutableArray *DatalistArr = [[NSMutableArray alloc]init];
    DatalistArr = [aContent objectForKey:@"DataLists"];
    NSMutableArray * DlURL  = [[NSMutableArray alloc]init];

    for(NSMutableDictionary *aDataList in DatalistArr)
    {
        NSString *DlType = [aDataList objectForKey:@"dlType"];
        if ([DlType isEqualToString:@"2"] || [DlType isEqualToString:@"3"])
        {
            NSString *URLString = [aDataList objectForKey:@"dlDescription"];
            NSString *urlStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
           // NSURL *url = [NSURL URLWithString:urlStr];
            
            [QueueArray addObject:URLString];
       
            if (![Utility checkIfDataListFilePathExist:[aDataList objectForKey:@"dlID"]])
            {
            
                ASIHTTPRequest *request;
            
                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            
                [DlURL addObject:[aDataList objectForKey:@"dlDescription"]];
                
                NSString *DataListFolder = [ContentFolder stringByAppendingPathComponent:[aDataList objectForKey:@"dlTitle"]];
                
                NSFileManager *fileManager = [[NSFileManager alloc] init];
            
                if (![[aContent objectForKey:@"Paused"] isEqualToString:@"YES"])//fresh download
           
                {
            
                    if ([fileManager fileExistsAtPath:DataListFolder
                                      isDirectory:NO])
                
                    {
                    
                        [fileManager removeItemAtPath:DataListFolder error:nil];
                
                    }
                    
                    [fileManager createDirectoryAtPath:DataListFolder
                       withIntermediateDirectories:NO
                                        attributes:nil
                                             error:nil];
           
                }
                NSString* theFileName = [urlStr lastPathComponent];
                
                
              
        
                NSString *mediaPath = [DataListFolder stringByAppendingPathComponent:theFileName];//
                
                [request setDownloadDestinationPath:mediaPath];
                
                //[networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
                
                [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aDataList,aContent,nil] forKeys:[NSArray arrayWithObjects:@"datalist",@"Content" ,nil]]];
            
           
                [networkQueue addOperation:request];
        
            }
        
        }
   
    }
    
    ////////////////////////////////////////////////////////
    
    NSMutableArray *SummArr = [[NSMutableArray alloc]init];
    SummArr = [aContent objectForKey:@"summarys"];
    NSMutableArray * summarysURL  = [[NSMutableArray alloc]init];
    
    for(NSMutableDictionary *aSumm in SummArr)
    {
        NSString *DlType = [aSumm objectForKey:@"summType"];
        if ([DlType isEqualToString:@"1"] || [DlType isEqualToString:@"2"])
        {
            NSString *URLString = [aSumm objectForKey:@"summURL"];
            NSString *urlStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSURL *url = [NSURL URLWithString:urlStr];
            
            
            [QueueArray addObject:URLString];
            
            if (![Utility checkIfSummaryFilePathExist:[aSumm objectForKey:@"summID"]])
            {
                
                ASIHTTPRequest *request;
                
                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                
                [summarysURL addObject:[aSumm objectForKey:@"summURL"]];
                
                NSString *SummFolder = [ContentFolder stringByAppendingPathComponent:[aSumm objectForKey:@"summTitle"]];
                
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                
                if (![[aContent objectForKey:@"Paused"] isEqualToString:@"YES"])//fresh download
                    
                {
                    
                    if ([fileManager fileExistsAtPath:SummFolder
                                          isDirectory:NO])
                        
                    {
                        
                        [fileManager removeItemAtPath:SummFolder error:nil];
                        
                    }
                    
                    [fileManager createDirectoryAtPath:SummFolder
                           withIntermediateDirectories:NO
                                            attributes:nil
                                                 error:nil];
                    
                }
                
                NSString* theFileName = [urlStr lastPathComponent];
                NSString *mediaPath = [SummFolder stringByAppendingPathComponent:theFileName];//
                
                [request setDownloadDestinationPath:mediaPath];
                
                //[networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
                
                [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aSumm,aContent,nil] forKeys:[NSArray arrayWithObjects:@"summary",@"Content" ,nil]]];
                
                
                [networkQueue addOperation:request];
                
            }
            
        }
        
    }

        
    NSLog(@"count = %d,total size = %d  Queue array = %@",[bURLArray count]+[ParentURL count]+[ChildContentURLArray count]+[ReferenceURLArray count]+[DlURL count]+[summarysURL count],[QueueArray count],QueueArray);
    
    NSString *DownloadContent = [NSString stringWithFormat:@"%d",[bURLArray count]+[ParentURL count]+[ChildContentURLArray count]+[ReferenceURLArray count]+[DlURL count]+[summarysURL count]];
    
    [aContent setValue:DownloadContent forKey:@"DownloadContent"];
    
    [aContent setObject:[NSString stringWithFormat:@"%d",[QueueArray count]]forKey:@"TotalContent"];
    
    [networkQueue go];
    
    
}


//- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
//    NSLog(@"bytes = %lld",bytes);
//
//    
//}

// Called when a request fails, and lets the delegate know via didFailSelector
- (void)failWithError:(NSError *)theError{
    NSLog(@"**** error is **** : %@",theError.localizedDescription);
}

// Remove a file on disk, returning NO and populating the passed error pointer if it fails
+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)err
{
    return NO;
}

- (void)imageFetchrequestComplete:(ASIHTTPRequest *)request
{
    
   // AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"Image Fetch Complete");
    NSString *path = [request downloadDestinationPath];
    NSLog(@"path = %@",path);
    
    //NSLog(@"Request userinfo %@",[[request userInfo] objectForKey:@"brand"]);
    NSMutableDictionary *BDict = [[request userInfo] objectForKey:@"brand"];
//    
    [BDict setObject:path forKey:@"brandImagePath"];
//    NSLog(@"LogoPath = %@",path);
    
    NSMutableDictionary *PrntDict = [[request userInfo] objectForKey:@"parent"];
    
    [PrntDict setObject:path forKey:@"slideBgPath"];
    
    NSMutableDictionary *DLtDict = [[request userInfo] objectForKey:@"datalist"];
    
    [DLtDict setObject:path forKey:@"filePath"];
    
    NSMutableDictionary *SummDict = [[request userInfo] objectForKey:@"summary"];
    
    [SummDict setObject:path forKey:@"SummfilePath"];
    
    
    
    NSMutableDictionary *chdDict = [[request userInfo] objectForKey:@"CHILD"];
    if (chdDict != NULL)
    {
        [chdDict setObject:path forKey:@"filePath"];
        
    }
    
    NSMutableDictionary *RefDict = [[request userInfo] objectForKey:@"REFERENCE"];
    if (RefDict != NULL)
    {
        [RefDict setObject:path forKey:@"filePath"];
    }
    
    if ([request responseStatusCode] != 200)
    {
        NSLog(@"NOT FOUND");
//        [self RequestFailed:networkQueue];
    }
    else
    {
        // delegate for progress
        if ([aDelegate respondsToSelector:@selector(didFinishDownload:)])
        {
            dwnProgress++;
            [[[request userInfo]objectForKey:@"Content"]setObject:[NSString stringWithFormat:@"%d",dwnProgress ]forKey:@"downloadprogress"];
            
                       [aDelegate performSelector:@selector(didFinishDownload:) withObject: [request userInfo]];
        }
 
    }
    


}

- (void)imageFetchComplete:(ASINetworkQueue *)Queue
{
    //_isIntrpted = NO ;
    NSLog(@"Image Fetch Queue Complete");
    
    
    
    
    NSMutableDictionary *ContDict =[[Queue userInfo]objectForKey:@"Content"];
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    Brand *mBrand;
    Content *mContent;
    
    
   //mContent = [Utility getContentIfExist:[NSNumber numberWithInt:[[ContDict valueForKey:@"contentID"]integerValue]]:[NSNumber numberWithInt:[[ContDict valueForKey:@"brandID"]integerValue]]];
    
    NSMutableDictionary *BrandD = [ContDict valueForKey:@"brand"];
    
    mBrand = [Utility getBrandIfExist:[NSNumber numberWithInt:[[BrandD valueForKey:@"BrandId"]integerValue]]];
    mBrand.brandImagePath = [BrandD objectForKey:@"brandImagePath"];
    
    
     mContent = [Utility getContentIfExist:[NSNumber numberWithInt:[[ContDict valueForKey:@"contentID"]integerValue]]];
    
    if (mContent==nil)
    {
        mContent = (Content *)[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    }
    
    
    
    mContent.contentName = [ContDict valueForKey:@"contentName"];
    mContent.contentId = [NSNumber numberWithInt:[[ContDict valueForKey:@"contentID"]integerValue]];
    
    
    NSArray *parentsArr = [ContDict valueForKey:@"Parents"];
    
    for(NSDictionary *aParentDict in parentsArr)
    {
        NSString *slidePath =[NSString stringWithFormat:@"%@",[aParentDict objectForKey:@"slideBgPath"]];
        NSLog(@"slidebg Path = %@",slidePath);
        
        if ([slidePath isEqualToString:@""] )
        {
            failed = YES;
            
        }
        
        Parent *mParent = nil;
        
        mParent = [Utility getParentIfExist:[NSNumber numberWithInt:[[aParentDict objectForKey:@"Parentid"]integerValue]]];
        
        if (mParent==nil)
        {
            mParent = (Parent *)[NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
        }
        
            mParent.contentUrl = [aParentDict objectForKey:@"Parenturl"];
            mParent.parentid = [NSNumber numberWithInt:[[aParentDict objectForKey:@"Parentid"]integerValue]];
            mParent.parentName = [aParentDict objectForKey:@"parentName"];
            mParent.hasChilds = [NSNumber numberWithInt:[[aParentDict objectForKey:@"parentChldStatus"]integerValue]];
            mParent.slideBgPath = [aParentDict objectForKey:@"slideBgPath"];
            mParent.isEnabled = [NSNumber numberWithInt:1];
        
            NSArray *aChildren = [aParentDict valueForKey:@"childs"];
            
            
            for(NSDictionary *aChildDict in aChildren)
            {
                NSString *filePath = [aChildDict objectForKey:@"filePath"];
                NSString *type = [aChildDict objectForKey:@"ChildType"];
                Child *mChild = nil;
                
                if ([type isEqualToString:@"2"] || [type isEqualToString:@"3"])
                {
                    NSLog(@"Child filepath : %@",filePath);
                    
                    if ([filePath isEqualToString:@""])
                    {
                        failed = YES;
                    }
                    
                    mChild = [Utility getChildIfExist:[NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]]];
                    
                    if (mChild == nil)
                    {
                        mChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    }
                    
                        mChild.contentUrl = [aChildDict objectForKey:@"ChildURL"];
                        mChild.childid = [NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]];
                        mChild.childName = [aChildDict objectForKey:@"ChildName"];
                        mChild.frame = [aChildDict objectForKey:@"ChildFrame"];
                        mChild.text=[aChildDict objectForKey:@"text"];
                        mChild.textColour = [aChildDict objectForKey:@"textColor"];
                        mChild.contentType = [NSNumber numberWithInt:[[aChildDict objectForKey:@"ChildType"]integerValue]];
                        mChild.textSize = [NSNumber numberWithInt:[[aChildDict objectForKey:@"textSize"]integerValue]];
                        mChild.filePath = [aChildDict objectForKey:@"filePath"];
                        
                        mChild.parent = mParent;
                    //}
                    //else
                    //{
                        //_isIntrpted = YES;
                    //}
                }
                
               else if ([type isEqualToString:@"4"] )
                {
                    NSLog(@"Child filepath : %@",filePath);
                    
                    if ([filePath isEqualToString:@""])
                    {
                        failed = YES;
                    }
                    
                    mChild = [Utility getChildIfExist:[NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]]];
                    
                    if (mChild == nil)
                    {
                        mChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    }
                    
                    mChild.contentUrl = [aChildDict objectForKey:@"ChildURL"];
                    mChild.childid = [NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]];
                    mChild.childName = [aChildDict objectForKey:@"ChildName"];
                    mChild.frame = [aChildDict objectForKey:@"ChildFrame"];
                    mChild.text=[aChildDict objectForKey:@"text"];
                    mChild.textColour = [aChildDict objectForKey:@"textColor"];
                    mChild.contentType = [NSNumber numberWithInt:[[aChildDict objectForKey:@"ChildType"]integerValue]];
                    mChild.textSize = [NSNumber numberWithInt:[[aChildDict objectForKey:@"textSize"]integerValue]];
                    mChild.filePath = [aChildDict objectForKey:@"filePath"];
                    
                    mChild.parent = mParent;
                    
                    
                    
                     Reference *mref = nil;
                    
                    
                    
                    
                     NSArray *aRef = [aChildDict valueForKey:@"references"];
                    
                    for(NSDictionary *aRefDict in aRef)
                    {
                        mref = [Utility getRefIfExist:[NSNumber numberWithInt:[[aChildDict objectForKey:@"Referenceid"]integerValue]]];
                        
                        
                        if (mref == nil)
                        {
                            
                            NSFetchRequest *aFetchReq = [[NSFetchRequest alloc] init];
                            NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"referenceId = %@",[NSNumber numberWithInt:[[aRefDict objectForKey:@"Referenceid"]integerValue]]];
                            NSEntityDescription *aEntityDesc = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
                            [aFetchReq setPredicate:aPredicate];
                            [aFetchReq setEntity:aEntityDesc];
                            NSMutableArray *aReferences = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchReq error:nil];
                            mref = [aReferences objectAtIndex:0];
                        }
                        
                        mref.referenceId = [NSNumber numberWithInt:[[aRefDict objectForKey:@"Referenceid"]integerValue]];
                        mref.referenceName = [aRefDict objectForKey:@"ReferenceName"];
                        mref.contentUrl = [aRefDict objectForKey:@"ReferenceUrl"];
                        mref.filepath = [aRefDict objectForKey:@"filePath"];
                        mref.child = mChild;
                    }
                    //[aAppDelegate.managedObjectContext save:nil];
                
                }
                else
                {
                    
                    mChild = [Utility getChildIfExist:[NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]]];
                    
                    if (mChild == nil)
                    {
                         mChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    }
                    
                   
                    mChild.contentUrl = [aChildDict objectForKey:@"ChildURL"];
                    mChild.childid = [NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]];
                    mChild.childName = [aChildDict objectForKey:@"ChildName"];
                    mChild.frame = [aChildDict objectForKey:@"ChildFrame"];
                    mChild.text=[aChildDict objectForKey:@"text"];
                    mChild.textColour = [aChildDict objectForKey:@"textColor"];
                    mChild.contentType = [NSNumber numberWithInt:[[aChildDict objectForKey:@"ChildType"]integerValue]];
                    mChild.textSize = [NSNumber numberWithInt:[[aChildDict objectForKey:@"textSize"]integerValue]];
                    mChild.filePath = @"";
                    mChild.parent = mParent;
                }
             
            }
            //
            mParent.content = mContent;
  
    }
    
    
    
    NSArray *DataListArr = [ContDict valueForKey:@"DataLists"];
    
    for(NSDictionary *aDataListDict in DataListArr)
    {
        NSString *DlType = [aDataListDict objectForKey:@"dlType"];
        
        if ([DlType isEqualToString:@"2"] || [DlType isEqualToString:@"3"])
        {
        
            NSString *slidePath =[NSString stringWithFormat:@"%@",[aDataListDict objectForKey:@"filePath"]];
       
            NSLog(@"slidebg Path = %@",slidePath);
        
        
            if ([slidePath isEqualToString:@""] )
        
            {
           
                failed = YES;
                
            }
        
        
            DataList *mDatalist = nil;
        
        
            mDatalist = [Utility getDataListIfExist:[NSNumber numberWithInt:[[aDataListDict objectForKey:@"dlID"]integerValue]]];
        
        
            if (mDatalist==nil)
        
            {
           
                mDatalist = (DataList *)[NSEntityDescription insertNewObjectForEntityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
        
            }
        
       
            mDatalist.dlDescription = [aDataListDict objectForKey:@"dlDescription"];
        
            mDatalist.dlid = [NSNumber numberWithInt:[[aDataListDict objectForKey:@"dlID"]integerValue]];
       
            mDatalist.dlTopic = [aDataListDict objectForKey:@"dlTitle"];
        
            mDatalist.dlType = [aDataListDict objectForKey:@"dlType"];
       
            mDatalist.dlFilepath = [aDataListDict objectForKey:@"filePath"];
     
        }
    
    }
    
//////////////////////Summmary///////////////////////////////////////////////////////////////////////////
    
    
    NSArray *SummaryArr = [ContDict valueForKey:@"summarys"];
    
    for(NSDictionary *aSummDict in SummaryArr)
    {
        NSString *DlType = [aSummDict objectForKey:@"summType"];
        
        if ([DlType isEqualToString:@"1"] || [DlType isEqualToString:@"2"])
        {
            
            NSString *slidePath =[NSString stringWithFormat:@"%@",[aSummDict objectForKey:@"SummfilePath"]];
            
            NSLog(@"slidebg Path = %@",slidePath);
            
            
            if ([slidePath isEqualToString:@""] )
                
            {
                
                failed = YES;
                
            }
            
            
            Summary *mSumm = nil;
            
            
            mSumm = [Utility getSummaryIfExist:[NSNumber numberWithInt:[[aSummDict objectForKey:@"summID"]integerValue]]];
            
            
            if (mSumm==nil)
                
            {
                
                mSumm = (Summary *)[NSEntityDescription insertNewObjectForEntityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
                
            }
            
            
            mSumm.summURL = [aSummDict objectForKey:@"summURL"];
            
            mSumm.summID = [NSNumber numberWithInt:[[aSummDict objectForKey:@"summID"]integerValue]];
            
            mSumm.summTitle = [aSummDict objectForKey:@"summTitle"];
            
            mSumm.summType = [aSummDict objectForKey:@"summType"];
            
            mSumm.summfilePath = [aSummDict objectForKey:@"SummfilePath"];
            
        }
        
    }
    
    
    if (failed == NO)
    {
        
        NSDateFormatter *Formater = [[NSDateFormatter alloc]init];
        Formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
       
        NSString *date = [Formater stringFromDate:[NSDate date]];
        NSLog(@"date = %@",date);

        [ContDict setObject:date forKey:@"lastDownloadDate"];
        [ContDict setObject: @"1" forKey:@"DownloadStatus"];
        
 
        
        mContent.downStatus = [NSNumber numberWithInt:[[ContDict objectForKey:@"DownloadStatus"]integerValue]];
        mContent.lastdownloaddate =[ContDict objectForKey:@"lastDownloadDate"];
        
        
        if ([[ContDict objectForKey:@"updateAvail"] isEqualToString:@"YES"])//fresh download
        {
            mContent.isUpdateAvail = [NSNumber numberWithInt:0];
            
        }
       
        NSError *error = nil;
        if (![aAppDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    else // download interrupted
    {
        if ([[ContDict objectForKey:@"Paused"] isEqualToString:@"NO"])
        {
            if ([ErrorString isEqualToString:@"Paused"]) {
                NSLog(@"Download Paused");
                ErrorString = nil;
            }
            else  if (![ErrorString isEqualToString:@"Paused"])
            {
                if ([ErrorString length] == 0)
                {
                    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to Download " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [alertView show];
                    
                }
                else{
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Download failed" message:ErrorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alertView show];
                
                ErrorString = nil;
                }
            }
          
            if ([aDelegate respondsToSelector:@selector(didFailDownload:)])
            {
                //        dwnProgress++;
                //        [[[Queue userInfo]objectForKey:@"Content"]setObject:[NSString stringWithFormat:@"%d",dwnProgress ]forKey:@"downloadprogress"];
                
                [aDelegate performSelector:@selector(didFailDownload:) withObject: [Queue userInfo]];
            }

            
        }
 
        mContent.downStatus = [NSNumber numberWithInt:2];
        
        NSError *error = nil;
        
        if (![aAppDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }
    

    NSLog(@"failded %hhd",failed);

    
//    if ([aDelegate respondsToSelector:@selector(didFinishAllDownload)])
//    {
//        [aDelegate didFinishAllDownload];
//        
//    }
    if ([aDelegate respondsToSelector:@selector(didFinishAllDownload:)])
    {
       [aDelegate performSelector:@selector(didFinishAllDownload:) withObject: [Queue userInfo]];
        
    }
	
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
   //
	if (!failed)
    {
        if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType)
        {
            NSLog(@"Error = %@",[request error]);
//			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to download image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//			[alertView show];
		}
		failed = YES;
	}
}

-(void)PausedContentObject
{
    [networkQueue cancelAllOperations];
    
    
}

-(void)RequestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Request Paused");
  
    NSLog(@"Error = %@ with code = %d",[request error],[[request error]code]);
    int i = [[request error]code];
 if ([ErrorString length] == 0) {
    switch (i) {
        case 1: //No Connection
            ErrorString = @"No Internet Connection";
            
            break;
        case 2: //Lost Connection
            ErrorString = @"Lost Connection to Server";
            
            break;
        case 3:
             ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";
            
            break;
        case 4:
            ErrorString = @"Paused";
            
            break;
        case 5:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";

            
            break;
        case 6:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";

            
            break;
        case 7:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";
            
            break;
        case 8:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";

            
            break;
        case 9:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";

            
            break;
        case 10:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";
            break;
        case 11:
            ErrorString = @"The content which you are trying to download is either corrupt or not available on server,Please Delete the Content and try again.";
            break;
            
        default:
            
            break;
    }
    }
    failed = YES;
   
    
    
//    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to Download " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//    [alertView show];
}

- (void)setDelegate:(id)val
{
    aDelegate = val;
}

- (id)delegate
{
    return aDelegate;
}

@end
