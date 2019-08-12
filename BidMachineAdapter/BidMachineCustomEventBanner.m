//
//  BidMachineCustomEventBanner.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventBanner.h"
#import "GADBidMachineUtils+Request.h"
#import "GADBidMachineTransformer.h"

#import <BidMachine/BidMachine.h>


@interface BidMachineCustomEventBanner () <BDMBannerDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;

@end


@implementation BidMachineCustomEventBanner

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request {
    NSDictionary *requestInfo = [GADBidMachineUtils.sharedUtils requestInfoFrom:serverParameter
                                                                        request:request];
    __weak typeof(self) weakSelf = self;
    [GADBidMachineUtils.sharedUtils initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
        BDMBannerAdSize size = [GADBidMachineTransformer adSizeFromGADAdSize:adSize];
        BDMBannerRequest *request = [GADBidMachineUtils.sharedUtils bannerRequestWithSize:size
                                                                              requestInfo:requestInfo];
        [weakSelf.bannerView setFrame:CGRectMake(0, 0, adSize.size.width, adSize.size.height)];
        [weakSelf.bannerView populateWithRequest:request];
    }];
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
