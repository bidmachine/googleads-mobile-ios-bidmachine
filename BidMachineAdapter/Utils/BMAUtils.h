//
//  BMAUtils.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <BidMachine/BidMachine.h>
#import "BMAFetcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMAUtils : NSObject

@property (nonatomic, strong, readonly) BMAFetcher *fetcher;

+ (instancetype)shared;

- (void)initializeBidMachineWithRequestInfo:(NSDictionary *)requestInfo completion:(void(^)(NSError *))completion;

@end

NS_ASSUME_NONNULL_END
