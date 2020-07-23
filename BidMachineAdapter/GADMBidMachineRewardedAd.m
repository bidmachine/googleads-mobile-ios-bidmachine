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


@interface GADMBidMachineRewardedAd () <BDMRewardedDelegate>

@property (nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> rewardedAdConnector;
@property (nonatomic, strong) BDMRewarded *rewardedAd;

@end


@implementation GADMBidMachineRewardedAd

+ (NSString *)adapterVersion {
    return @"1.5.0.0";
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return BMANetworkExtras.class;
}

- (instancetype)initWithRewardBasedVideoAdNetworkConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)connector {
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _rewardedAdConnector = connector;
    }
    
    return self;
}

- (void)setUp {
    id<GADMRewardBasedVideoAdNetworkConnector> strongConnector = self.rewardedAdConnector;
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFromConnector:strongConnector];
    
    __weak typeof(self) weakSelf = self;
    [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
        if (!error) {
            [weakSelf.rewardedAdConnector adapterDidSetUpRewardBasedVideoAd:weakSelf];
        } else {
            [weakSelf.rewardedAdConnector adapter:weakSelf didFailToSetUpRewardBasedVideoAdWithError:error];
        }
    }];
    
    
}

- (void)requestRewardBasedVideoAd {
    NSDictionary *requestInfo = [[BMAFactory sharedFactory] requestInfoFromConnector:self.rewardedAdConnector];
    NSString *price = ANY(requestInfo).from(kBidMachinePrice).string;
    
    if (price) {
        BDMRequest *auctionRequest = [BMAUtils.shared.fetcher requestForPrice:price type:BMAAdTypeRewarded];
        if ([auctionRequest isKindOfClass:BDMRewardedRequest.self]) {
           [self.rewardedAd populateWithRequest:(BDMRewardedRequest *)auctionRequest];
        } else {
            BMAError *error = [BMAError errorWithDescription:@"Bidmachine can't fint prebid request"];
            [self.rewardedAdConnector adapter:self didFailToLoadRewardBasedVideoAdwithError:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMAUtils.shared initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
            BDMRewardedRequest *auctionRequest = [[BMAFactory sharedFactory] rewardedRequestWithRequestInfo:requestInfo];
            [weakSelf.rewardedAd populateWithRequest:auctionRequest];
        }];
    }
}

- (void)presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    if (self.rewardedAd.canShow) {
        [self.rewardedAd presentFromRootViewController:viewController];
    } {
        BMAError *error = [BMAError errorWithDescription:@"BidMachine rewarded ad can't show ad"];
        [self.rewardedAdConnector adapter:self didFailToLoadRewardBasedVideoAdwithError:error];
    }
}

- (void)stopBeingDelegate {
    [self.rewardedAd setDelegate:nil];
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
    [self.rewardedAdConnector adapterDidReceiveRewardBasedVideoAd:self];
}

- (void)rewarded:(BDMRewarded *)rewarded failedWithError:(NSError *)error {
    [self.rewardedAdConnector adapter:self didFailToLoadRewardBasedVideoAdwithError:error];
}

- (void)rewardedRecieveUserInteraction:(BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidGetAdClick:self];
}

- (void)rewarded:(BDMRewarded *)rewarded failedToPresentWithError:(NSError *)error {
    // The Google Mobile Ads SDK does not have an equivalent callback.
    NSLog(@"Rewarded failed to present!");
}

- (void)rewardedWillPresent:(BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidOpenRewardBasedVideoAd:self];
}

- (void)rewardedDidDismiss:(BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidCloseRewardBasedVideoAd:self];
}

- (void)rewardedFinishRewardAction:(BDMRewarded *)rewarded {
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"" rewardAmount:NSDecimalNumber.zero];
    [self.rewardedAdConnector adapter:self didRewardUserWithReward:reward];
}

@end
