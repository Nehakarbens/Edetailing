//
//  AppDelegate.m
//  MarkRep
//
//  Created by virupaksh on 12/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "ControllerToLaunch.h"
#import "MDDataPackage.h"
#import "MDDataSharingController.h"
#import "NSManagedObjectArchiving.h"
#import "Utility.h"
#import "ContentDetailViewController.h"

//NSString *kReadPasteboardDataQuery = @"ReadPasteboardData";
//NSString *const AppDataSharingErrorDomain = @"AppDataSharingErrorDomain";

@implementation AppDelegate
@synthesize Cid,Bid,isChanged,username,password,isMylan,isContentManger;
- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_brandArr release];
    [_contentArr release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize brandsViewController,contentViewController;
@synthesize brandArr = _brandArr;  // array of dictionaries
@synthesize dbBrandArr = _dbBrandArr;  // array of Model Objects
@synthesize contentArr = _contentArr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
  
    username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    
    /*
    if ([username length]!= 0 && [password length]!=0) {
        isMylan = TRUE;
    }
     */
    
    BrandsViewController *aBrandsViewController = [[BrandsViewController alloc] initWithNibName:@"BrandsViewController" bundle:nil];
    
    self.brandsViewController = aBrandsViewController;
    [[NSUserDefaults standardUserDefaults] setObject:@"notFromMylan" forKey:@"source"];
    
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.brandsViewController];
    //self.navController.delegate = self.brandsViewController;
    
    self.navController = aNavController;
    [aNavController release];
    aNavController = nil;
    
      
    self.window.rootViewController = self.navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.navController popToRootViewControllerAnimated:YES];
