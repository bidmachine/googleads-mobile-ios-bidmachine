//
//  Native.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Native.h"
#import "BMAUtils.h"
#import "BMANetworkExtras.h"
#import "NativeAdRenderer.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "ca-app-pub-3216013768320747/7699763218"
#define EXTRAS_MARK     "Native test"

@interface Native ()<BDMRequestDelegate, GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate>

@property (nonatomic, strong) GADAdLoader *nativeLoader;
@property (nonatomic, strong) GADUnifiedNativeAd *nativeAd;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, strong) BDMNativeAdRequest *request;

@end

@implementation Native

- (void)loadAd:(id)sender {
    self.request = [BDMNativeAdRequest new];
    [self.request performWithDelegate:self];
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

- (void)makeNativeRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.nativeLoader loadRequest:request];
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
    [self makeNativeRequestWithExtras:extras];
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
