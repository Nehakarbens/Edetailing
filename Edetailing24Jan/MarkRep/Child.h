//
//  Child.h
//  EDetailing
//
//  Created by Akshay Kunila on 23/11/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Parent, Reference;

@interface Child : NSManagedObject

@property (nonatomic, retain) NSString * childEndTime;
@property (nonatomic, retain) NSNumber * childid;
@property (nonatomic, retain) NSString * childName;
@property (nonatomic, retain) NSString * childStartTime;
@property (nonatomic, retain) NSString * childViewTime;
@property (nonatomic, retain) NSNumber * contentType;
@property (nonatomic, retain) NSString * contentUrl;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * frame;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * isAnimated;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * textColour;
@property (nonatomic, retain) NSNumber * textSize;
@property (nonatomic, retain) NSString * textStyle;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Parent *parent;
@property (nonatomic, retain) NSSet *references;
@end

@interface Child (CoreDataGeneratedAccessors)

- (void)addReferencesObject:(Reference *)value;
- (void)removeReferencesObject:(Reference *)value;
- (void)addReferences:(NSSet *)values;
- (void)removeReferences:(NSSet *)values;

@end
