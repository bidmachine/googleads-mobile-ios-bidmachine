//
//  BidMachineCustomEventInterstitial.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventInterstitial.h"
#import "BMAFactory+BMRequest.h"
#import "BMAFactory+RequestInfo.h"
#import "BMATransformer.h"
#import "BMAConstants.h"
#import "BMAUtils.h"
#import "BMAError.h"

#import <BidMachine/BidMachine.h>
#import <StackFoundation/StackFoundation.h>


@interface BidMachineCustomEventInterstitial () <BDMInterstitialDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;

@end


@implementation BidMachineCustomEventInterstitial

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)request
{
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFrom:serverParameter request:request];
    NSString *price = ANY(requestInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BMAUtils.shared.fetcher isPrebidRequestsForType:BMAAdTypeInterstitial];
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BMAUtils.shared.fetcher requestForPrice:price type:BMAAdTypeInterstitial];
        if ([auctionRequest isKindOfClass:BDMInterstitialRequest.self]) {
            [self.interstitial populateWithRequest: (BDMInterstitialRequest *)auctionRequest];
        } else {
            BMAError *error = [BMAError errorWithDescription:@"Bidmachine can't fint prebid request"];
            [self.delegate customEventInterstitial:self didFailAd:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
            BDMInterstitialRequest *auctionRequest = [BMAFactory.sharedFactory interstitialRequestWithRequestInfo:requestInfo];
            [weakSelf.interstitial populateWithRequest:auctionRequest];
        }];
    }
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController {
    if (self.interstitial.canShow) {
        [self.interstitial presentFromRootViewController:rootViewController];
    } else {
        BMAError *error = [BMAError errorWithDescription:@"BidMachine interstitial can't show ad"];
        [self.delegate customEventInterstitial:self didFailAd:error];
    }
}

#pragma mark - Lazy

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialDidReceiveAd:self];
}

- (void)interstitial:(BDMInterstitial *)interstitial failedWithError:(NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)interstitialWillPresent:(BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)interstitial:(BDMInterstitial *)interstitial failedToPresentWithError:(NSError *)error {
    // The Google Mobile Ads SDK does not have an equivalent callback.
    NSLog(@"Interstitial failed to present!");
}

- (void)interstitialDidDismiss:(BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (void)interstitialRecieveUserInteraction:(BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialWasClicked:self];
}

@end
