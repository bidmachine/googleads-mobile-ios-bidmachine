//
//  BMANetworkExtras.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMANetworkExtras.h"
#import "BMAConstants.h"

@implementation BMANetworkExtras

- (NSDictionary *)allExtras {
    NSMutableDictionary *extras = [NSMutableDictionary new];
    extras[kBidMachineSellerId]             = self.sellerId;
    extras[kBidMachineTestMode]             = @(self.testMode);
    extras[kBidMachineLoggingEnabled]       = @(self.loggingEnabled);
    extras[kBidMachineEndpoint]             = self.baseURL.absoluteString;
    extras[kBidMachineSubjectToGDPR]        = @(self.isUnderGDPR);
    extras[kBidMachineHasConsent]           = @(self.hasUserConsent);
    extras[kBidMachineConsentString]        = self.consentString;
    extras[kBidMachineUserId]               = self.userId;
    extras[kBidMachineKeywords]             = self.keywords;
    extras[kBidMachineGender]               = self.gender;
    extras[kBidMachineYearOfBirth]          = self.yearOfBirth;
    extras[kBidMachineBlockedCategories]    = [self.blockedCategories componentsJoinedByString:@","];
    extras[kBidMachineBlockedAdvertisers]   = [self.blockedAdvertisers componentsJoinedByString:@","];
    extras[kBidMachineBlockedApps]          = [self.blockedApps componentsJoinedByString:@","];
    extras[kBidMachineCountry]              = self.country;
    extras[kBidMachineCity]                 = self.city;
    extras[kBidMachineZip]                  = self.zip;
    extras[kBidMachineStoreURL]             = self.storeURL.absoluteString;
    extras[kBidMachineStoreId]              = self.storeId;
    extras[kBidMachinePaid]                 = @(self.paid);
    extras[kBidMachineLatitude]             = @(self.userLatitude);
    extras[kBidMachineLongitude]            = @(self.userLongitude);
    extras[kBidMachineCoppa]                = self.coppa ? @YES : nil;
    extras[kBidMachinePriceFloors]          = self.priceFloors;
    extras[kBidMachineHeaderBiddingConfig]  = self.headerBiddingConfigsJsonArray;
    return extras;
}

- (NSArray *)headerBiddingConfigsJsonArray {
    NSMutableArray *json = [NSMutableArray arrayWithCapacity:self.headerBiddingConfigs.count];
    [self.headerBiddingConfigs enumerateObjectsUsingBlock:^(BMANetworkConfiguration *config, NSUInteger idx, BOOL *stop) {
        [json addObject:config.config];
    }];
    return json;
}

@end
