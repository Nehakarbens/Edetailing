//
//  MDDataPackage.h
//  MyDay
//
//  Created by Akshay Kunila on 26/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kMDDataPackageUTI;

@interface MDDataPackage : NSObject <NSCoding>

// Metadata
@property (copy, nonatomic, readonly) NSString *sourceApplicationName;
@property (copy, nonatomic, readonly) NSString *sourceApplicationIdentifier;
@property (copy, nonatomic, readonly) NSString *sourceApplicationVersion;
@property (copy, nonatomic, readonly) NSString *sourceApplicationBuild;

// Application Data
@property (strong, nonatomic, readonly) NSData *payload;

-(id)initWithSourceApplicationName:(NSString *)sourceApplicationName
       sourceApplicationIdentifier:(NSString *)sourceApplicationIdentifier
          sourceApplicationVersion:(NSString *)sourceApplicationVersion
            sourceApplicationBuild:(NSString *)sourceApplicationBuild
                           payload:(NSData *)payload;

+(MDDataPackage *)dataPackageForCurrentApplicationWithPayload:(NSData *)payload;


-(NSData *)dataRepresentation;
+(MDDataPackage *)unarchivePackageData:(NSData *)data;

@end
