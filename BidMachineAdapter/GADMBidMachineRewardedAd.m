//
//  GADMBidMachineRewardedAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineRewardedAd.h"
#import "GADMAdapterBidMachineConstants.h"
#import "GADBidMachineNetworkExtras.h"
#import "GADBidMachineUtils+Request.h"
#import <BidMachine/BidMachine.h>

@interface GADMBidMachineRewardedAd () <BDMRewardedDelegate>

@property (nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> rewardedAdConnector;
@property (nonatomic, strong) BDMRewarded *rewardedAd;

@end

@implementation GADMBidMachineRewardedAd

+ (NSString *)adapterVersion {
    return @"1.1.1.0";
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return GADBidMachineNetworkExtras.class;
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
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] requestInfoFromConnector:strongConnector];
    [[GADBidMachineUtils sharedUtils] initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
        if (!error) {
            [self.rewardedAdConnector adapterDidSetUpRewardBasedVideoAd:self];
        } else {
            [self.rewardedAdConnector adapter:self didFailToSetUpRewardBasedVideoAdWithError:error];
        }
    }];
}

- (void)requestRewardBasedVideoAd {
    id<GADMRewardBasedVideoAdNetworkConnector> strongConnector = self.rewardedAdConnector;
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] requestInfoFromConnector:strongConnector];
    self.rewardedAd.delegate = self;
    BDMRewardedRequest *request = [[GADBidMachineUtils sharedUtils] rewardedRequestWithRequestInfo:requestInfo];
    [self.rewardedAd populateWithRequest:request];
}

- (void)presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    [self.rewardedAd presentFromRootViewController:viewController];
}

- (void)stopBeingDelegate {
    [self.rewardedAd setDelegate:nil];
}

#pragma mark - Lazy

- (BDMRewarded *)rewardedAd {
    if (!_rewardedAd) {
        _rewardedAd = [BDMRewarded new];
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
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"" rewardAmount:[NSDecimalNumber one]];
    [self.rewardedAdConnector adapter:self didRewardUserWithReward:reward];
}

@end
