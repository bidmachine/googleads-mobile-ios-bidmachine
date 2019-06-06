//
//  ViewController.m
//  AdMobBidMachineSample
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "ViewController.h"
#import "GADBidMachineNetworkExtras.h"
#import <BidMachine/BidMachine.h>
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
    // You can use test ad unit id - @"ca-app-pub-1405929557079197/8789988225" - to test interstitial ad.
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"YOUR_AD_UNIT_ID"];
    
    self.bannerView.delegate = self;
    self.rewarded.delegate = self;
    self.interstitial.delegate = self;
    
    [self addBannerViewToView:self.bannerView];
    // You can use test ad unit id - @"ca-app-pub-1405929557079197/7727940578" - to test banner ad.
    self.bannerView.adUnitID = @"YOUR_AD_UNIT_ID";
    self.bannerView.rootViewController = self;

}

- (IBAction)openTestSuite:(UIButton *)sender {
    // You can use test application id - @"ca-app-pub-1405929557079197~9998880699" - to test ad.
    NSString *appID = @"YOUR_APPLICATION_ID";
    [GoogleMobileAdsMediationTestSuite presentWithAppID:appID
                                       onViewController:self
                                               delegate:nil];
}

- (IBAction)loadBanner:(id)sender {
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

- (IBAction)loadInterstitial:(id)sender {
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
}

- (IBAction)showInterstitial:(id)sender {
    [self.interstitial presentFromRootViewController:self];
}

- (IBAction)loadRewarded:(id)sender {
    GADRequest *request = [GADRequest request];
    // You can use test ad unit id - @"ca-app-pub-1405929557079197/1031272924" - to test rewarded ad.
    [self.rewarded loadRequest:request withAdUnitID:@"YOUR_AD_UNIT_ID"];
}

- (IBAction)showRewarded:(id)sender {
    [self.rewarded presentFromRootViewController:self];
}


- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view.safeAreaLayoutGuide
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

#pragma mark - BannerView delegate

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

#pragma mark - Interstitial delegate

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

#pragma mark - Rewarded Video delegate

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
