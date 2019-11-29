//
//  Native.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Native.h"
#import "NativeAdRenderer.h"
#import "GADBidMachineNetworkExtras.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "ca-app-pub-7058320987613523/2130992051"
#define EXTRAS_MARK     "BM Native"

@interface Native ()<GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate>

@property (nonatomic, strong) GADAdLoader *nativeLoader;
@property (nonatomic, strong) GADUnifiedNativeAd *nativeAd;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Native

- (void)loadAd:(id)sender {
    [self.nativeLoader loadRequest:self.request];
}

- (void)showAd:(id)sender {
    self.nativeAd.delegate = self;
    self.nativeAd.rootViewController = self;
    [NativeAdRenderer renderAd:self.nativeAd onView:self.container];
}

- (GADAdLoader *)nativeLoader {
    if (!_nativeLoader) {
        _nativeLoader = [[GADAdLoader alloc] initWithAdUnitID:@UNIT_ID
                                           rootViewController:self
                                                      adTypes:@[kGADAdLoaderAdTypeUnifiedNative]
                                                      options:@[self.viewOptions, self.videoOptions, self.mediaOptions]];
        _nativeLoader.delegate = self;
    }
    return _nativeLoader;
}

- (GADAdLoaderOptions *)videoOptions {
    GADVideoOptions *options = GADVideoOptions.new;
    options.startMuted = YES;
    return options;
}

- (GADAdLoaderOptions *)mediaOptions {
    GADNativeAdMediaAdLoaderOptions *options = GADNativeAdMediaAdLoaderOptions.new;
    options.mediaAspectRatio = GADMediaAspectRatioLandscape;
    return options;
}

- (GADAdLoaderOptions *)viewOptions {
    GADNativeAdViewAdOptions *options = GADNativeAdViewAdOptions.new;
    options.preferredAdChoicesPosition = GADAdChoicesPositionTopRightCorner;
    return options;
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

#pragma mark - GADUnifiedNativeAdLoaderDelegate

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSLog(@"Native ad fail to load");
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
}

- (void)nativeAdDidRecordImpression:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"Native ad log impression");
}

- (void)nativeAdDidRecordClick:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"Native ad did click");
}

@end
