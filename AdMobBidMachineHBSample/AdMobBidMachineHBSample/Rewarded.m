//
//  Rewarded.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"
#import "BMAUtils.h"
#import "BMANetworkExtras.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "ca-app-pub-3216013768320747/1325926558"
#define EXTRAS_MARK     "BM RV"

@interface Rewarded ()<BDMRequestDelegate, GADRewardedAdDelegate>

@property (nonatomic, strong) GADRewardedAd *rewarded;
@property (nonatomic, strong) BDMRewardedRequest *request;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    self.request = [BDMRewardedRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self.rewarded presentFromRootViewController:self delegate:self];
}

- (GADRewardedAd *)rewarded {
    if (!_rewarded) {
        _rewarded = [[GADRewardedAd alloc] initWithAdUnitID:@UNIT_ID];
    }
    return _rewarded;
}

- (void)makeRewardedRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.rewarded loadRequest:request completionHandler:^(GADRequestError * error) {
        if (error) {
            NSLog(@"Reward video fail to load");
        } else {
            NSLog(@"Reward video ad is received");
        }
    }];
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
    [self makeRewardedRequestWithExtras:extras];
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
