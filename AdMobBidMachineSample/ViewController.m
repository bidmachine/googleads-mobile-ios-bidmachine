//
//  ViewController.m
//  AdMobBidMachineSample
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "ViewController.h"
#import "GADBidMachineNetworkExtras.h"
#import "BidMachineCustomEventBanner.h"

#import <GoogleMobileAds/GoogleMobileAds.h>


@import GoogleMobileAdsMediationTestSuite;

@interface ViewController () <GADBannerViewDelegate, GADRewardBasedVideoAdDelegate, GADInterstitialDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADRewardBasedVideoAd *rewarded;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UIButton *showInterstitialButton;
@property (weak, nonatomic) IBOutlet UIButton *showRewardedButton;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.showInterstitialButton setEnabled:NO];
    [self.showRewardedButton setEnabled:NO];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.rewarded = [[GADRewardBasedVideoAd alloc] init];
    /// You can use test ad unit id - @"ca-app-pub-1405929557079197/8789988225" - to test interstitial ad.
//    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-1405929557079197/8789988225"];
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"YOUR_AD_UNIT_ID"];
    
    self.bannerView.delegate = self;
    self.rewarded.delegate = self;
    self.interstitial.delegate = self;
    
    [self addBannerViewToView:self.bannerView];
    /// You can use test ad unit id - @"ca-app-pub-1405929557079197/7727940578" - to test banner ad.
//    self.bannerView.adUnitID = @"ca-app-pub-1405929557079197/7727940578";
    self.bannerView.adUnitID = @"YOUR_AD_UNIT_ID";
    self.bannerView.rootViewController = self;
    
}

- (IBAction)openTestSuite:(UIButton *)sender {
    /// You can use test application id - @"ca-app-pub-1405929557079197~9998880699" - to test ad.
    //    NSString *appID = @"ca-app-pub-1405929557079197~9998880699";
    NSString *appID = @"YOUR_APPLICATION_ID";
    [GoogleMobileAdsMediationTestSuite presentWithAppID:appID
                                       onViewController:self
                                               delegate:nil];
}

- (IBAction)loadBanner:(id)sender {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:self.extras.allExtras forLabel:@"BidMachine banner ios"];
    [request registerAdNetworkExtras:extras];
    [self.bannerView loadRequest:request];
}

- (IBAction)loadInterstitial:(id)sender {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:self.extras.allExtras forLabel:@"BM interstitial"];
    [request registerAdNetworkExtras:extras];
    
    [self.interstitial loadRequest:request];
}

- (IBAction)showInterstitial:(id)sender {
    [self.interstitial presentFromRootViewController:self];
}

- (IBAction)loadRewarded:(id)sender {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:self.extras.allExtras forLabel:@"BM RV"];
    [request registerAdNetworkExtras:extras];
    /// You can use test ad unit id - @"ca-app-pub-1405929557079197/1031272924" - to test rewarded ad.
//    [self.rewarded loadRequest:request withAdUnitID:@"ca-app-pub-1405929557079197/1031272924"];
    [self.rewarded loadRequest:request withAdUnitID:@"YOUR_AD_UNIT_ID"];
}

- (IBAction)showRewarded:(id)sender {
    [self.rewarded presentFromRootViewController:self];
}


- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    if (@available(iOS 11, *)) {
        [NSLayoutConstraint activateConstraints:@[
                                                  [bannerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                                  [bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
                                                  ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
                                                  [bannerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                                  [bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
                                                  ]];
    }
}

#pragma mark - Extras

- (GADBidMachineNetworkExtras *)extras {
    GADBidMachineNetworkExtras *extras = [GADBidMachineNetworkExtras new];
    /// Pass additional params here
    //    extras.baseURL = [NSURL URLWithString:@"https://some.url.com"];
    //    extras.testMode = false;
    //    extras.sellerId = @"999";
    //    extras.loggingEnabled = true;
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

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"adViewDidReceiveAdWithNetworkClassName: %@", bannerView.adNetworkClassName);
}

- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAdWithNetworkClassName: %@", ad.adNetworkClassName);
    [self.showInterstitialButton setEnabled:YES];
}

- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
    [self.showInterstitialButton setEnabled:NO];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}

#pragma mark - GADRewardBasedVideoAdDelegate

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"Reward received with currency %@ , amount %lf", reward.type, [reward.amount doubleValue]);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received with network class name: %@.", rewardBasedVideoAd.adNetworkClassName);
    [self.showRewardedButton setEnabled:YES];
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
    [self.showRewardedButton setEnabled:NO];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.");
}

@end
