//
//  BidMachineCustomEventNativeAd.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 11/18/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventNativeAd.h"
#import "GADBidMachineUtils+Request.h"
#import "BidMachineUnifiedNativeAd.h"
#import <BidMachine/BidMachine.h>

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
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestInfo = [GADBidMachineUtils.sharedUtils requestInfoFrom:serverParameter
                                                                        request:request];
    [GADBidMachineUtils.sharedUtils initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
        BDMNativeAdRequest *request = [GADBidMachineUtils.sharedUtils nativeAdRequestWithRequestInfo:requestInfo];
        [weakSelf.nativeAd makeRequest:request];
    }];
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
