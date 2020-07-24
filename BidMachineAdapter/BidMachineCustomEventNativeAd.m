//
//  BidMachineCustomEventNativeAd.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 11/18/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventNativeAd.h"
#import "BidMachineUnifiedNativeAd.h"
#import "BMAFactory+BMRequest.h"
#import "BMAFactory+RequestInfo.h"
#import "BMATransformer.h"
#import "BMAConstants.h"
#import "BMAUtils.h"
#import "BMAError.h"

#import <BidMachine/BidMachine.h>
#import <StackFoundation/StackFoundation.h>

@interface BidMachineCustomEventNativeAd()<BDMNativeAdDelegate>

@property (nonatomic, strong) BDMNativeAd *nativeAd;

@end

@implementation BidMachineCustomEventNativeAd

- (void)requestNativeAdWithParameter:(nonnull NSString *)serverParameter
                             request:(nonnull GADCustomEventRequest *)request
                             adTypes:(nonnull NSArray *)adTypes
                             options:(nonnull NSArray *)options
                  rootViewController:(nonnull UIViewController *)rootViewController
{
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFrom:serverParameter request:request];
    NSString *price = ANY(requestInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BMAUtils.shared.fetcher isPrebidRequestsForType:BMAAdTypeNative];
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BMAUtils.shared.fetcher requestForPrice:price type:BMAAdTypeNative];
        if ([auctionRequest isKindOfClass:BDMNativeAdRequest.self]) {
            [self.nativeAd makeRequest:(BDMNativeAdRequest *)auctionRequest];
        } else {
            BMAError *error = [BMAError errorWithDescription:@"Bidmachine can't fint prebid request"];
            [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
            BDMNativeAdRequest *auctionRequest = [BMAFactory.sharedFactory nativeAdRequestWithRequestInfo:requestInfo];
            [weakSelf.nativeAd makeRequest:auctionRequest];
        }];
    }
}

- (BOOL)handlesUserClicks {
    return true;
}

- (BOOL)handlesUserImpressions {
    return true;
}

- (BDMNativeAd *)nativeAd {
    if (!_nativeAd) {
        _nativeAd = BDMNativeAd.new;
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}
 
#pragma mark - BDMNativeAdDelegate

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd failedWithError:(nonnull NSError *)error {
    [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
}

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd readyToPresentAd:(nonnull BDMAuctionInfo *)auctionInfo {
    BidMachineUnifiedNativeAd *adapter = [[BidMachineUnifiedNativeAd alloc] initWithNativeAd:nativeAd];
    [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:adapter];
}

@end
