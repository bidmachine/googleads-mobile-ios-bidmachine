//
//  BMAFactory+BMAdNetworkConfiguration.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory.h"
#import <BidMachine/BidMachine.h>
#import <BidMachine/BDMSdkConfiguration+HeaderBidding.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAFactory (BMAdNetworkConfiguration)

- (NSArray <BDMAdNetworkConfiguration *> *)headerBiddingConfigurationFromRequestInfo:(NSDictionary *)requestInfo;

@end

NS_ASSUME_NONNULL_END
