//
//  BMAFactory+RequestInfo.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAFactory (RequestInfo)

- (NSDictionary *)requestInfoFrom:(NSString *)string request:(GADCustomEventRequest *)request;
- (NSDictionary *)requestInfoFromConfiguration:(GADMediationRewardedAdConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
