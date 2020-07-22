//
//  BMAFactory+BMTargeting.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory.h"
#import <BidMachine/BidMachine.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAFactory (BMTargeting)

- (BDMTargeting *)targetingWithRequestInfo:(NSDictionary *)requestInfo location:(CLLocation *)location;

- (BDMUserRestrictions *)userRestrictionsWithRequestInfo:(NSDictionary *)requestInfo;

@end

NS_ASSUME_NONNULL_END
