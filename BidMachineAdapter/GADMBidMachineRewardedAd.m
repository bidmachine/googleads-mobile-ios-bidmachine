//
//  GADMBidMachineRewardedAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineRewardedAd.h"
#import "BMAFactory+BMRequest.h"
#import "BMAFactory+RequestInfo.h"
#import "BMANetworkExtras.h"
#import "BMATransformer.h"
#import "BMAConstants.h"
#import "BMAUtils.h"
#import "BMAError.h"

#import <BidMachine/BidMachine.h>
#import <StackFoundation/StackFoundation.h>


@interface GADMBidMachineRewardedAd () <BDMRewardedDelegate, GADMediationRewardedAd>

@property (nonatomic, strong) BDMRewarded *rewardedAd;
@property (nonatomic, copy) GADMediationRewardedLoadCompletionHandler originalComletion;
@property (nonatomic, weak) id<GADMediationRewardedAdEventDelegate> delegate;

@end


@implementation GADMBidMachineRewardedAd

+ (GADVersionNumber)adSDKVersion {
    return [BMATransformer versionFromBidMachineString:@"1.5.0.1"];
}

+ (GADVersionNumber)version {
    return [BMATransformer versionFromBidMachineString:@"1.5.0.1"];
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return BMANetworkExtras.class;
}

- (GADMediationRewardedLoadCompletionHandler)loadingCompletion {
    __weak typeof (self) weakSelf = self;
    return ^id<GADMediationRewardedAdEventDelegate>(id<GADMediationRewardedAd> ad, NSError *error) {
        id<GADMediationRewardedAdEventDelegate> delegate = STK_RUN_BLOCK(weakSelf.originalComletion, ad, error);
        weakSelf.originalComletion = nil;
        return delegate;
    };;
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler {
    self.originalComletion = completionHandler;
    
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFromConfiguration:adConfiguration];
    NSString *price = ANY(requestInfo).from(kBidMachinePrice).string;
    
    if (price) {
        BDMRequest *auctionRequest = [BMAUtils.shared.fetcher requestForPrice:price type:BMAAdTypeRewarded];
        if ([auctionRequest isKindOfClass:BDMRewardedRequest.self]) {
           [self.rewardedAd populateWithRequest:(BDMRewardedRequest *)auctionRequest];
        } else {
            BMAError *error = [BMAError errorWithDescription:@"Bidmachine can't fint prebid request"];
            self.delegate = self.loadingCompletion(nil, error);
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
            BDMRewardedRequest *auctionRequest = [[BMAFactory sharedFactory] rewardedRequestWithRequestInfo:requestInfo];
            [weakSelf.rewardedAd populateWithRequest:auctionRequest];
        }];
    }
}

+ (NSString *)adapterVersion {
    return @"1.5.0.0";
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if (self.rewardedAd.canShow) {
        [self.rewardedAd presentFromRootViewController:viewController];
    } {
        BMAError *error = [BMAError errorWithDescription:@"BidMachine rewarded ad can't show ad"];
        [self.delegate didFailToPresentWithError:error];
    }
}

#pragma mark - Lazy

- (BDMRewarded *)rewardedAd {
    if (!_rewardedAd) {
        _rewardedAd = [BDMRewarded new];
        _rewardedAd.delegate = self;
    }
    return _rewardedAd;
}

#pragma mark - BDMRewardedDelegatge

- (void)rewardedReadyToPresent:(BDMRewarded *)rewarded {
    self.delegate = self.loadingCompletion(self, nil);
}

- (void)rewarded:(BDMRewarded *)rewarded failedWithError:(NSError *)error {
    self.loadingCompletion(nil, error);
}

- (void)rewardedRecieveUserInteraction:(BDMRewarded *)rewarded {
    [self.delegate reportClick];
}

- (void)rewarded:(BDMRewarded *)rewarded failedToPresentWithError:(NSError *)error {
    [self.delegate didFailToPresentWithError:error];
}

- (void)rewardedWillPresent:(BDMRewarded *)rewarded {
    [self.delegate willPresentFullScreenView];
    [self.delegate didStartVideo];
}

- (void)rewardedDidDismiss:(BDMRewarded *)rewarded {
    [self.delegate willDismissFullScreenView];
    [self.delegate didEndVideo];
    [self.delegate didDismissFullScreenView];
}

- (void)rewardedFinishRewardAction:(BDMRewarded *)rewarded {
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"" rewardAmount:NSDecimalNumber.zero];
    [self.delegate didRewardUserWithReward:reward];
}

@end
