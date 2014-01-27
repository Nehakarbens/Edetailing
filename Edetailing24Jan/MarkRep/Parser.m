//
//  Parser.m
//  MyDay
//
//  Created by Karbens on 10/18/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "Parser.h"
#import "Content.h"
#import "AppDelegate.h"
#import "Utility.h"

@implementation Parser

@synthesize item,ContentDict,ParentDict,ChildDict,aContent,aChild,aParent,aBrand,DataListDict,SummaryDict,aDatalist,aSummary,aReference,ReferenceDict,aDelegate;

- (id)initWithUrl:(NSString *)aUrl {


    NSLog(@"url = %@",aUrl);
    if ((self = [self init]))
		[self requestWithUrls:aUrl];
	
    
	return self;
}

- (void)requestWithUrls:(NSString *)aUrl {
   
    BrandArray = [[NSMutableArray alloc] init];
    ContentArray = [[NSMutableArray alloc] init];
    ParentsArray = [[NSMutableArray alloc] init];
    childArray = [[NSMutableArray alloc] init];
    ReferenceArr = [[NSMutableArray alloc] init];
    
    requestedData = [[NSMutableData alloc]init];
    AppDelegate* appDelegate  = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
                             ]]];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //[connection start];
    
//    XmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    NSLog(@"XMl = %@",XmlParser);
//    NSLog(@"aURL = %@",aUrl);
//    [XmlParser setDelegate:self];
//    [XmlParser parse];
    
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    requestedData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[requestedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    XmlParser = [[NSXMLParser alloc]initWithData:requestedData];
    [XmlParser setDelegate:self];
    [XmlParser parse];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Connection Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    if ([aDelegate respondsToSelector:@selector(didFail)])
    {
        [aDelegate performSelector:@selector(didFail)];
    }
    
    
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
        errorParsing=YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];
    
    
    if ([elementName isEqualToString:@"brand"])
    {
        BrandDict = [[NSMutableDictionary alloc] init];
        _isBrand = YES;
        _isContent = NO;
        _isParent = NO;
        _isChild = NO;
        _isReference = NO;
        _isDataList = NO;
        _isSummary = NO;

            return;
    }
    if ([elementName isEqualToString:@"brands"])
    {
        BrandArray = [[NSMutableArray alloc]init];
               return;
    }
    else if ([elementName isEqualToString:@"content"]) {
        //item = [[NSMutableDictionary alloc] init];
        _isContent = YES;
        _isParent = NO;
        _isBrand = NO;
        _isReference = NO;
        _isDataList = NO;
        _isSummary = NO;

        ContentDict = [[NSMutableDictionary alloc] init];
        

        return;
//        
    }
    else if([elementName isEqualToString:@"datalist"]){
        _isContent = NO;
        _isParent = NO;
        _isBrand = NO;
        _isReference = NO;
        _isDataList = YES;
        _isSummary = NO;

        DataListDict = [[NSMutableDictionary alloc]init];
        return;
    }
    
    else if ([elementName isEqualToString:@"datalists"]){
        DataListArr = [[NSMutableArray alloc]init];
        return;
        
    }
    else if([elementName isEqualToString:@"summary"]){
        _isContent = NO;
        _isParent = NO;
        _isBrand = NO;
        _isReference = NO;
        _isDataList = NO;
        _isSummary = YES;
        SummaryDict = [[NSMutableDictionary alloc]init];
        return;
    }
    
    else if ([elementName isEqualToString:@"summarys"]){
        SummaryArray = [[NSMutableArray alloc]init];
        return;
        
    }

    
    else if ([elementName isEqualToString:@"contents"]) {
        ContentArray = [[NSMutableArray alloc]init];
        return;
        //
    }
    else if ([elementName isEqualToString:@"parents"]){
        ParentsArray = [[NSMutableArray alloc]init];
        
        return;
    }
    else if ([elementName isEqualToString:@"parent"]){
        _isContent = NO;
        _isParent = YES;
        _isChild = NO;
        _isBrand = NO;
        _isReference = NO;
        _isDataList = NO;
        _isSummary = NO;


        ParentDict = [[NSMutableDictionary alloc]init];
        
      
        
        return;
    }
    else if ([elementName isEqualToString:@"childs"]){
        childArray = [[NSMutableArray alloc]init];
        return;
    }
    else if ([elementName isEqualToString:@"child"]){
        _isContent = NO;
        _isParent = NO;
        _isChild = YES;
        _isBrand = NO;
        _isReference = NO;
        _isDataList = NO;
        _isSummary = NO;


        ChildDict = [[NSMutableDictionary alloc]init];

        return;
   }
    else if([elementName isEqualToString:@"references"])
    {
        ReferenceArr = [[NSMutableArray alloc]init];
        return;
    }
    else if([elementName isEqualToString:@"reference"])
    {
        _isContent = NO;
        _isParent = NO;
        _isChild = NO;
        _isBrand = NO;
        _isReference = YES;
        _isDataList = NO;
        _isSummary = NO;


        ReferenceDict = [[NSMutableDictionary alloc]init];
        
        return;

    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
   [ElementValue appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (_isBrand == YES)
    {
        if ([elementName isEqualToString:@"id"])
        {
            [BrandDict setObject:ElementValue forKey:@"BrandId"];
        }
        if ([elementName isEqualToString:@"name"])
        {
            [BrandDict setObject:ElementValue forKey:@"name"];
        }
        if ([elementName isEqualToString:@"logo"])
        {
            [BrandDict setObject:ElementValue forKey:@"brandImageURl"];
        }
        else if([elementName isEqualToString:@"brand"])
        {
            [BrandArray addObject:BrandDict];
            BrandDict = nil;
        }

    }
    if (_isContent == YES) {
       
   
    if ([elementName isEqualToString:@"id"]) {
        [ContentDict setObject:ElementValue forKey:@"contentID"];
        
       
    }
    if ([elementName isEqualToString:@"name"]) {
        [ContentDict setObject:ElementValue forKey:@"contentName"];
       
        
    }
        
    if ([elementName isEqualToString:@"del_status"]) {
        [ContentDict setObject:ElementValue forKey:@"del_status"];
        
    }
        
    if ([elementName isEqualToString:@"content"]) {
        [ContentArray addObject:ContentDict];
        
        ContentDict = nil;
        
    }
    else if ([elementName isEqualToString:@"contents"])
    {
        [BrandDict setObject:ContentArray forKey:@"contents"];
        ContentArray = nil;
        
        _isBrand = YES;
        _isContent = NO;
        _isParent = NO;
        _isChild = NO;
        _isReference = NO;
        _isDataList = NO;
        _isSummary = NO;

    }
        
    
    }

    if (_isDataList == YES) {
        
        
        if ([elementName isEqualToString:@"title"]) {
            [DataListDict setObject:ElementValue forKey:@"dlTitle"];
            
            
        }
        if ([elementName isEqualToString:@"type"]) {
            [DataListDict setObject:ElementValue forKey:@"dlType"];
            
            
        }
        
        if ([elementName isEqualToString:@"description"]) {
            [DataListDict setObject:ElementValue forKey:@"dlDescription"];
            
        }
        if ([elementName isEqualToString:@"id"]) {
            [DataListDict setObject:ElementValue forKey:@"dlID"];
            
        }
        
        if ([elementName isEqualToString:@"datalist"]) {
            [DataListArr addObject:DataListDict];
            
            DataListDict = nil;
            
        }
        else if ([elementName isEqualToString:@"datalists"])
        {
            [ContentDict setObject:DataListArr forKey:@"DataLists"];
            DataListArr = nil;
            
            _isBrand = NO;
            _isContent = YES;
            _isParent = NO;
            _isChild = NO;
            _isReference = NO;
            _isDataList = NO;
            _isSummary = NO;

        }
        
        
    }
    
    
    if (_isSummary == YES) {
        
        
        if ([elementName isEqualToString:@"sumryTitle"]) {
            [SummaryDict setObject:ElementValue forKey:@"summTitle"];
            
            
        }
        if ([elementName isEqualToString:@"sumryType"]) {
            [SummaryDict setObject:ElementValue forKey:@"summType"];
            
            
        }
        
        if ([elementName isEqualToString:@"sumryPath"]) {
            [SummaryDict setObject:ElementValue forKey:@"summURL"];
            
        }
        if ([elementName isEqualToString:@"sumryId"]) {
            [SummaryDict setObject:ElementValue forKey:@"summID"];
            
        }
        
        if ([elementName isEqualToString:@"summary"]) {
            [SummaryArray addObject:SummaryDict];
            
            SummaryDict = nil;
            
        }
        else if ([elementName isEqualToString:@"summarys"])
        {
            [ContentDict setObject:SummaryArray forKey:@"summarys"];
            SummaryArray = nil;
            
            _isBrand = NO;
            _isContent = YES;
            _isParent = NO;
            _isChild = NO;
            _isReference = NO;
            _isDataList = NO;
            _isSummary = NO;
            
        }
        
        
    }
    
    if (_isParent == YES ) {
        
        if ([elementName isEqualToString:@"id"]) {
            [ParentDict setObject:ElementValue forKey:@"Parentid"];
        }
        if ([elementName isEqualToString:@"url"]) {
            [ParentDict setObject:ElementValue forKey:@"Parenturl"];
        }
        if ([elementName isEqualToString:@"name"]) {
            [ParentDict setObject:ElementValue forKey:@"parentName"];
         }
            
        if ([elementName isEqualToString:@"chlsStatus"]) {
            [ParentDict setObject:ElementValue forKey:@"parentChldStatus"];
        }
        else if ([elementName isEqualToString:@"parent"])
        {
            [ParentDict setObject:@"" forKey:@"slideBgPath"];
            [ParentsArray addObject:ParentDict];
            ParentDict=nil;
        }

        else if ([elementName isEqualToString:@"parents"]) {
            
            
            [ContentDict setObject:ParentsArray forKey:@"Parents"];
            ParentsArray = nil;
      
            
            _isContent = YES;
            _isParent = NO;
            _isChild = NO;
            _isBrand = NO;
            _isReference = NO;
            _isDataList = NO;
            _isSummary = NO;

        }
        
    }
        if (_isChild == YES)
        {
            NSString *hasChild = [ParentDict objectForKey:@"parentChldStatus"];
            
            if ([hasChild isEqualToString:@"1"])
            {

                if ([elementName isEqualToString:@"id"]) {
                               [ChildDict setObject:ElementValue forKey:@"Childid"];
                }
                if ([elementName isEqualToString:@"type"]) {
           
                    [ChildDict setObject:ElementValue forKey:@"ChildType"];
                    
                }
                if ([elementName isEqualToString:@"textStyle"]) {
                    NSString *type = [ChildDict objectForKey:@"ChildType"];
                
                    if ([type isEqualToString:@"1"]) {

                    NSArray *TextStylearry = [ElementValue componentsSeparatedByString:@"|"];
                        [ChildDict setObject:[TextStylearry objectAtIndex:0] forKey:@"textColor"];
                        [ChildDict setObject:[TextStylearry objectAtIndex:1] forKey:@"textSize"];
                    }
                }
                if ([elementName isEqualToString:@"text"]) {
                    [ChildDict setObject:ElementValue forKey:@"text"];
                }

                if ([elementName isEqualToString:@"url"]) {
                    [ChildDict setObject:ElementValue forKey:@"ChildURL"];
                }
                
                if ([elementName isEqualToString:@"name"]) {
                    [ChildDict setObject:ElementValue forKey:@"ChildName"];
                }
                if ([elementName isEqualToString:@"frame"]) {
                    NSArray *framearry = [ElementValue componentsSeparatedByString:@","];
                    NSString *frameString = [NSString stringWithFormat:@"{{%@,%@},{%@,%@}}",[framearry objectAtIndex:2],[framearry objectAtIndex:3],[framearry objectAtIndex:0],[framearry objectAtIndex:1]];
                    [ChildDict setObject:frameString forKey:@"ChildFrame"];
                }
                
                
                else if ([elementName isEqualToString:@"child"])
                {
                    [ChildDict setObject:@"" forKey:@"filePath"];
                    [childArray addObject:ChildDict];

                    ChildDict = nil;
              
                }
                else if([elementName isEqualToString:@"childs"])
                {
                    [ParentDict setObject:childArray forKey:@"childs"];
                    childArray = nil;
                    
                    _isContent = NO;
                    _isParent = YES;
                    _isChild = NO;
                    _isBrand = NO;
                    _isReference = NO;
                    _isDataList = NO;
                    _isSummary = NO;

                }
               
            }
            
            
        }
    
    
    if(_isReference == YES)
    {
        if ([elementName isEqualToString:@"id"]) {
            [ReferenceDict setObject:ElementValue forKey:@"Referenceid"];
        }
        if ([elementName isEqualToString:@"name"]) {
            [ReferenceDict setObject:ElementValue forKey:@"ReferenceName"];
        }
        if ([elementName isEqualToString:@"refurl"]) {
            [ReferenceDict setObject:ElementValue forKey:@"ReferenceUrl"];
        }
        else if ([elementName isEqualToString:@"reference"])
        {
            [ReferenceDict setObject:@"" forKey:@"filePath"];
            [ReferenceArr addObject:ReferenceDict];
            
            ReferenceDict = nil;
            
        }
        else if([elementName isEqualToString:@"references"])
        {
            [ChildDict setObject:ReferenceArr forKey:@"references"];
            ReferenceArr = nil;
            
            _isContent = NO;
            _isParent = NO;
            _isChild = YES;
            _isBrand = NO;
            _isReference = NO;
            _isDataList = NO;
            _isSummary = NO;

        }
        
    }
    
    
  }

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
   
    
    for (int a=0; a<BrandArray.count; a++)
    {
        
        BrandDict = [BrandArray objectAtIndex:a]; // Brand Dict
        
        //NSLog(@"brandDict= %@",BrandDict); // Brand Dict
        
        for (int b=0; b<[BrandDict count]; b++)
        {
            ContentArray = [BrandDict objectForKey:@"contents"]; //Content Array
            
            for (int c=0; c<[ContentArray count]; c++)
            {
                ContentDict = [ContentArray objectAtIndex:c]; //Content Dict
                
                //NSLog(@"%@",ContentDict);
                
                for (int d=0; d<[ContentDict count]; d++)
                {
                    ParentsArray = [ContentDict objectForKey:@"parents"]; // Parent Array
                    
                    
                    for (int e=0; e<[ParentsArray count]; e++)
                    {
                        ParentDict = [ParentsArray objectAtIndex:e]; // Parent Dict
                        
                        //NSLog(@"%@",ParentDict);
                        
                        for (int f =0 ; f<[ParentDict count]; f++)
                        {
                            childArray = [ParentDict objectForKey:@"childs"]; // Child Array
                            
                            for (int g=0; g<[childArray count]; g++)
                            {
                                ChildDict = [childArray objectAtIndex:g]; // Child Dict
                                
                                for(int h=0; h<[ChildDict count]; h++)
                                {
                                    ReferenceArr = [ChildDict objectForKey:@"references"]; // Reference Array
                                    
                                    for(int j=0;j<[ReferenceArr count]; j++)
                                    {
                                        ReferenceDict = [ReferenceArr objectAtIndex:j]; // Reference Dict
                                        NSLog(@"REFURLS : %@",[ReferenceDict objectForKey:@"refurl"]);
                                    }
                                }
                                
                                //NSLog(@"URLS%@",[ChildDict objectForKey:@"ChildURL"]);
                            }
                        }
                    }
                    
                    
                    DataListArr = [ContentDict objectForKey:@"DataLists"]; // dataList Array
                    for (int h = 0;h<[DataListArr count];h++) {
                        DataListDict = [DataListArr objectAtIndex:h];
                        //NSLog(@"DataList Dict = %@",DataListDict);
                    }
                    
                    SummaryArray = [ContentDict objectForKey:@"summarys"]; // dataList Array
                    for (int h = 0;h<[SummaryArray count];h++) {
                        SummaryDict = [SummaryArray objectAtIndex:h];
                        NSLog(@"summ Dict = %@",SummaryDict);

                    }
                    
                    
                }
            }
        }
    }
    
    
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    aAppDelegate.brandArr = BrandArray; // dictionary format
    
    if ([BrandArray count]== 0) // if no data from server
    {
        aAppDelegate.dbBrandArr = [Utility getAllBrands]; // Array of Managed Objects
    }
    else
    {
       aAppDelegate.dbBrandArr = [self getParsedContents:BrandArray]; // Array of Managed Objects
    }
    
    if ([aDelegate respondsToSelector:@selector(loadGridView)])
    {
             [aDelegate performSelector:@selector(loadGridView)];
    }


}


