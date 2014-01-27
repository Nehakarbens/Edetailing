//
//  AppDelegate.h
//  MarkRep
//
//  Created by virupaksh on 12/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRParentViewController.h"
#import "MasterViewController.h"
#import "BrandsViewController.h"
#import "ContentViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,retain) ContentViewController *contentViewController;
@property (nonatomic, retain) MRParentViewController *parentController;
@property (nonatomic, retain) BrandsViewController *brandsViewController;

@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) MasterViewController *masterViewController;

@property (retain, nonatomic) NSMutableArray *brandArr;
@property (retain, nonatomic) NSMutableArray *dbBrandArr;
@property (retain, nonatomic) NSMutableArray *contentArr;

@property(assign) BOOL isChanged;

@property(nonatomic,retain) NSNumber *Cid;
@property(nonatomic,retain) NSNumber *Bid;

@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSNumber *isContentManger;
@property(assign) BOOL isMylan;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
