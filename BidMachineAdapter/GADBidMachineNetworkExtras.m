//
//  GADBidMachineNetworkExtras.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineNetworkExtras.h"
#import "GADMAdapterBidMachineConstants.h"

@implementation GADBidMachineNetworkExtras

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
    [self.headerBiddingConfigs enumerateObjectsUsingBlock:^(GADBidMachineHeaderBiddingConfig *config, NSUInteger idx, BOOL *stop) {
        [json addObject:config.config];
    }];
    return json;
}

@end
