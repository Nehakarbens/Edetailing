  //
//  Utility.m
//  MarkRep
//
//  Created by virupaksh on 13/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import "Parent.h"
#import "Child.h"
#import "Brand.h"
#import "Content.h"

@implementation Utility
@synthesize contents;

#pragma mark - Fetch Contents

+ (NSMutableArray *)getContentsFromPlist {
    NSString *aPath = [[NSBundle mainBundle] pathForResource:@"MarkRepPlist" ofType:@"plist"];
    
    
    NSArray *aContents = [NSArray arrayWithContentsOfFile:aPath];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    Brand *aBrand = (Brand *)[NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
    aBrand.brandName = [[NSUserDefaults standardUserDefaults] objectForKey:@"brandName"];
    
    for (NSDictionary *aDict in aContents)
    {
        Content *aContent = (Content *)[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
        aContent.contentName = [aDict valueForKey:@"name"];//[[NSUserDefaults standardUserDefaults] objectForKey:@"contentName"];
        NSLog(@"Content Name = %@",aContent.contentName);
        
        NSArray *parentsArr = [aDict valueForKey:@"parents"];
        
        for(NSDictionary *aParentDict in parentsArr)
        {
            
            Parent *aParent = (Parent *)[NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
            
            aParent.parentName = [aParentDict valueForKey:@"name"];
            aParent.slideBgPath = [aParentDict valueForKey:@"slideBgPath"];
            BOOL hasChild = [[aParentDict valueForKey:@"hasChilds"] boolValue];
            aParent.hasChilds = [NSNumber numberWithBool:hasChild];
            
            NSArray *aChildren = [aParentDict valueForKey:@"children"];
            
            
            for(NSDictionary *aChildDict in aChildren)
            {
                Child *aChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                
                aChild.imageName = [aChildDict valueForKey:@"name"];
                aChild.frame = [aChildDict valueForKey:@"frame"];
                
                
                aChild.contentUrl = [aChildDict valueForKey:@"contenturl"];
                aChild.filePath = [aChildDict valueForKey:@"filePath"];
                aChild.type = [aChildDict valueForKey:@"type"];
                int contentType = [[aChildDict valueForKey:@"contentType"] integerValue];
                aChild.contentType = [NSNumber numberWithInt:contentType];
                aChild.parent = aParent;
            }
            //aParent.content = aContent;
        }
        
        aContent.brand = aBrand;
    }
    
    
    
    //[aAppDelegate.managedObjectContext save:nil];
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"aContent"];
    NSMutableArray *aParents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    return aParents;
}

+ (NSMutableArray *)getAllContents
{
     AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"aContent"];
    
    NSMutableArray *aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    return aContents;
    
}

+ (NSMutableArray *)getAllBrands
{
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"AllBrands"];
    
    NSMutableArray *aBrands = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    return aBrands;
    
}

+ (NSMutableArray *)getParsedContents:(NSMutableArray *) brandArray{
    //NSString *aPath = [[NSBundle mainBundle] pathForResource:@"MarkRepPlist" ofType:@"plist"];
    
    
    //NSArray *aContents = [NSArray arrayWithContentsOfFile:aPath];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDateFormatter *Formater = [[NSDateFormatter alloc]init];
    Formater.dateFormat = @"yyyy-MM-dd HH-mm-ss";
   // NSDate *dateStr = [NSDate da]
    NSDate *date = [Formater dateFromString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    NSLog(@"date = %@",date);
        
       for (NSDictionary *brandDict in brandArray)
    {
        Brand *mBrand = (Brand *)[NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
        mBrand.brandName = [brandDict objectForKey:@"name"];
        
        NSArray *contentArr = [brandDict objectForKey:@"contents"];
        
        for (NSDictionary *aDict in contentArr)
        {
            NSNumber *cid = [NSNumber numberWithInteger:[[aDict valueForKey:@"id"]integerValue]];
            
            BOOL hasContent = false;
            
            hasContent = [self checkContentExist:cid];
            
            if (!hasContent)
            {
                Content *mContent = (Content *)[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
                mContent.contentName = [aDict valueForKey:@"contentName"];
                mContent.lastdownloaddate = date;
                
                NSLog(@"Content Name = %@",mContent.contentName);
                
                NSArray *parentsArr = [aDict valueForKey:@"Parents"];
                
                for(NSDictionary *aParentDict in parentsArr)
                {
                    
                    Parent *mParent = (Parent *)[NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
                    
                    
                    mParent.contentUrl = [aParentDict objectForKey:@"Parenturl"];
                    mParent.parentid = [NSNumber numberWithInt:[[aParentDict objectForKey:@"Parentid"]integerValue]];
                    mParent.parentName = [aParentDict objectForKey:@"parentName"];
                    mParent.hasChilds = [NSNumber numberWithInt:[[aParentDict objectForKey:@"parentChldStatus"]integerValue]];
                    
                    
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
                        
                        mChild.parent = mParent;
                    }
                    mParent.content = mContent;
                }

                mContent.brand = mBrand;
            }
            
            
            else{
                
                
                
            }
           
        }
        
    }
    
    
    //[aAppDelegate.managedObjectContext save:nil];
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"aContent"];
    NSMutableArray *contentArr = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    return contentArr;
}




+ (BOOL )checkContentExist:(NSNumber *)cid{
    
    
    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"contentId = %@",cid];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;

    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aContents count]== 0)
    {
        return false;
    }
    else
    {
        return true;
    }
    
}

