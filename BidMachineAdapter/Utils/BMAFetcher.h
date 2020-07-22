//
//  BMAFetcher.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <BidMachine/BidMachine.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAFetcher : NSObject

- (nullable NSDictionary <NSString *, id> *)fetchParamsFromRequest:(BDMRequest *)request;

- (nullable NSDictionary <NSString *, id> *)fetchParamsFromRequest:(BDMRequest *)request withCustomParams:(nullable NSDictionary <NSString *, id> *)params;

- (nullable BDMRequest *)requestForBidId:(NSString *)bidId;

@end

NS_ASSUME_NONNULL_END
