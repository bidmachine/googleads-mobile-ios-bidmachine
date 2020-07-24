//
//  BidMachineCustomEventBanner.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventBanner.h"
#import "BMAFactory+BMRequest.h"
#import "BMAFactory+RequestInfo.h"
#import "BMATransformer.h"
#import "BMAConstants.h"
#import "BMAUtils.h"
#import "BMAError.h"

#import <BidMachine/BidMachine.h>
#import <StackFoundation/StackFoundation.h>

@interface BidMachineCustomEventBanner () <BDMBannerDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;

@end


@implementation BidMachineCustomEventBanner

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request
{
    
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFrom:serverParameter request:request];
    BDMBannerAdSize size = [BMATransformer adSizeFromGADAdSize:adSize];
    NSString *price = ANY(requestInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BMAUtils.shared.fetcher isPrebidRequestsForType:BMAAdTypeBanner];
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BMAUtils.shared.fetcher requestForPrice:price type:BMAAdTypeBanner];
        if ([auctionRequest isKindOfClass:BDMBannerRequest.self]) {
            [self populate:(BDMBannerRequest *)auctionRequest adSize:size];
        } else {
            BMAError *error = [BMAError errorWithDescription:@"Bidmachine can't fint prebid request"];
            [self.delegate customEventBanner:self didFailAd:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
            BDMBannerRequest *auctionRequest = [[BMAFactory sharedFactory] bannerRequestWithSize:size requestInfo:requestInfo];
            [weakSelf populate:auctionRequest adSize:size];
        }];
    }
}

- (void)populate:(BDMBannerRequest *)request adSize:(BDMBannerAdSize)adSize {
    // Transform size 2 times to avoid fluid sizes with 0 width
    [self.bannerView setFrame:(CGRect){.size = CGSizeFromBDMSize(adSize)}];
    [self.bannerView populateWithRequest:request];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
        _bannerView.rootViewController = self.delegate.viewControllerForPresentingModalView;
        _bannerView.delegate = self;
        _bannerView.producerDelegate = self;
    }
    return _bannerView;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(BDMBannerView *)bannerView {
    [self.delegate customEventBanner:self didReceiveAd:bannerView];
}

- (void)bannerView:(BDMBannerView *)bannerView failedWithError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)bannerViewRecieveUserInteraction:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWasClicked:self];
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWillPresentModal:self];
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerDidDismissModal:self];
}

#pragma mark - BDMAdEventProducerDelegate

// Currently noop
- (void)didProduceImpression:(id<BDMAdEventProducer>)producer {}
- (void)didProduceUserAction:(id<BDMAdEventProducer>)producer {}

@end
