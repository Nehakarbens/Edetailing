//
//  ControllerToLaunch.h
//  EDetailing
//
//  Created by Karbens on 1/15/14.
//  Copyright (c) 2014 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ControllerToLaunch : NSManagedObject

@property (nonatomic, retain) NSString * brandId;
@property (nonatomic, retain) NSString * contentId;
@property (nonatomic, retain) NSString * controllerName;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * isMylan;

@end
