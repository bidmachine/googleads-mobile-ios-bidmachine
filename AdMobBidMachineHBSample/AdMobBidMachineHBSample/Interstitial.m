//
//  Interstitial.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"
#import "BMAUtils.h"
#import "BMANetworkExtras.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


#define UNIT_ID         "ca-app-pub-3216013768320747/4019430704"
#define EXTRAS_MARK     "BM interstitial"

@interface Interstitial ()<BDMRequestDelegate, GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) BDMInterstitialRequest *request;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    self.request = [BDMInterstitialRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self.interstitial presentFromRootViewController:self];
}

- (GADInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [[GADInterstitial alloc] initWithAdUnitID:@UNIT_ID];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (void)makeInterstitialRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.interstitial loadRequest:request];
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
    [self makeInterstitialRequestWithExtras:extras];
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

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAdWithNetworkClassName: %@", ad.responseInfo.adNetworkClassName);
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
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}

@end
