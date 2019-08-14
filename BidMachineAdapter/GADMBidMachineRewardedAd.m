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
    return @"1.3.0.0";
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
    NSDictionary *requestInfo = [GADBidMachineUtils.sharedUtils requestInfoFromConnector:strongConnector];
    __weak typeof(self) weakSelf = self;
    [GADBidMachineUtils.sharedUtils initializeBidMachineWithRequestInfo:requestInfo
                                                             completion:^(NSError *error) {
                                                                 if (!error) {
                                                                     [weakSelf.rewardedAdConnector adapterDidSetUpRewardBasedVideoAd:weakSelf];
                                                                 } else {
                                                                     [weakSelf.rewardedAdConnector adapter:weakSelf didFailToSetUpRewardBasedVideoAdWithError:error];
                                                                 }
                                                             }];
}

- (void)requestRewardBasedVideoAd {
    NSDictionary *requestInfo = [GADBidMachineUtils.sharedUtils requestInfoFromConnector:self.rewardedAdConnector];
    BDMRewardedRequest *request = [GADBidMachineUtils.sharedUtils rewardedRequestWithRequestInfo:requestInfo];
    [self.rewardedAd populateWithRequest:request];
}

- (void)presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    if (self.rewardedAd.canShow) {
        [self.rewardedAd presentFromRootViewController:viewController];
    } {
        NSString *description = @"BidMachine rewarded ad can't show ad";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };
        NSError *error = [NSError errorWithDomain:kGADBidMachineErrorDomain
                                             code:1
                                         userInfo:userInfo];
        
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
