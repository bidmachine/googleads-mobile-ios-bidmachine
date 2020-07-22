//
//  BMAFactory+BMRequest.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory+BMRequest.h"
#import "BMAConstants.h"
#import "BMATransformer.h"
#import "BMAFactory+BMTargeting.h"

@implementation BMAFactory (BMRequest)

- (BDMBannerRequest *)bannerRequestWithSize:(BDMBannerAdSize)size requestInfo:(NSDictionary *)requestInfo {
    BDMBannerRequest *request = [BDMBannerRequest new];
    request.adSize = size;
    [self configureRequest:request info:requestInfo];
    return request;
}

- (BDMInterstitialRequest *)interstitialRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMInterstitialRequest *request = [BDMInterstitialRequest new];
    [self configureRequest:request info:requestInfo];
    BDMFullscreenAdType type = [BMATransformer adTypeFromString:requestInfo[kBidMachineAdContentType]];
    [request setType:type];
    return request;
}

- (BDMRewardedRequest *)rewardedRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMRewardedRequest *rewardedRequest = [BDMRewardedRequest new];
    [self configureRequest:rewardedRequest info:requestInfo];
    return rewardedRequest;
}

- (BDMNativeAdRequest *)nativeAdRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMNativeAdRequest *nativeAdRequest = [BDMNativeAdRequest new];
    [self configureRequest:nativeAdRequest info:requestInfo];
    return nativeAdRequest;
}

- (void)configureRequest:(BDMRequest *)request info:(NSDictionary *)info {
    CLLocation *location = nil;
    if (info[kBidMachineLatitude] && info[kBidMachineLongitude]) {
        location = [[CLLocation alloc] initWithLatitude:[info[kBidMachineLatitude] doubleValue]
                                              longitude:[info[kBidMachineLongitude] doubleValue]];
    }
    
    BDMUserRestrictions *restrictions = [[BMAFactory sharedFactory] userRestrictionsWithRequestInfo:info];
    [BDMSdk.sharedSdk setRestrictions:restrictions];
    
    request.targeting = [[BMAFactory sharedFactory] targetingWithRequestInfo:info location:location];
    NSArray <BDMPriceFloor *> *pricefloors = [BMATransformer priceFloorsFromArray:info[kBidMachinePriceFloors]];
    request.priceFloors = pricefloors ?: request.priceFloors;
}

@end
