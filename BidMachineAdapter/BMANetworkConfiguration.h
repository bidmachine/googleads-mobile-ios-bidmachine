//
//  BMANetworkConfiguration.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <BidMachine/BDMSdkConfiguration+HeaderBidding.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMANetworkConfiguration : BDMAdNetworkConfiguration

@property (nonatomic, copy) NSDictionary <NSString *, id> *config;

+ (nullable instancetype)configFromDictionary:(NSDictionary <NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
