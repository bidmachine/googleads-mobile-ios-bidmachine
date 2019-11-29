//
//  GADBidMachineUtils+Request.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBidMachineUtils.h"


@interface GADBidMachineUtils (Request)

- (BDMBannerRequest *)bannerRequestWithSize:(BDMBannerAdSize)size
                               requestInfo:(NSDictionary *)requestInfo;
- (BDMInterstitialRequest *)interstitialRequestWithRequestInfo:(NSDictionary *)requestInfo;
- (BDMRewardedRequest *)rewardedRequestWithRequestInfo:(NSDictionary *)requestInfo;
- (BDMNativeAdRequest *)nativeAdRequestWithRequestInfo:(NSDictionary *)requestInfo;
- (BDMUserRestrictions *)userRestrictionsWithRequestInfo:(NSDictionary *)requestInfo;

@end
