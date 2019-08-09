//
//  GADBidMachineUtils+Request.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils+Request.h"
#import "GADMAdapterBidMachineConstants.h"
#import "GADBidMachineTransformer.h"

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BidMachine/BidMachine.h>


@implementation GADBidMachineUtils (Request)

- (BDMBannerRequest *)bannerRequestWithSize:(BDMBannerAdSize)size
                                requestInfo:(NSDictionary *)requestInfo {
    BDMBannerRequest *bannerRequest = [BDMBannerRequest new];
    bannerRequest.adSize = size;
    [self configureRequest:bannerRequest info:requestInfo];
    return bannerRequest;
}

- (BDMInterstitialRequest *)interstitialRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMInterstitialRequest *interstitialRequest = [BDMInterstitialRequest new];
    [self configureRequest:interstitialRequest info:requestInfo];
    BDMFullscreenAdType type = [GADBidMachineTransformer adTypeFromString:requestInfo[kBidMachineAdContentType]];
    [interstitialRequest setType:type];
    return interstitialRequest;
}

- (BDMRewardedRequest *)rewardedRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMRewardedRequest *rewardedRequest = [BDMRewardedRequest new];
    [self configureRequest:rewardedRequest info:requestInfo];
    return rewardedRequest;
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

- (void)configureRequest:(BDMRequest *)request info:(NSDictionary *)info {
    CLLocation *location = nil;
    if (info[kBidMachineLatitude] && info[kBidMachineLongitude]) {
        location = [[CLLocation alloc] initWithLatitude:[info[kBidMachineLatitude] doubleValue]
                                              longitude:[info[kBidMachineLongitude] doubleValue]];
    }
    
    BDMUserRestrictions *restrictions = [self userRestrictionsWithRequestInfo:info];
    [BDMSdk.sharedSdk setRestrictions:restrictions];
    
    request.targeting = [GADBidMachineUtils.sharedUtils targetingWithRequestInfo:info location:location];
    NSArray <BDMPriceFloor *> *pricefloors = [GADBidMachineTransformer priceFloorsFromArray:info[kBidMachinePriceFloors]];
    request.priceFloors = pricefloors ?: request.priceFloors;
}

@end