- (NSMutableArray *)getParsedContents:(NSMutableArray *) brandArray {
    
    //NSArray *aContents = [NSArray arrayWithContentsOfFile:aPath];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableArray *dbBrandArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempBrandArr = [[NSMutableArray alloc] init];
    
//     NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *brandDict in brandArray)
    {
        Brand *mBrand;
      
        mBrand = [Utility getBrandIfExist:[NSNumber numberWithInteger:[[brandDict objectForKey:@"BrandId"]integerValue]]];//[self checkContentExist:cid];
        
        if (mBrand == nil)
        {
            mBrand = (Brand *)[NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
            
            mBrand.brandId = [NSNumber numberWithInteger:[[brandDict objectForKey:@"BrandId"]integerValue]];
            mBrand.brandName = [brandDict objectForKey:@"name"];
            mBrand.brandImageURl = [brandDict objectForKey:@"brandImageURl"];
            NSLog(@"Brand Name :%@",mBrand.brandName);

       
        
        NSArray *contentArr = [brandDict objectForKey:@"contents"];
        
          NSMutableArray *contentArray = [[NSMutableArray alloc] init];
            NSLog(@"Contentarrrray = %@",contentArray);
            
        for (NSDictionary *aDict in contentArr)
        {
            
            NSNumber *cid = [NSNumber numberWithInteger:[[aDict valueForKey:@"contentID"]integerValue]];
            
            Content *mContent = nil;
            
            mContent = [Utility getContentIfExist:cid];//[self checkContentExist:cid];
          //  mContent.mbrand = aBrand;
            //mContent = [Utility getContentIfExist:cid :mBrand.brandId];
            
        
            if (mContent == nil)
            {
                // load from response
                
                mContent = (Content *)[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
                
                mContent.contentName = [aDict valueForKey:@"contentName"];
                mContent.contentId = [NSNumber numberWithInt:[[aDict valueForKey:@"contentID"] integerValue]];
                mContent.downStatus = [NSNumber numberWithInt:0];
                mContent.isUpdateAvail = [NSNumber numberWithInt:0];
                
                //mContent.lastdownloaddate = date;
                
                NSLog(@"Content Name = %@",mContent.contentName);
                
                NSArray *parentsArr = [aDict valueForKey:@"Parents"];
                
                for(NSDictionary *aParentDict in parentsArr)
                {
                    
                    Parent *mParent = (Parent *)[NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    
                    
                    mParent.contentUrl = [aParentDict objectForKey:@"Parenturl"];
                    mParent.parentid = [NSNumber numberWithInt:[[aParentDict objectForKey:@"Parentid"]integerValue]];
                    mParent.parentName = [aParentDict objectForKey:@"parentName"];
                    mParent.hasChilds = [NSNumber numberWithInt:[[aParentDict objectForKey:@"parentChldStatus"]integerValue]];
                    mParent.isEnabled = [NSNumber numberWithInt:1];
                    
                    
                    NSArray *aChildren = [aParentDict valueForKey:@"childs"];
                    
                    
                    for(NSDictionary *aChildDict in aChildren)
                    {
                        Child *mChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                        mChild.contentUrl = [aChildDict objectForKey:@"ChildURL"];
                        mChild.childid = [NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]];
                        mChild.childName = [aChildDict objectForKey:@"ChildName"];
                        mChild.frame = [aChildDict objectForKey:@"ChildFrame"];
                        mChild.text=[aChildDict objectForKey:@"text"];
                        mChild.textColour = [aChildDict objectForKey:@"textColor"];
                        mChild.contentType = [NSNumber numberWithInt:[[aChildDict objectForKey:@"ChildType"]integerValue]];
                        mChild.textSize = [NSNumber numberWithInt:[[aChildDict objectForKey:@"textSize"]integerValue]];
                        
                        NSArray *aReference = [aChildDict valueForKey:@"references"];
                        
                        for(NSDictionary *aReferenceDict in aReference)
                        {
                            Reference *mReference = (Reference*)[NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
                            
                            
                            mReference.referenceName = [aReferenceDict objectForKey:@"ReferenceName"];
                            mReference.referenceId = [NSNumber numberWithInt:[[aReferenceDict objectForKey:@"Referenceid"] integerValue]];
                            
                            mReference.contentUrl = [aReferenceDict objectForKey:@"ReferenceUrl"];
                            
                            mReference.filepath = [aReferenceDict objectForKey:@"filePath"];
                            
                            mReference.child = mChild;
                        }
                        
                        mChild.parent = mParent;
                    }
                    mParent.content = mContent;
                }
                
                ////datalist
                
                
                 NSArray *datalistArr = [aDict valueForKey:@"DataLists"];
                
                for(NSDictionary *adatalist in datalistArr)
                {
                    
                    DataList *mDataList = (DataList *)[NSEntityDescription insertNewObjectForEntityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    
                    
                    mDataList.dlType = [adatalist objectForKey:@"dlType"];
                    mDataList.dlid = [NSNumber numberWithInt:[[adatalist objectForKey:@"dlID"]integerValue]];
                    mDataList.dlTopic = [adatalist objectForKey:@"dlTitle"];
                    mDataList.dlDescription = [adatalist objectForKey:@"dlDescription"];
                    
                    mDataList.content = mContent;
                }
                
                NSArray *SummArr = [aDict valueForKey:@"summarys"];
                
                for(NSDictionary *aSumm in SummArr)
                {
                    
                    Summary *mSummary = (Summary *)[NSEntityDescription insertNewObjectForEntityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    
                    
                    mSummary.summType = [aSumm objectForKey:@"summType"];
                    mSummary.summID = [NSNumber numberWithInt:[[aSumm objectForKey:@"summID"]integerValue]];
                    mSummary.summTitle = [aSumm objectForKey:@"summTitle"];
                    mSummary.summURL = [aSumm objectForKey:@"summURL"];
                    
                    mSummary.content = mContent;
                }

                
                mContent.mbrand = mBrand;
                //[tempBrandArr addObject:mBrand];
            }
            else // load from coredata
            {
                
                if ([mContent.downStatus isEqualToNumber:[NSNumber numberWithInt:1]])
                {
                    mContent.isUpdateAvail = [NSNumber numberWithInt:1];
                    
                    //[[[[aAppDelegate.brandArr objectAtIndex:0]objectForKey:@"contents"] objectAtIndex:[contentArr indexOfObject:aDict]] setObject:@"YES" forKey:@"updateAvail"];
                }
                else if ([mContent.downStatus isEqualToNumber:[NSNumber numberWithInt:2]])
                {
                    
                    //[[[[aAppDelegate.brandArr objectAtIndex:0]objectForKey:@"contents"] objectAtIndex:[contentArr indexOfObject:aDict]] setObject:@"YES" forKey:@"Paused"];
                    
                    //[[[[aAppDelegate.brandArr objectAtIndex:0]objectForKey:@"contents"] objectAtIndex:[contentArr indexOfObject:aDict]] setObject:@"NO" forKey:@"updateAvail"];
                    
                    
                }
                
            
                
            }
            
            //mContent.brand = [NSSet setWithArray:tempBrandArr];
            
            for (Brand *aBrand in dbBrandArray)
            {
                
                for (int i=0;i<[[aBrand.contents allObjects] count];i++)
                {
                    if ([[aBrand.contents allObjects] containsObject:mContent])
                    {
                        [tempBrandArr addObject:aBrand];
                    }
                }
                
                
                
            }
            
           [tempBrandArr addObject:mBrand];
            
            
            mContent.brand = [NSSet setWithArray:tempBrandArr];
            [tempBrandArr removeAllObjects];
            
            
            
            [contentArray addObject:mContent];
     
            mBrand.contents = [NSSet setWithArray:contentArray];
            
            
            
        }
            
            
            
        }
        else
        {
            
            NSArray *contentArr = [brandDict objectForKey:@"contents"];
            NSMutableArray *contentArray = [[NSMutableArray alloc] init];
            
            
            for (Content *aCont in [mBrand.contents allObjects]) {
                [contentArray addObject:aCont];
            }
            
            
            for (NSDictionary *aDict in contentArr)
            {
                
                NSNumber *cid = [NSNumber numberWithInteger:[[aDict valueForKey:@"contentID"]integerValue]];
                
                Content *mContent = nil;
                
                mContent = [Utility getContentIfExist:cid];
                
                if (mContent!=nil)
                {
                    
                    
                    if ([mContent.downStatus isEqualToNumber:[NSNumber numberWithInt:1]])
                    {
                        mContent.isUpdateAvail = [NSNumber numberWithInt:1];
                        
                        [[[[aAppDelegate.brandArr objectAtIndex:[brandArray indexOfObject:brandDict]] objectForKey:@"contents"] objectAtIndex:[contentArr indexOfObject:aDict]] setObject:@"YES" forKey:@"updateAvail"];
                        
                    }
                    else if ([mContent.downStatus isEqualToNumber:[NSNumber numberWithInt:2]])
                    {
                        
                        [[[[aAppDelegate.brandArr objectAtIndex:[brandArray indexOfObject:brandDict]]objectForKey:@"contents"] objectAtIndex:[contentArr indexOfObject:aDict]] setObject:@"YES" forKey:@"Paused"];
                        
                        [[[[aAppDelegate.brandArr objectAtIndex:[brandArray indexOfObject:brandDict]]objectForKey:@"contents"] objectAtIndex:[contentArr indexOfObject:aDict]] setObject:@"NO" forKey:@"updateAvail"];
                    }
                }
                else
                {
                    
                        // load from response
                        
                        mContent = (Content *)[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
                        
                        mContent.contentName = [aDict valueForKey:@"contentName"];
                        mContent.contentId = [NSNumber numberWithInt:[[aDict valueForKey:@"contentID"] integerValue]];
                        mContent.downStatus = [NSNumber numberWithInt:0];
                        mContent.isUpdateAvail = [NSNumber numberWithInt:0];
                        
                        //mContent.lastdownloaddate = date;
                        
                        NSLog(@"Content Name = %@",mContent.contentName);
                        
                        NSArray *parentsArr = [aDict valueForKey:@"Parents"];
                        
                        for(NSDictionary *aParentDict in parentsArr)
                        {
                            
                            Parent *mParent = (Parent *)[NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
                            
                            
                            mParent.contentUrl = [aParentDict objectForKey:@"Parenturl"];
                            mParent.parentid = [NSNumber numberWithInt:[[aParentDict objectForKey:@"Parentid"]integerValue]];
                            mParent.parentName = [aParentDict objectForKey:@"parentName"];
                            mParent.hasChilds = [NSNumber numberWithInt:[[aParentDict objectForKey:@"parentChldStatus"]integerValue]];
                            mParent.isEnabled = [NSNumber numberWithInt:1];
                            
                            NSArray *aChildren = [aParentDict valueForKey:@"childs"];
                            
                            
                            for(NSDictionary *aChildDict in aChildren)
                            {
                                Child *mChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                                mChild.contentUrl = [aChildDict objectForKey:@"ChildURL"];
                                mChild.childid = [NSNumber numberWithInt:[[aChildDict objectForKey:@"Childid"]integerValue]];
                                mChild.childName = [aChildDict objectForKey:@"ChildName"];
                                mChild.frame = [aChildDict objectForKey:@"ChildFrame"];
                                mChild.text=[aChildDict objectForKey:@"text"];
                                mChild.textColour = [aChildDict objectForKey:@"textColor"];
                                mChild.contentType = [NSNumber numberWithInt:[[aChildDict objectForKey:@"ChildType"]integerValue]];
                                mChild.textSize = [NSNumber numberWithInt:[[aChildDict objectForKey:@"textSize"]integerValue]];
                                
                                NSArray *aReference = [aChildDict valueForKey:@"references"];
                                
                                for(NSDictionary *aReferenceDict in aReference)
                                {
                                    Reference *mReference = (Reference*)[NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
                                    
                                    
                                    mReference.referenceName = [aReferenceDict objectForKey:@"ReferenceName"];
                                    mReference.referenceId = [NSNumber numberWithInt:[[aReferenceDict objectForKey:@"Referenceid"] integerValue]];
                                    
                                    mReference.contentUrl = [aReferenceDict objectForKey:@"ReferenceUrl"];
                                    
                                    mReference.filepath = [aReferenceDict objectForKey:@"filePath"];
                                    
                                    mReference.child = mChild;
                                }
                                
                                mChild.parent = mParent;
                            }
                            mParent.content = mContent;
                        }
                    
                    
                    ////DataList &summary
                    NSArray *datalistArr = [aDict valueForKey:@"DataLists"];
                    
                    for(NSDictionary *adatalist in datalistArr)
                    {
                        
                        DataList *mDataList = (DataList *)[NSEntityDescription insertNewObjectForEntityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
                        
                        
                        mDataList.dlType = [adatalist objectForKey:@"dlType"];
                        mDataList.dlid = [NSNumber numberWithInt:[[adatalist objectForKey:@"dlID"]integerValue]];
                        mDataList.dlTopic = [adatalist objectForKey:@"dlTitle"];
                        mDataList.dlDescription = [adatalist objectForKey:@"dlDescription"];
                        
                        mDataList.content = mContent;
                    }
                    
                    NSArray *SummArr = [aDict valueForKey:@"summarys"];
                    
                    for(NSDictionary *aSumm in SummArr)
                    {
                        
                        Summary *mSummary = (Summary *)[NSEntityDescription insertNewObjectForEntityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
                        
                        
                        mSummary.summType = [aSumm objectForKey:@"summType"];
                        mSummary.summID = [NSNumber numberWithInt:[[aSumm objectForKey:@"summID"]integerValue]];
                        mSummary.summTitle = [aSumm objectForKey:@"summTitle"];
                        mSummary.summURL = [aSumm objectForKey:@"summURL"];
                        
                        mSummary.content = mContent;
                    }

                    
                        mContent.mbrand = mBrand;
                        //[tempBrandArr addObject:mBrand];
                    
                    
                }
              
                
                for (aBrand in dbBrandArray)
                {
                    
                    for (i=0;i<[[aBrand.contents allObjects] count];i++)
                    {
                        if ([[aBrand.contents allObjects] containsObject:mContent])
                        {
                            [tempBrandArr addObject:aBrand];
                        }
                    }
                    
                    
                    
                }
                
                [tempBrandArr addObject:mBrand];
                
                
                mContent.brand = [NSSet setWithArray:tempBrandArr];
                [tempBrandArr removeAllObjects];
                
                
                
                if (![[aDict valueForKey:@"del_status"] isEqualToString:@"1"]) {
                    [contentArray addObject:mContent];
                    mBrand.contents = [NSSet setWithArray:contentArray];
                }
                else
                {
                  // deleete
                 // delete current dict from brand dict array
                    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[[aAppDelegate.brandArr objectAtIndex:[brandArray indexOfObject:brandDict]]objectForKey:@"contents"]];
                    
                    [array removeObjectAtIndex:[contentArr indexOfObject:aDict]];
                    [contentArray removeObject:mContent];
                    
                    [Utility deleteContent:cid];
                    
                }
                
  
            }
                
                
            }
        
        [dbBrandArray addObject:mBrand];
        
    }

    NSLog(@"dbBrandArray = %@",dbBrandArray);
    
    return dbBrandArray;
    
    NSError *error;
    if (![aAppDelegate.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
//
- (void)setDelegate:(id)val
{
    aDelegate = val;
}

- (id)delegate
{
    return aDelegate;
}
-(void)dealloc{
    [XmlParser release];
    [super dealloc];
}
@end
