//
//  MDDataSharingController.m
//  MyDay
//
//  Created by Akshay Kunila on 26/08/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import "MDDataSharingController.h"
#import "MDDataPackage.h"

NSString *kReadPasteboardDataQuery = @"ReadPasteboardData";
NSString *const AppDataSharingErrorDomain = @"AppDataSharingErrorDomain";

@implementation MDDataSharingController

+(void)sendDataToApplicationWithScheme:(NSString *)scheme
                           dataPackage:(MDDataPackage *)dataPackage
                     completionHandler:(MDDataSharingSendDataHandler)completionHandler;
{
    NSError *error = nil;
    
    // Setup the Pasteboard
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
    [pasteboard setPersistent:YES]; // Makes sure the pasteboard lives beyond app termination.
    NSString *pasteboardName = [pasteboard name];
    
    // Write The Data
    NSData *data = [dataPackage dataRepresentation];
    NSString *pasteboardType = kMDDataPackageUTI; 
    [pasteboard setData:data forPasteboardType:pasteboardType];
    
    // Launch the destination app
    NSURL *sendingURL = [[self class] sendPasteboardDataURLForScheme:scheme pasteboardName:pasteboardName];
    if ([[UIApplication sharedApplication] canOpenURL:sendingURL])
    {
        completionHandler(YES, nil);
        [[UIApplication sharedApplication] openURL:sendingURL];
    }
    else
    {
        [pasteboard setData:nil forPasteboardType:pasteboardType];
        [pasteboard setPersistent:NO];
        
        NSDictionary *errorInfoDictionary = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"No application was found to handle the url:", nil), sendingURL]};
        error = [NSError errorWithDomain:AppDataSharingErrorDomain
                                    code:MDDataSharingErrorTypeNoApplicationAvailableForScheme
                                userInfo:errorInfoDictionary];
    }
    
    completionHandler(NO, error);
}

+(void)handleSendPasteboardDataURL:(NSURL *)sendPasteboardDataURL
                 completionHandler:(MDDataSharingHandler)completionHandler;
{
    NSString *query = [sendPasteboardDataURL query];
    NSString *pasteboardName = [sendPasteboardDataURL fragment];
    NSAssert2(([query isEqualToString:kReadPasteboardDataQuery] && pasteboardName), @"Malformed or incorrect url sent to %@. URL: %@", NSStringFromSelector(_cmd), sendPasteboardDataURL);
    
    MDDataPackage *dataPackage = nil;
    NSError *error = nil;
    
    NSString *pasteboardType = kMDDataPackageUTI;
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:pasteboardName create:NO];
    if (pasteboard)
    {
        NSData *data = [pasteboard dataForPasteboardType:pasteboardType];
        if (data)
        {
            dataPackage = [MDDataPackage unarchivePackageData:data];
        }
        else
        {
            NSDictionary *errorInfoDictionary = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"No data found on pasteboard with name:", nil), pasteboardName]};
            error = [NSError errorWithDomain:AppDataSharingErrorDomain
                                        code:MDDataSharingErrorTypeNoDataFound
                                    userInfo:errorInfoDictionary];
        }
        [pasteboard setData:nil forPasteboardType:pasteboardType];
    }
    else
    {
        NSDictionary *errorInfoDictionary = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"No pasteboard found for name:", nil), pasteboardName]};
        error = [NSError errorWithDomain:AppDataSharingErrorDomain
                                    code:MDDataSharingErrorTypeNoPasteboardForName
                                userInfo:errorInfoDictionary];
    }
    completionHandler(dataPackage, error);
}

#pragma mark - URLs

+(NSURL *)sendPasteboardDataURLForScheme:(NSString *)scheme pasteboardName:(NSString *)pasteboardName
{
    NSString *urlString = [NSString stringWithFormat:@"%@://?%@#%@", scheme, kReadPasteboardDataQuery, pasteboardName];
    
    return [NSURL URLWithString:urlString];
}


@end
