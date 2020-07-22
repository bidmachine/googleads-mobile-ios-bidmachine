//
//  BMAFactory+BMTargeting.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory+BMTargeting.h"
#import "BMAConstants.h"

@implementation BMAFactory (BMTargeting)

- (BDMTargeting *)targetingWithRequestInfo:(NSDictionary *)requestInfo
                                  location:(CLLocation *)location {
    BDMTargeting *targeting = [BDMTargeting new];
    // Location
    if (location) {
        [targeting setDeviceLocation:location];
    }
    
    // Request info
    if (requestInfo.count) {
        targeting.userId                = requestInfo[kBidMachineUserId] ?: targeting.userId;
        targeting.gender                = requestInfo[kBidMachineGender] ?: targeting.gender;
        targeting.yearOfBirth           = requestInfo[kBidMachineYearOfBirth] ?: targeting.yearOfBirth;
        targeting.keywords              = requestInfo[kBidMachineKeywords] ?: targeting.keywords;
        targeting.blockedCategories     = [requestInfo[kBidMachineBlockedCategories] componentsSeparatedByString:@","] ?: targeting.blockedCategories;
        targeting.blockedAdvertisers    = [requestInfo[kBidMachineBlockedAdvertisers] componentsSeparatedByString:@","] ?: targeting.blockedAdvertisers;
        targeting.blockedApps           = [requestInfo[kBidMachineBlockedApps] componentsSeparatedByString:@","] ?: targeting.blockedApps;
        targeting.country               = requestInfo[kBidMachineCountry] ?: targeting.country;
        targeting.city                  = requestInfo[kBidMachineCity] ?: targeting.city;
        targeting.zip                   = requestInfo[kBidMachineZip] ?: targeting.zip;
        targeting.storeURL              = requestInfo[kBidMachineStoreURL] ? [NSURL URLWithString:requestInfo[kBidMachineStoreURL]] : targeting.storeURL;
        targeting.storeId               = requestInfo[kBidMachineStoreId] ?: targeting.storeId;
        targeting.paid                  = requestInfo[kBidMachinePaid] ? [requestInfo[kBidMachinePaid] boolValue] : targeting.paid;
    }
    
    return targeting;
}


- (BDMUserRestrictions *)userRestrictionsWithRequestInfo:(NSDictionary *)requestInfo {
    BDMUserRestrictions *restrictions = [BDMUserRestrictions new];
    [restrictions setHasConsent:[requestInfo[kBidMachineHasConsent] boolValue]];
    [restrictions setSubjectToGDPR:[requestInfo[kBidMachineSubjectToGDPR] boolValue]];
    [restrictions setCoppa:[requestInfo[kBidMachineCoppa] boolValue]];
    [restrictions setConsentString:requestInfo[kBidMachineConsentString]];
    [BDMSdk.sharedSdk setEnableLogging:[requestInfo[kBidMachineLoggingEnabled] boolValue]];
    return restrictions;
}

@end
