//
//  BidMachineCustomEventRewardedAd.m
//  AdMobBidMachineHBSample
//
//  Created by Ilia Lozhkin on 23.07.2020.
//  Copyright © 2020 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineCustomEventRewardedAd.h"

#import "BMAFactory+BMRequest.h"
#import "BMAFactory+RequestInfo.h"
#import "BMATransformer.h"
#import "BMAConstants.h"
#import "BMAUtils.h"
#import "BMAError.h"

#import <BidMachine/BidMachine.h>
#import <StackFoundation/StackFoundation.h>

#include <stdatomic.h>


@interface BidMachineCustomEventRewardedAd () <BDMRewardedDelegate> {
  /// Handle rewarded ads from Sample SDK.
  BDMRewarded *_rewardedAd;

  /// Completion handler to call when sample rewarded ad finishes loading.
  GADMediationRewardedLoadCompletionHandler _loadCompletionHandler;

  ///  Delegate for receiving rewarded ad notifications.
  __weak id<GADMediationRewardedAdEventDelegate> _delegate;
    
  /// Configuraton
  GADMediationRewardedAdConfiguration *_adConfiguration;
}

@end


@implementation BidMachineCustomEventRewardedAd

- (instancetype)initWithConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    if (self = [super init]) {
        __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
        __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler =
            [completionHandler copy];

        _loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
            _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
          // Only allow completion handler to be called once.
          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
          }

          id<GADMediationRewardedAdEventDelegate> delegate = nil;
          if (originalCompletionHandler) {
            // Call original handler and hold on to its return value.
            delegate = originalCompletionHandler(ad, error);
          }

          // Release reference to handler. Objects retained by the handler will also be released.
          originalCompletionHandler = nil;

          return delegate;
        };
        
        _adConfiguration = adConfiguration;
    }
    return self;
}

- (void)loadRewardedVideo {
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFromConfiguration:_adConfiguration];
    NSString *price = ANY(requestInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BMAUtils.shared.fetcher isPrebidRequestsForType:BMAAdTypeRewarded];
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BMAUtils.shared.fetcher requestForPrice:price type:BMAAdTypeRewarded];
        if ([auctionRequest isKindOfClass:BDMRewardedRequest.self]) {
            _rewardedAd = [BDMRewarded new];
            _rewardedAd.delegate = self;
            [_rewardedAd populateWithRequest:(BDMRewardedRequest *)auctionRequest];
        } else {
            BMAError *error = [BMAError errorWithDescription:@"Bidmachine can't fint prebid request"];
            _loadCompletionHandler(nil, error);
        }
    } else {
        BidMachineCustomEventRewardedAd *__weak weakSelf = self;
        [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
            BidMachineCustomEventRewardedAd *strongSelf = weakSelf;
            BDMRewardedRequest *auctionRequest = [[BMAFactory sharedFactory] rewardedRequestWithRequestInfo:requestInfo];
            strongSelf->_rewardedAd = [BDMRewarded new];
            strongSelf->_rewardedAd.delegate = self;
            [strongSelf->_rewardedAd populateWithRequest:auctionRequest];
        }];
    }
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if (_rewardedAd.canShow) {
        [_rewardedAd presentFromRootViewController:viewController];
    } else {
        id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
        BMAError *error = [BMAError errorWithDescription:@"BidMachine rewarded ad can't show ad"];
        [strongDelegate didFailToPresentWithError:error];
    }
}

#pragma mark - BDMRewardedDelegatge

- (void)rewardedReadyToPresent:(BDMRewarded *)rewarded {
    _delegate = _loadCompletionHandler(self, nil);
}

- (void)rewarded:(BDMRewarded *)rewarded failedWithError:(NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)rewardedRecieveUserInteraction:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate reportClick];
}

- (void)rewarded:(BDMRewarded *)rewarded failedToPresentWithError:(NSError *)error {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate didFailToPresentWithError:error];
}

- (void)rewardedWillPresent:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willPresentFullScreenView];
    [strongDelegate didStartVideo];
}

- (void)rewardedDidDismiss:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willDismissFullScreenView];
    [strongDelegate didEndVideo];
    [strongDelegate didDismissFullScreenView];
}

- (void)rewardedFinishRewardAction:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"" rewardAmount:NSDecimalNumber.zero];
    [strongDelegate didRewardUserWithReward:reward];
}

@end
