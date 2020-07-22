//
//  BMAFactory+BMAdNetworkConfiguration.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory+BMAdNetworkConfiguration.h"
#import "BMANetworkConfiguration.h"
#import "BMAConstants.h"

@implementation BMAFactory (BMAdNetworkConfiguration)

- (NSArray <BDMAdNetworkConfiguration *> *)headerBiddingConfigurationFromRequestInfo:(NSDictionary *)requestInfo {
    NSArray *headerBiddingConfigs = requestInfo[kBidMachineHeaderBiddingConfig];
    NSMutableArray <BDMAdNetworkConfiguration *> *adNetworksConfigs = [NSMutableArray arrayWithCapacity:headerBiddingConfigs.count];
    if ([headerBiddingConfigs isKindOfClass:NSArray.class]) {
        [headerBiddingConfigs enumerateObjectsUsingBlock:^(NSDictionary *headerBiddingConfig, NSUInteger idx, BOOL *stop) {
            if ([headerBiddingConfig isKindOfClass:NSDictionary.class]) {
                BMANetworkConfiguration *networkConfig = [BMANetworkConfiguration configFromDictionary:headerBiddingConfig];
                if (networkConfig) {
                    [adNetworksConfigs addObject:networkConfig];
                }
            }
        }];
    }
    return adNetworksConfigs;
}

@end
