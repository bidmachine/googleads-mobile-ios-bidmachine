//
//  GADBidMachineUtils.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils.h"
#import "GADBidMachineUtils+Request.h"
#import "GADMAdapterBidMachineConstants.h"
#import "GADBidMachineNetworkExtras.h"
#import "GADBidMachineTransformer.h"
#import "GADBidMachineHeaderBiddingConfig.h"

#import <BidMachine/BDMSdkConfiguration+HeaderBidding.h>


NSString *const kGADBidMachineErrorDomain = @"com.google.mediation.bidmachine";


@interface GADBidMachineUtils ()

@end


@implementation GADBidMachineUtils

+ (instancetype)sharedUtils {
    static GADBidMachineUtils * _sharedUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = GADBidMachineUtils.new;
    });
    return _sharedUtils;
}

- (void)initializeBidMachineWithRequestInfo:(NSDictionary *)requestInfo
                                 completion:(void(^)(NSError *))completion {
    // Sync logging
    [BDMSdk.sharedSdk setEnableLogging:[requestInfo[kBidMachineLoggingEnabled] boolValue]];
    // Check seller id
    NSString *sellerID = [GADBidMachineTransformer sellerIdFromValue:requestInfo[kBidMachineSellerId]];
    if (!sellerID) {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : @"BidMachine's initialization skipped",
                                   NSLocalizedFailureReasonErrorKey: @"The seller id is empty or has an incorrect type"
                                   };
        NSError *error = [NSError errorWithDomain:kGADBidMachineErrorDomain
                                             code:0
                                         userInfo:userInfo];
        completion ? completion(error) : nil;
        return;
    }
    // Sync restictions
    BDMUserRestrictions *restrictions = [self userRestrictionsWithRequestInfo:requestInfo];
    [BDMSdk.sharedSdk setRestrictions:restrictions];
    // Get config
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = [requestInfo[kBidMachineTestMode] boolValue];
    config.baseURL = [self transformEndpointURL:requestInfo[@"endpoint"]];
    config.networkConfigurations = [self headerBiddingConfigurationFromRequestInfo:requestInfo];
    // Start session
    [BDMSdk.sharedSdk startSessionWithSellerID:sellerID
                                 configuration:config
                                    completion:^{
                                        completion ? completion(nil) : nil;
                                    }];
}

- (NSDictionary *)requestInfoFrom:(NSString *)string
                          request:(GADCustomEventRequest *)request {
    // Get data from request
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    if (request.additionalParameters) {
        [requestInfo addEntriesFromDictionary:request.additionalParameters];
    }
    // Get data from serialized string
    NSDictionary *deserializedInfo = [self deserializedString:string];
    if (deserializedInfo.count) {
        [requestInfo addEntriesFromDictionary:deserializedInfo];
    }
    // Get user location info
    if (request.userHasLocation) {
        requestInfo[kBidMachineLatitude] = @(request.userLatitude);
        requestInfo[kBidMachineLongitude] = @(request.userLongitude);
    }
    return requestInfo;
}

- (NSDictionary *)deserializedString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *requestInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return requestInfo;
}

- (NSDictionary *)requestInfoFromConnector:(id<GADMAdNetworkConnector>)connector {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    NSString *parameters = [connector.credentials valueForKey:@"parameter"];
    // Test mode
    if (connector.testMode) {
        requestInfo[kBidMachineTestMode] = @YES;
    }
    // COPPA
    if (connector.childDirectedTreatment) {
        requestInfo[kBidMachineCoppa] = @YES;
    }
    // Network extrass
    if ([connector.networkExtras isKindOfClass:GADBidMachineNetworkExtras.class]) {
        NSDictionary *networkExtras = [(GADBidMachineNetworkExtras *)connector.networkExtras allExtras];
        [requestInfo addEntriesFromDictionary:networkExtras];
    }
    // Credentials
    if (connector.credentials && parameters) {
        NSDictionary *params = [self deserializedString:parameters];
        if (params) {
            [requestInfo addEntriesFromDictionary:params];
        }
    }
    // Seller ID
    requestInfo[kBidMachineSellerId] = [GADBidMachineTransformer sellerIdFromValue:requestInfo[kBidMachineSellerId]];
    return requestInfo;
}

- (NSArray <BDMAdNetworkConfiguration *> *)headerBiddingConfigurationFromRequestInfo:(NSDictionary *)requestInfo {
    NSArray *headerBiddingConfigs = requestInfo[kBidMachineHeaderBiddingConfig];
    NSMutableArray <BDMAdNetworkConfiguration *> *adNetworksConfigs = [NSMutableArray arrayWithCapacity:headerBiddingConfigs.count];
    if ([headerBiddingConfigs isKindOfClass:NSArray.class]) {
        [headerBiddingConfigs enumerateObjectsUsingBlock:^(NSDictionary *headerBiddingConfig, NSUInteger idx, BOOL *stop) {
            if ([headerBiddingConfig isKindOfClass:NSDictionary.class]) {
                GADBidMachineHeaderBiddingConfig *networkConfig = [GADBidMachineHeaderBiddingConfig configFromDictionary:headerBiddingConfig];
                if (networkConfig) {
                    [adNetworksConfigs addObject:networkConfig];
                }
            }
        }];
    }
    return adNetworksConfigs;
}

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

- (NSURL *)transformEndpointURL:(id)endpoint {
    NSURL *endpointURL;
    if ([endpoint isKindOfClass:NSURL.class]) {
        endpointURL = endpoint;
    } else if ([endpoint isKindOfClass:NSString.class]) {
        endpointURL = [NSURL URLWithString:endpoint];
    }
    return endpointURL;
}

@end
