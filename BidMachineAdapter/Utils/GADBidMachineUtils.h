//
//  GADBidMachineUtils.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


FOUNDATION_EXPORT NSString *const kGADBidMachineErrorDomain;

@interface GADBidMachineUtils : NSObject

+ (instancetype)sharedUtils;

- (void)initializeBidMachineWithRequestInfo:(NSDictionary *)requestInfo
                                 completion:(void(^)(NSError *))completion;
- (NSDictionary *)requestInfoFrom:(NSString *)string
                          request:(GADCustomEventRequest *)request;
- (NSDictionary *)requestInfoFromConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)connector;
- (BDMTargeting *)targetingWithRequestInfo:(NSDictionary *)requestInfo
                                  location:(CLLocation *)location;
- (NSURL *)transformEndpointURL:(id)endpoint;

@end