+ (Brand *)getBrandIfExist:(NSNumber *)bid{
    
    
    NSMutableArray *aBrands = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"brandId = %@",bid];
    
    NSEntityDescription *aBrandEntity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aBrandEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aBrands = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aBrands count]== 0)
    {
        return nil;
    }
    else
    {
        return [aBrands objectAtIndex:0];
    }
    
}
+ (NSMutableArray *)getBrandsforContent:(NSNumber *)cid{
    
    
    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    NSMutableArray *arrayBrand = [[NSMutableArray alloc]init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"contentId = %@",cid];
    
    NSEntityDescription *aContentEntity = [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aContentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    for (NSManagedObject *fetchedObject in aContents) {
        [arrayBrand addObject:[fetchedObject valueForKey:@"mbrand"]];
    }
    
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [arrayBrand count]== 0)
    {
        return nil;
    }
    else
    {
        return arrayBrand ;
    }
    
}
+ (Content *)getContentIfExist:(NSNumber *)cid{
    
    
    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"contentId = %@",cid];
    
    NSEntityDescription *aContentEntity = [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aContentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aContents count]== 0)
    {
        return nil;
    }
    else
    {
        return [aContents objectAtIndex:0];
    }
    
}


+ (Content *)getContentIfExist:(NSNumber *)cid :(NSNumber *)bid{
    
    
    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    //NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"contentId = %@",cid];
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"contentId = %@ ",
                              cid];
    
    NSEntityDescription *aContentEntity = [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    
    [aFetchRequest setEntity:aContentEntity];
   // [aFetchRequest setPredicate:aPredicate];
    [aFetchRequest setPredicate:Predicate];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    BOOL isContentExist;
    Content *aContent;
    
    if (!error && [aContents count]== 0)
    {
        return nil;
    }
    else
    {
        for (int i=0; i<[aContents count]; i++)
        {
            aContent = [aContents objectAtIndex:i];
            
            for (Brand *aBrand in aContent.brand)
            {
                if(aBrand.brandId == bid)
                {
                    isContentExist = TRUE;
                }
                else{
                    isContentExist = FALSE;
                }
            }
        }
        
        if (isContentExist == TRUE) {
            return aContent;
        }
        else{
            return nil;
        }
        
        }
    
}

+ (Parent *)getParentIfExist:(NSNumber *)pid{
    
    
    NSMutableArray *aParents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"parentid = %@",pid];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aParents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aParents count]== 0)
    {
        return nil;
    }
    else
    {
        return [aParents objectAtIndex:0];
    }
    
}

+ (DataList *)getDataListIfExist:(NSNumber *)Did{
    
    
    NSMutableArray *aDataList = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"dlid = %@",Did];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aDataList = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aDataList count]== 0)
    {
        return nil;
    }
    else
    {
        return [aDataList objectAtIndex:0];
    }
    
}

+ (Summary *)getSummaryIfExist:(NSNumber *)sid{
    
    
    NSMutableArray *aSummA = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"summID = %@",sid];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aSummA = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aSummA count]== 0)
    {
        return nil;
    }
    else
    {
        return [aSummA objectAtIndex:0];
    }
    
}

+ (Reference *)getRefIfExist:(NSNumber *)rid{
    
    
    NSMutableArray *aRef = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"referenceId = %@",rid];
    
    NSEntityDescription *aReferenceEntity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aReferenceEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aRef = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aRef count]== 0)
    {
        return nil;
    }
    else
    {
        return [aRef objectAtIndex:0];
    }
    
}






+ (Child *)getChildIfExist:(NSNumber *)cid{
    
    
    NSMutableArray *aChilds = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"childid = %@",cid];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aChilds = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aChilds count]== 0)
    {
        return nil;
    }
    else
    {
        return [aChilds objectAtIndex:0];
    }
    
}

