//
//  BidMachineCustomEventRewardedAd.h
//  AdMobBidMachineHBSample
//
//  Created by Ilia Lozhkin on 23.07.2020.
//  Copyright © 2020 Ilia Lozhkin. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BidMachineCustomEventRewardedAd : NSObject <GADMediationRewardedAd>

- (instancetype)initWithConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                    completionHandler: (GADMediationRewardedLoadCompletionHandler)completionHandler;

- (void)loadRewardedVideo;

@end
