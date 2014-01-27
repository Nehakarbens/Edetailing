//
//  MDDataSharingController.h
//  MyDay
//
//  Created by Akshay Kunila on 26/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDDataPackage;

typedef void(^MDDataSharingSendDataHandler)(BOOL *sent, NSError *error);
typedef void(^MDDataSharingHandler)(MDDataPackage *retrievedPackage, NSError *error);

extern NSString *kReadPasteboardDataQuery;

typedef enum
{
    MDDataSharingErrorTypeNoApplicationAvailableForScheme = 100,
    MDDataSharingErrorTypeNoPasteboardForName = 200,
    MDDataSharingErrorTypeNoDataFound = 300,
} MDDataSharingErrorType;


@interface MDDataSharingController : NSObject

+(void)sendDataToApplicationWithScheme:(NSString *)scheme
                           dataPackage:(MDDataPackage *)dataPackage
                     completionHandler:(MDDataSharingSendDataHandler)completionHandler;

+(void)handleSendPasteboardDataURL:(NSURL *)sendPasteboardDataURL
                 completionHandler:(MDDataSharingHandler)completionHandler;

@end
