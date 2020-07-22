//
//  BMAFactory+BMRequest.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory.h"
#import <BidMachine/BidMachine.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAFactory (BMRequest)

- (BDMBannerRequest *)bannerRequestWithSize:(BDMBannerAdSize)size requestInfo:(NSDictionary *)requestInfo;
- (BDMInterstitialRequest *)interstitialRequestWithRequestInfo:(NSDictionary *)requestInfo;
- (BDMRewardedRequest *)rewardedRequestWithRequestInfo:(NSDictionary *)requestInfo;
- (BDMNativeAdRequest *)nativeAdRequestWithRequestInfo:(NSDictionary *)requestInfo;

@end

NS_ASSUME_NONNULL_END
