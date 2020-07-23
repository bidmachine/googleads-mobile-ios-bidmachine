//
//  Banner.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"
#import "BMAUtils.h"
#import "BMANetworkExtras.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "ca-app-pub-3216013768320747/5715655753"
#define EXTRAS_MARK     "BidMachine banner ios"

@interface Banner ()<BDMRequestDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) BDMBannerRequest *request;
@property (nonatomic, strong) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    self.request = [BDMBannerRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self addBannerInContainer];
}

- (void)makeBannerRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.bannerView loadRequest:request];
}

- (void)addBannerInContainer {
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.container addSubview:self.bannerView];
}

#pragma mark - lazy

- (GADBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _bannerView.delegate = self;
        _bannerView.adUnitID = @UNIT_ID;
        _bannerView.rootViewController = self;
        _bannerView.translatesAutoresizingMaskIntoConstraints = YES;
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _bannerView;
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // rouned price
    if (info.price.doubleValue <= 1) {
        [BMAUtils.shared.fetcher setFormat:@"0.2"];
     } else {
         [BMAUtils.shared.fetcher setFormat:@"1000.0"];
     }
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BMAUtils.shared.fetcher fetchParamsFromRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeBannerRequestWithExtras:extras];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
}

- (void)requestDidExpire:(BDMRequest *)request {
    // In case request expired we can release it
    // and build some retry logic
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"adViewDidReceiveAdWithNetworkClassName: %@", bannerView.responseInfo.adNetworkClassName);
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

@end
