//
//  MDDataPackage.m
//  MyDay
//
//  Created by Akshay Kunila on 26/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "MDDataPackage.h"


NSString *kMDDataPackageUTI = @"com.karbens.MyDay.DataPackage";

static NSString *kMDPackageDataKey = @"kMDPackageDataKey";
static NSString *kMDSourceApplicationNameKey = @"kMDSourceApplicationNameKey";
static NSString *kMDSourceApplicationIdentifierKey = @"kMDSourceApplicationIdentifierKey";
static NSString *kMDSourceApplicationVersionKey = @"kMDSourceApplicationVersionKey";
static NSString *kMDSourceApplicationBuildKey = @"kMDSourceApplicationBuildKey";
static NSString *kMDPayloadKey = @"kMDPayloadKey";

@interface MDDataPackage ()

// Metadata
@property (copy, nonatomic, readwrite) NSString *sourceApplicationName;
@property (copy, nonatomic, readwrite) NSString *sourceApplicationIdentifier;
@property (copy, nonatomic, readwrite) NSString *sourceApplicationVersion;
@property (copy, nonatomic, readwrite) NSString *sourceApplicationBuild;

// Application Data
@property (strong, nonatomic, readwrite) NSData *payload;

@end

@implementation MDDataPackage

-(id)initWithSourceApplicationName:(NSString *)sourceApplicationName
       sourceApplicationIdentifier:(NSString *)sourceApplicationIdentifier
          sourceApplicationVersion:(NSString *)sourceApplicationVersion
            sourceApplicationBuild:(NSString *)sourceApplicationBuild
                           payload:(NSData *)payload
{
    self = [super init];
    if (self)
    {
        [self setSourceApplicationName:sourceApplicationName];
        [self setSourceApplicationIdentifier:sourceApplicationIdentifier];
        [self setSourceApplicationVersion:sourceApplicationVersion];
        [self setSourceApplicationBuild:sourceApplicationBuild];
        [self setPayload:payload];
    }
    
    return self;
}

+(MDDataPackage *)dataPackageForCurrentApplicationWithPayload:(NSData *)payload
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *currentApplicationName = [infoPlist valueForKey:@"CFBundleDisplayName"];
    NSString *currentApplicationIdentifier = [infoPlist valueForKey:@"CFBundleIdentifier"];
    NSString *currentApplicationVersion = [infoPlist valueForKey:@"CFBundleShortVersionString"];
    NSString *currentApplicationBuild = [infoPlist valueForKey:@"CFBundleVersion"];
    
    MDDataPackage *package = [[[self class] alloc] initWithSourceApplicationName:currentApplicationName
                                                         sourceApplicationIdentifier:currentApplicationIdentifier
                                                            sourceApplicationVersion:currentApplicationVersion
                                                              sourceApplicationBuild:currentApplicationBuild
                                                                             payload:payload];
    
    return package;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.sourceApplicationName forKey:kMDSourceApplicationNameKey];
    [encoder encodeObject:self.sourceApplicationIdentifier forKey:kMDSourceApplicationIdentifierKey];
    [encoder encodeObject:self.sourceApplicationVersion forKey:kMDSourceApplicationVersionKey];
    [encoder encodeObject:self.sourceApplicationBuild forKey:kMDSourceApplicationBuildKey];
    [encoder encodeObject:self.payload forKey:kMDPayloadKey];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    NSString *sourceApplicationName = [decoder decodeObjectForKey:kMDSourceApplicationNameKey];
    NSString *sourceApplicationIdentifier = [decoder decodeObjectForKey:kMDSourceApplicationIdentifierKey];
    NSString *sourceApplicationVersion = [decoder decodeObjectForKey:kMDSourceApplicationVersionKey];
    NSString *sourceApplicationBuild = [decoder decodeObjectForKey:kMDSourceApplicationBuildKey];
    NSData *payload = [decoder decodeObjectForKey:kMDPayloadKey];
    
    return [self initWithSourceApplicationName:sourceApplicationName
                   sourceApplicationIdentifier:sourceApplicationIdentifier
                      sourceApplicationVersion:sourceApplicationVersion
                        sourceApplicationBuild:sourceApplicationBuild
                                       payload:payload];
}


#pragma mark - Data Helpers

-(NSData *)dataRepresentation
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kMDPackageDataKey];
    [archiver finishEncoding];
    
    return [NSData dataWithData:data];
}

+(MDDataPackage *)unarchivePackageData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    MDDataPackage *package = [unarchiver decodeObjectForKey:kMDPackageDataKey];
    [unarchiver finishDecoding];
    
    return package;
}

#pragma mark - Accessors

@synthesize sourceApplicationName = _sourceApplicationName;
@synthesize sourceApplicationIdentifier = _sourceApplicationIdentifier;
@synthesize sourceApplicationVersion = _sourceApplicationVersion;
@synthesize sourceApplicationBuild = _sourceApplicationBuild;
@synthesize payload = _payload;

@end
