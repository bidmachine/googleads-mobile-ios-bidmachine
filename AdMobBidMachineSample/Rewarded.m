//
//  Rewarded.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"
#import "GADBidMachineNetworkExtras.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "ca-app-pub-1405929557079197/1031272924"
#define EXTRAS_MARK     "BM RV"

@interface Rewarded ()<GADRewardBasedVideoAdDelegate>

@property (nonatomic, strong) GADRewardBasedVideoAd *rewarded;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self.rewarded loadRequest:self.request withAdUnitID:@UNIT_ID];
}

- (void)showAd:(id)sender {
    [self.rewarded presentFromRootViewController:self];
}

- (GADRewardBasedVideoAd *)rewarded {
    if (!_rewarded) {
        _rewarded = [[GADRewardBasedVideoAd alloc] init];
        _rewarded.delegate = self;
    }
    return _rewarded;
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:self.extras.allExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    return request;
}

#pragma mark - Extras

- (GADBidMachineNetworkExtras *)extras {
    GADBidMachineNetworkExtras *extras = [GADBidMachineNetworkExtras new];
    /// Pass additional params here
    //    extras.baseURL = [NSURL URLWithString:@"https://some.url.com"];
        extras.testMode = YES;
        extras.sellerId = @"5";
        extras.loggingEnabled = true;
    //
    /// Sample of Header Bidding configs
    /// For supported ad networks
    //    GADBidMachineHeaderBiddingConfig *vungle = [GADBidMachineHeaderBiddingConfig buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"vungle");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMVungleAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialUnknown, @{ @"placement_id" : @"95298PL39048" });
    //        builder.appendInitializationParams(@{ @"app_id": @"5a35a75845eaab51250070a5"} );
    //    }];
    //    GADBidMachineHeaderBiddingConfig *myTarget = [GADBidMachineHeaderBiddingConfig buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"my_target");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMMyTargetAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatBanner320x50, @{ @"slot_id" : @"298979" });
    //    }];
    //    GADBidMachineHeaderBiddingConfig *facebook = [GADBidMachineHeaderBiddingConfig buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"facebook");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMFacebookAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInLineBanner, @{ @"facebook_key" : @"1419966511382477_2249153695130417" });
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialStatic, @{ @"facebook_key" : @"754722298026822_1251166031715777" });
    //        builder.appendInitializationParams(@{ @"app_id": @"754722298026822", @"placement_ids": @[@"754722298026822_1251166031715777", @"1419966511382477_2249153695130417"]} );
    //    }];
    //    GADBidMachineHeaderBiddingConfig *tapjoy = [GADBidMachineHeaderBiddingConfig buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"tapjoy");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMTapjoyAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialVideo, @{ @"placement_name" : @"video_without_cap_pb" });
    //        builder.appendInitializationParams(@{ @"sdk_key": @"6gwG-HstT_aLMpZXUXlhNgEBja6Q5bq7i4GtdFMJoarOufnp36PaVlG2OBmw"} );
    //    }];
    //    GADBidMachineHeaderBiddingConfig *adcolony = [GADBidMachineHeaderBiddingConfig buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"adcolony");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMAdColonyAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialVideo, @{ @"zone_id" : @"vz7fdef471647c416682" });
    //        builder.appendAdUnit(BDMAdUnitFormatRewardedVideo, @{ @"zone_id" : @"vzf07cd496be04483cad" });
    //        builder.appendInitializationParams(@{ @"app_id": @"app327320f8ced14e61b2", @"zones": @[@"vzf07cd496be04483cad", @"vz7fdef471647c416682"]} );
    //    }];
    //    extras.headerBiddingConfigs = @[vungle, myTarget, facebook, tapjoy, adcolony];
    return extras;
}

#pragma mark - GADRewardBasedVideoAdDelegate

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"Reward received with currency %@ , amount %lf", reward.type, [reward.amount doubleValue]);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received with network class name: %@.", rewardBasedVideoAd.adNetworkClassName);
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad has completed.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.");
}

@end
