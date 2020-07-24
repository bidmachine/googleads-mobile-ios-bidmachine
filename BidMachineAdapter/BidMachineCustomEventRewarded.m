//
//  GADMBidMachineRewardedAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BMATransformer.h"
#import "BMANetworkExtras.h"
#import "BidMachineCustomEventRewarded.h"
#import "BidMachineCustomEventRewardedAd.h"


@interface BidMachineCustomEventRewarded () {
  BidMachineCustomEventRewardedAd *_rewardedAd;
}

@end


@implementation BidMachineCustomEventRewarded

+ (GADVersionNumber)adSDKVersion {
    return [BMATransformer versionFromBidMachineString:@"1.5.0.1"];
}

+ (GADVersionNumber)version {
    return [BMATransformer versionFromBidMachineString:@"1.5.0.1"];
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return BMANetworkExtras.class;
}

+ (void)setUpWithConfiguration:(nonnull GADMediationServerConfiguration *)configuration
             completionHandler:(nonnull GADMediationAdapterSetUpCompletionBlock)completionHandler {
    completionHandler(nil);
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    _rewardedAd = [[BidMachineCustomEventRewardedAd alloc] initWithConfiguration:adConfiguration completionHandler:completionHandler];
    [_rewardedAd loadRewardedVideo];
}

@end
