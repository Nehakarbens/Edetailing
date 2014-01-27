//
//  Parent.h
//  EDetailing
//
//  Created by Karbens on 12/16/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Child, Content;

@interface Parent : NSManagedObject

@property (nonatomic, retain) NSString * contentUrl;
@property (nonatomic, retain) NSNumber * hasChilds;
@property (nonatomic, retain) NSString * parentEndTime;
@property (nonatomic, retain) NSNumber * parentid;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) NSString * parentStartTime;
@property (nonatomic, retain) NSString * parentViewTime;
@property (nonatomic, retain) NSString * slideBgPath;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) NSDate * viewDate;
@property (nonatomic, retain) NSNumber * isEnabled;
@property (nonatomic, retain) NSSet *childs;
@property (nonatomic, retain) Content *content;
@end

@interface Parent (CoreDataGeneratedAccessors)

- (void)addChildsObject:(Child *)value;
- (void)removeChildsObject:(Child *)value;
- (void)addChilds:(NSSet *)values;
- (void)removeChilds:(NSSet *)values;

@end