//    [self.navController popToRootViewControllerAnimated:NO];
    [self.navController setNavigationBarHidden:NO animated:YES];
    NSLog(@"entered in backgound");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

        application.applicationIconBadgeNumber = 0;
    
    
    if ([username length] == 0 && [password length] == 0)
    {
        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Access the app through Content Manager in My-day" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSLog(@"entered in forground");
    if (url != nil) {
        
    
    if ([[url query] isEqualToString:kReadPasteboardDataQuery])
    {
        [MDDataSharingController handleSendPasteboardDataURL:url
                                           completionHandler:^(MDDataPackage *retrievedPackage, NSError *error)
        {
         if (retrievedPackage)
         {
                                                   NSData *packageData = [retrievedPackage payload];
                                                   AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                   [Utility clearSlideViewTimes];
                                                   ControllerToLaunch *aControllerToLaunch = (ControllerToLaunch *) [NSManagedObjectUnarchiver unarchiveObjectWithData:packageData context:aAppDelegate.managedObjectContext insert:YES];
             
             
             Cid = [NSNumber numberWithInteger:[aControllerToLaunch.contentId integerValue]];
             Bid = [NSNumber numberWithInteger:[aControllerToLaunch.brandId integerValue]];
             isContentManger = aControllerToLaunch.isMylan;
            
             
             
             
             if (isContentManger == [NSNumber numberWithInt:1])
             {
                 username = aControllerToLaunch.username;
                 password = aControllerToLaunch.password;
                 // isContentManger = aControllerToLaunch.isMylan;
                 
                 if ([username length] != 0 && [password length] != 0)
                 {
                     [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"username"];
                     [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
                     //isMylan = TRUE;
                    // [self pushToController:@"BrandsViewController"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:nil];
                    [self.navController popToRootViewControllerAnimated:YES];
                     
                     
                     
                 }
                 
                 
             }
             else
             {
                 NSLog(@"Not from Content Manager");
                 
                 if ([username length] != 0 && [password length] != 0)
                 {
                     NSFetchRequest *request = [[NSFetchRequest alloc] init];
                     NSEntityDescription *entity =
                     [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
                     [request setEntity:entity];
                     
                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contentId == %@", Cid];
                     [request setPredicate:predicate];
                     
                     NSMutableArray *ContentArray =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
                     
                     if ([ContentArray count] == 0)
                     {
                         
                         UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@" Content does not exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [Alert show];
                         
                         
                     }
                     else
                     {
                         
                         
                         Content *aContent = [ContentArray objectAtIndex:0];
                         
                         if ([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:0]])
                         {
                             
                             NSLog(@"Go to Content View Controller");
                             
                             [self pushToController:@"ContentViewController"];
                             
                             
                         }
                         else  if ([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:1]])
                         {
                             NSLog(@"Go to content detail view controller");
                             
                             [self pushToController:@"ContentDetailViewController"];
                             NSLog(@"aContent ID: %@",aControllerToLaunch.contentId);
                             
                         }
                         else if([aContent.downStatus isEqualToNumber:[NSNumber numberWithInteger:2]])
                         {
                             
                             NSLog(@"Go to Content View Controller Failed");
                             
                             UIAlertView *Downlaodalert = [[UIAlertView alloc]initWithTitle:@"Downlaod First" message:@"Content is not downloaded completely,Please download it first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             [Downlaodalert show];
                             
                             [self pushToController:@"ContentViewController"];
                             NSLog(@"aContent ID: %@",aControllerToLaunch.contentId);
                             
                         }
                     }

                 }
                 else
                 {
                     /*
                     UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Access the app through Content Manager in MyDay" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                      */
                 }
                 
                
                 
             }
             
             NSLog(@"username = %@,password = %@",username,password);
             
        }
        else
        {
            NSLog(@"Error handling pasteboard data url: %@", [error localizedDescription]);
        }
            
        }];
    
    }
    
}
    if (!url)
    {
        return NO;
    }
    
   return YES;
    

}

#pragma mark - PushTo Controller
- (void)pushToController:(NSString *)iControllerName {
    [[NSUserDefaults standardUserDefaults] setObject:@"FromMylan" forKey:@"source"];
    
    if ([iControllerName isEqualToString:@"BrandsViewController"])
    {
        BrandsViewController *abrandViewController = [[BrandsViewController alloc] initWithNibName:iControllerName bundle:nil];
//        aContentViewController.brandID = Bid;
//        aContentViewController.isDetailing = TRUE;
//        aContentViewController.contentID = Cid;
        [self.navController pushViewController:abrandViewController animated:YES];
        [abrandViewController release];
        abrandViewController = nil;
        
    }

    
    if ([iControllerName isEqualToString:@"ContentViewController"])
    {
        ContentViewController *aContentViewController = [[ContentViewController alloc] initWithNibName:iControllerName bundle:nil];
        aContentViewController.brandID = Bid;
        aContentViewController.isDetailing = TRUE;
        aContentViewController.contentID = Cid;
        [self.navController pushViewController:aContentViewController animated:YES];
        [aContentViewController release];
        aContentViewController = nil;
        
    }
    else if([iControllerName isEqualToString:@"ContentDetailViewController"])
    {

        ContentDetailViewController *aDetailViewController = [[ContentDetailViewController alloc] initWithNibName:iControllerName bundle:nil];
        
        
        AppDelegate *aAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =
        [NSEntityDescription entityForName:@"Content" inManagedObjectContext:aAppDelegate.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contentId = %@", Cid];
        [request setPredicate:predicate];
        
        NSMutableArray *ContentArray =(NSMutableArray *)[aAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        
        NSLog(@"cont = %@",[[[ContentArray objectAtIndex:0] parent] allObjects] );
        
        aDetailViewController.aParents =  [[[ContentArray objectAtIndex:0] parent] allObjects];
        
        aDetailViewController.ContentID = Cid;
        aDetailViewController.BrandID = Bid;
        
        [self.navController pushViewController:aDetailViewController animated:YES];
        [aDetailViewController release];
        aDetailViewController = nil;
        
    }
    
}

#pragma mark - save
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MarkRep" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MarkRep.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
   if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
-(NSArray*)getAllContents
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Content"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//	NSLog(@"My token is: %@", deviceToken);
//    // Store the deviceToken in the current installation and save it to Parse.
// }

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    NSLog(@"Received notification: %@", userInfo);
    
    isChanged = YES;
    //[self addMessageFromRemoteNotification:userInfo];
    
    NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"badge"];
    NSLog(@"my message-- %@",alertValue);
    int badgeValue= [alertValue intValue];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeValue];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken

{
	    // Store the deviceToken in the current installation and save it to Parse.
    
      NSString *tokenString = [[[deviceToken description]
                             stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                            stringByReplacingOccurrencesOfString:@" "
                            withString:@""];
    
    NSLog(@"My token is: %@", tokenString);
    [[NSUserDefaults standardUserDefaults]setObject:tokenString forKey:@"DToken"];

    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
