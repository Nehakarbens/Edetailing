//
//  Brand.h
//  EDetailing
//
//  Created by Karbens on 12/30/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content;

@interface Brand : NSManagedObject

@property (nonatomic, retain) NSNumber * brandId;
@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSString * brandImageURl;
@property (nonatomic, retain) NSString * brandImagePath;
@property (nonatomic, retain) NSSet *contents;
@end

@interface Brand (CoreDataGeneratedAccessors)

- (void)addContentsObject:(Content *)value;
- (void)removeContentsObject:(Content *)value;
- (void)addContents:(NSSet *)values;
- (void)removeContents:(NSSet *)values;

@end
