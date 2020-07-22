//
//  Rewarded.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"
#import "BMANetworkExtras.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "ca-app-pub-1405929557079197/1031272924"
#define EXTRAS_MARK     "BM RV"

@interface Rewarded ()<GADRewardedAdDelegate>

@property (nonatomic, strong) GADRewardedAd *rewarded;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self.rewarded loadRequest:self.request completionHandler:^(GADRequestError * error) {
        if (error) {
            NSLog(@"Reward video fail to load");
        } else {
            NSLog(@"Reward video ad is received");
        }
    }];
}

- (void)showAd:(id)sender {
    [self.rewarded presentFromRootViewController:sender delegate:self];
}

- (GADRewardedAd *)rewarded {
    if (!_rewarded) {
        _rewarded = [[GADRewardedAd alloc] initWithAdUnitID:@UNIT_ID];
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

- (BMANetworkExtras *)extras {
    BMANetworkExtras *extras = [BMANetworkExtras new];
    /// Pass additional params here
    //    extras.baseURL = [NSURL URLWithString:@"https://some.url.com"];
        extras.testMode = YES;
        extras.sellerId = @"5";
        extras.loggingEnabled = true;
    //
    /// Sample of Header Bidding configs
    /// For supported ad networks
    //    BMANetworkConfiguration *vungle = [BMANetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"vungle");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMVungleAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialUnknown, @{ @"placement_id" : @"95298PL39048" });
    //        builder.appendInitializationParams(@{ @"app_id": @"5a35a75845eaab51250070a5"} );
    //    }];
    //    BMANetworkConfiguration *myTarget = [BMANetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"my_target");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMMyTargetAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatBanner320x50, @{ @"slot_id" : @"298979" });
    //    }];
    //    BMANetworkConfiguration *facebook = [BMANetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"facebook");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMFacebookAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInLineBanner, @{ @"facebook_key" : @"1419966511382477_2249153695130417" });
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialStatic, @{ @"facebook_key" : @"754722298026822_1251166031715777" });
    //        builder.appendInitializationParams(@{ @"app_id": @"754722298026822", @"placement_ids": @[@"754722298026822_1251166031715777", @"1419966511382477_2249153695130417"]} );
    //    }];
    //    BMANetworkConfiguration *tapjoy = [BMANetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"tapjoy");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMTapjoyAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialVideo, @{ @"placement_name" : @"video_without_cap_pb" });
    //        builder.appendInitializationParams(@{ @"sdk_key": @"6gwG-HstT_aLMpZXUXlhNgEBja6Q5bq7i4GtdFMJoarOufnp36PaVlG2OBmw"} );
    //    }];
    //    BMANetworkConfiguration *adcolony = [BMANetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
    //        builder.appendName(@"adcolony");
    //        builder.appendNetworkClass(NSClassFromString(@"BDMAdColonyAdNetwork"));
    //        builder.appendAdUnit(BDMAdUnitFormatInterstitialVideo, @{ @"zone_id" : @"vz7fdef471647c416682" });
    //        builder.appendAdUnit(BDMAdUnitFormatRewardedVideo, @{ @"zone_id" : @"vzf07cd496be04483cad" });
    //        builder.appendInitializationParams(@{ @"app_id": @"app327320f8ced14e61b2", @"zones": @[@"vzf07cd496be04483cad", @"vz7fdef471647c416682"]} );
    //    }];
    //    extras.headerBiddingConfigs = @[vungle, myTarget, facebook, tapjoy, adcolony];
    return extras;
}

#pragma mark - GADRewardedAdDelegate

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
 userDidEarnReward:(nonnull GADAdReward *)reward {
    NSLog(@"Reward received with currency %@ , amount %lf", reward.type, [reward.amount doubleValue]);
}

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
didFailToPresentWithError:(nonnull NSError *)error {
    NSLog(@"Reward video ad failed to present.");
}

- (void)rewardedAdDidPresent:(nonnull GADRewardedAd *)rewardedAd {
    NSLog(@"Opened reward video ad.");
}

- (void)rewardedAdDidDismiss:(nonnull GADRewardedAd *)rewardedAd {
    NSLog(@"Reward video ad is closed.");
}

@end