+ (BOOL )checkIfParentFilePathExist:(NSNumber *)pid{
    
    
    NSMutableArray *aParents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"parentid = %@",pid];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aParents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aParents count]== 0)
    {
        return false;
    }
    else
    {
        if ([[[aParents objectAtIndex:0] slideBgPath] isEqualToString:@""] || [[aParents objectAtIndex:0] slideBgPath] == nil)
        {
            return false;
        }
        else
        {
            return true;
        }
       
    }
    
}

+ (BOOL )checkIfDataListFilePathExist:(NSNumber *)did{
    
    
    NSMutableArray *aDataList = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"dlid = %@",did];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"DataList" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aDataList = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aDataList count]== 0)
    {
        return false;
    }
    else
    {
        if ([[[aDataList objectAtIndex:0] dlFilepath] isEqualToString:@""] || [[aDataList objectAtIndex:0] dlFilepath] == nil)
        {
            return false;
        }
        else
        {
            return true;
        }
        
    }
    
}

+ (BOOL )checkIfSummaryFilePathExist:(NSNumber *)Summid{
    
    
    NSMutableArray *aSumm = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"summID = %@",Summid];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Summary" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aSumm = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aSumm count]== 0)
    {
        return false;
    }
    else
    {
        if ([[[aSumm objectAtIndex:0] summfilePath] isEqualToString:@""] || [[aSumm objectAtIndex:0] summfilePath] == nil)
        {
            return false;
        }
        else
        {
            return true;
        }
        
    }
    
}
+ (BOOL )checkIfBrandFilePathExist:(NSNumber *)Bid{
    
    
    NSMutableArray *aBrand = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"brandId = %@",Bid];
    
    NSEntityDescription *aParentEntity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aParentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aBrand = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aBrand count]== 0)
    {
        return false;
    }
    else
    {
        if ([[[aBrand objectAtIndex:0] brandImagePath] isEqualToString:@""] || [[aBrand objectAtIndex:0]brandImagePath ] == nil)
        {
            return false;
        }
        else
        {
            return true;
        }
        
    }
    
}

+ (BOOL )checkIfChildFilePathExist:(NSNumber *)cid{
    
    
    NSMutableArray *aChilds = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"childid = %@",cid];
    
    NSEntityDescription *aChildEntity = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aChildEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aChilds = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aChilds count]== 0)
    {
        return false;
    }
    else
    {
        if ([[[aChilds objectAtIndex:0] filePath] isEqualToString:@""]|| [[aChilds objectAtIndex:0] filePath] == nil)
        {
            return false;
        }
        else
        {
            return true;
        }
    
    }
    
}

+ (BOOL )checkIfReferenceFilePathExist:(NSNumber *)rid{
    
    
    NSMutableArray *aReferences = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"referenceId = %@",rid];
    
    NSEntityDescription *aReferenceEntity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aReferenceEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aReferences = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aReferences count]== 0)
    {
        return false;
    }
    else
    {
        Reference *aRef = [aReferences objectAtIndex:0];
        
        if ([aRef.filepath isEqualToString:@""] || aRef.filepath == nil)
        {
            return false;
        }
        else
        {
            return true;
        }
        
    }
    
}


+ (NSMutableArray *)getContentsFromPlist2 {
    NSString *aPath = [[NSBundle mainBundle] pathForResource:@"MarkRepPlist" ofType:@"plist"];
    
    
    NSArray *aContents = [NSArray arrayWithContentsOfFile:aPath];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    Brand *aBrand = (Brand *)[NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:aAppDelegate.managedObjectContext];
    aBrand.brandName = [[NSUserDefaults standardUserDefaults] objectForKey:@"brandName"];
    
    for (NSDictionary *aDict in aContents)
    {
        Content *aContent = (Content *)[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
        aContent.contentName = [aDict valueForKey:@"name"];//[[NSUserDefaults standardUserDefaults] objectForKey:@"contentName"];
        NSLog(@"Content Name = %@",aContent.contentName);
        
        NSArray *parentsArr = [aDict valueForKey:@"parents"];
        
        for(NSDictionary *aParentDict in parentsArr)
        {
            
            Parent *aParent = (Parent *)[NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:aAppDelegate.managedObjectContext];
            
            aParent.parentName = [aParentDict valueForKey:@"name"];
            aParent.slideBgPath = [aParentDict valueForKey:@"slideBgPath"];
            BOOL hasChild = [[aParentDict valueForKey:@"hasChilds"] boolValue];
            aParent.hasChilds = [NSNumber numberWithBool:hasChild];
            
            NSArray *aChildren = [aParentDict valueForKey:@"children"];
            
            
            for(NSDictionary *aChildDict in aChildren)
            {
                Child *aChild= (Child *)[NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:aAppDelegate.managedObjectContext];
                
                aChild.imageName = [aChildDict valueForKey:@"name"];
                aChild.frame = [aChildDict valueForKey:@"frame"];
                
                
                aChild.contentUrl = [aChildDict valueForKey:@"contenturl"];
                aChild.filePath = [aChildDict valueForKey:@"filePath"];
                aChild.type = [aChildDict valueForKey:@"type"];
                int contentType = [[aChildDict valueForKey:@"contentType"] integerValue];
                aChild.contentType = [NSNumber numberWithInt:contentType];
                aChild.parent = aParent;
            }
            //aParent.content = aContent;
        }
        
        aContent.brand = aBrand;
    }
    
    
    
    //[aAppDelegate.managedObjectContext save:nil];
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"AllParents"];
    NSMutableArray *aParents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    return aParents;
}

