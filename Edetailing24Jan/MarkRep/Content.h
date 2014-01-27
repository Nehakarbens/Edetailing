//
//  Content.h
//  EDetailing
//
//  Created by Karbens on 12/31/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand, DataList, Parent, Summary;

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * contEndTime;
@property (nonatomic, retain) NSNumber * contentId;
@property (nonatomic, retain) NSString * contentName;
@property (nonatomic, retain) NSString * contStartTime;
@property (nonatomic, retain) NSNumber * downStatus;
@property (nonatomic, retain) NSNumber * isUpdateAvail;
@property (nonatomic, retain) NSString * lastdownloaddate;
@property (nonatomic, retain) NSString * sumStrTime;
@property (nonatomic, retain) NSString * sumEndTime;
@property (nonatomic, retain) NSString * dlStrTime;
@property (nonatomic, retain) NSString * dlendTime;
@property (nonatomic, retain) NSString * refStrTime;
@property (nonatomic, retain) NSString * refEndTime;
@property (nonatomic, retain) NSString * vidStrTime;
@property (nonatomic, retain) NSString * vidEndTime;
@property (nonatomic, retain) NSString * emailStrTime;
@property (nonatomic, retain) NSString * emailEndTime;
@property (nonatomic, retain) NSSet *brand;
@property (nonatomic, retain) NSSet *datalist;
@property (nonatomic, retain) Brand *mbrand;
@property (nonatomic, retain) NSSet *parent;
@property (nonatomic, retain) NSSet *summary;
@end

@interface Content (CoreDataGeneratedAccessors)

- (void)addBrandObject:(Brand *)value;
- (void)removeBrandObject:(Brand *)value;
- (void)addBrand:(NSSet *)values;
- (void)removeBrand:(NSSet *)values;

- (void)addDatalistObject:(DataList *)value;
- (void)removeDatalistObject:(DataList *)value;
- (void)addDatalist:(NSSet *)values;
- (void)removeDatalist:(NSSet *)values;

- (void)addParentObject:(Parent *)value;
- (void)removeParentObject:(Parent *)value;
- (void)addParent:(NSSet *)values;
- (void)removeParent:(NSSet *)values;

- (void)addSummaryObject:(Summary *)value;
- (void)removeSummaryObject:(Summary *)value;
- (void)addSummary:(NSSet *)values;
- (void)removeSummary:(NSSet *)values;

@end
