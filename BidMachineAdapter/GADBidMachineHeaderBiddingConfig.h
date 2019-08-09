//
//  GADBidMachineHeaderBiddingConfig.h
//  BidMachineAdapter
//
//  Created by Stas Kochkin on 09/08/2019.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BDMSdkConfiguration+HeaderBidding.h>


NS_ASSUME_NONNULL_BEGIN

@interface GADBidMachineHeaderBiddingConfig : BDMAdNetworkConfiguration

@property (nonatomic, copy) NSDictionary <NSString *, id> *config;

+ (nullable instancetype)configFromDictionary:(NSDictionary <NSString *, id> *)dictionary;


@end

NS_ASSUME_NONNULL_END