#pragma mark - Clear slideview times
+ (void)clearSlideViewTimes {
    
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [aAppDelegate.managedObjectModel fetchRequestTemplateForName:@"aContent"];
    NSMutableArray *aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    
    for(Content *aContent in aContents)
    {
        aContent.contStartTime = @"";
        aContent.contEndTime = @"";
        
        for (Parent *aParent in aContent.parent)
        {
            aParent.parentViewTime = @"";
            aParent.parentEndTime = @"";
            aParent.parentStartTime = @"";
            
            aParent.timeInterval = [NSNumber numberWithDouble:0.0];
            
            for(Child *aChild in aParent.childs)
            {
                aChild.childViewTime = @"";
                aChild.childEndTime = @"";
                aChild.childStartTime = @"";
                aChild.timeInterval = [NSNumber numberWithDouble:0.0];
                
                for (Reference *ref in aChild.references) {
                    ref.refStartTime = @"";
                    ref.refTimeInterval = [NSNumber numberWithDouble:0.0];
                    ref.refViewTime = @"";
                    ref.refEndTime  = @"";
                    
                }
            }
        }
        
        
        for (DataList *aDl in aContent.datalist)
        {
            aDl.dlViewTime = @"";
            aDl.dlEndTime = @"";
            aDl.dlstartTime = @"";
            
            aDl.dlTimeInterval = [NSNumber numberWithDouble:0.0];
        }
        
        
        for (Summary *aSumm in aContent.summary)
        {
            aSumm.summViewTime = @"";
            aSumm.summEndTime = @"";
            aSumm.summStartTime = @"";
            
            aSumm.summTimeInterval = [NSNumber numberWithDouble:0.0];
            
        }
        
        
    }
    
    
    [aAppDelegate.managedObjectContext save:nil];
    aContents = nil;
}


+(BOOL)deleteParents:(NSNumber *)cid{

    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"contentId = %@",cid];
    
    NSEntityDescription *aContentEntity = [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aContentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aContents count]== 0)
    {
        return false;
    }
    else
    {
        Content *aContent;
       
        aContent = [aContents objectAtIndex:0];
       // NSSet *parents = aContent.parent;
         //[aAppDelegate.managedObjectContext deleteObject:[[aContents objectAtIndex:0]parent]];
            
            for (Parent *parent in aContent.parent)
            {
                 [aAppDelegate.managedObjectContext deleteObject:parent];
            }
            
        
        
//        for (NSManagedObject *object in aContents)
//        {
//            [aAppDelegate.managedObjectContext deleteObject:object];
//            
//        }
        aContent.parent = [NSSet set];
        [aAppDelegate.managedObjectContext save:nil];
        return true;
    }

    
}
+(BOOL)deleteContent:(NSNumber *)cid{
    
    NSMutableArray *aContents = [[NSMutableArray alloc] init];
    AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *aFetchRequest = [[NSFetchRequest alloc] init];
    [aFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"contentId = %@",cid];
    
    NSEntityDescription *aContentEntity = [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
    
    
    [aFetchRequest setEntity:aContentEntity];
    [aFetchRequest setPredicate:aPredicate];
    
    aContents = (NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:aFetchRequest error:nil];
    NSError *error = nil;
    
    //NSLog(@"aParent = %@",aParent);
    
    
    if (!error && [aContents count]== 0)
    {
        return false;
    }
    else
    {
        Content *aContent;
//        
        aContent = [aContents objectAtIndex:0];
        [aAppDelegate.managedObjectContext deleteObject:aContent];
        aContent.brand = [NSSet set];
        [aAppDelegate.managedObjectContext save:nil];
        return true;
    }
    
    
}

@end
