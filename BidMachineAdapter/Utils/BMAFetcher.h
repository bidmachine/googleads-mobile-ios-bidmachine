//
//  BMAFetcher.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <BidMachine/BidMachine.h>
#import "BMAConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMAFetcher : NSObject

@property (nonatomic, strong, readonly) NSNumberFormatter *formatter;

@property (nonatomic, assign) NSNumberFormatterRoundingMode roundingMode;

@property (nonatomic, copy) NSString *format;

- (nullable NSDictionary <NSString *, id> *)fetchParamsFromRequest:(BDMRequest *)request;

- (nullable NSDictionary <NSString *, id> *)fetchParamsFromRequest:(BDMRequest *)request withCustomParams:(nullable NSDictionary <NSString *, id> *)params;

- (nullable BDMRequest *)requestForPrice:(NSString *)price type:(BMAAdType)type;

- (BOOL)isPrebidRequestsForType:(BMAAdType)type;

@end

NS_ASSUME_NONNULL_END
