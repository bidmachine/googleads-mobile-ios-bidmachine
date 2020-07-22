//
//  BMANetworkConfiguration.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMANetworkConfiguration.h"
#import "BMAConstants.h"

@implementation BMANetworkConfiguration

+ (instancetype)configFromDictionary:(NSDictionary<NSString *,id> *)dictionary {
    // TODO: Remove casting
    return (BMANetworkConfiguration *)[self buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
        // Append network name
        if ([dictionary[kBidMachineHeaderBiddingNetworkName] isKindOfClass:NSString.class]) {
            builder.appendName(dictionary[kBidMachineHeaderBiddingNetworkName]);
        }
        // Append network class
        if ([dictionary[kBidMachineHeaderBiddingNetworkClass] isKindOfClass:NSString.class]) {
            builder.appendNetworkClass(NSClassFromString(dictionary[kBidMachineHeaderBiddingNetworkClass]));
        }
        // Append ad units
        NSArray <NSDictionary *> *adUnits = dictionary[kBidMachineHeaderBiddingAdUnits];
        if ([adUnits isKindOfClass:NSArray.class]) {
            [adUnits enumerateObjectsUsingBlock:^(NSDictionary *adUnit, NSUInteger idx, BOOL *stop) {
                if ([adUnit isKindOfClass:NSDictionary.class]) {
                    BDMAdUnitFormat fmt = [adUnit[kBidMachineHeaderBiddingAdUnitFormat] isKindOfClass:NSString.class] ?
                        BDMAdUnitFormatFromString(adUnit[kBidMachineHeaderBiddingAdUnitFormat]) :
                        BDMAdUnitFormatUnknown;
                    NSMutableDictionary *params = adUnit.mutableCopy;
                    [params removeObjectForKey:kBidMachineHeaderBiddingAdUnitFormat];
                    builder.appendAdUnit(fmt, params);
                }
            }];
        }
        // Append init params
        NSMutableDictionary <NSString *, id> *customParams = dictionary.mutableCopy;
        [customParams removeObjectsForKeys:@[
                                             kBidMachineHeaderBiddingNetworkName,
                                             kBidMachineHeaderBiddingNetworkClass,
                                             kBidMachineHeaderBiddingAdUnits
                                             ]];
        if (customParams.count) {
            builder.appendInitializationParams(customParams);
        }
    }];
}

- (NSDictionary<NSString *,id> *)config {
    NSMutableDictionary *config = [NSMutableDictionary new];
    config[kBidMachineHeaderBiddingNetworkName] = self.name;
    config[kBidMachineHeaderBiddingNetworkClass] = NSStringFromClass(self.networkClass);
    NSMutableArray *adUnits = [NSMutableArray arrayWithCapacity:self.adUnits.count];
    [self.adUnits enumerateObjectsUsingBlock:^(BDMAdUnit *adUnit, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *unit = [NSMutableDictionary new];
        unit[kBidMachineHeaderBiddingAdUnitFormat] = NSStringFromBDMAdUnitFormat(adUnit.format);
        [unit addEntriesFromDictionary:adUnit.customParams];
        [adUnits addObject:unit];
    }];
    config[kBidMachineHeaderBiddingAdUnits] = adUnits;
    [config addEntriesFromDictionary:self.initializationParams];
    return config;
}

@end
