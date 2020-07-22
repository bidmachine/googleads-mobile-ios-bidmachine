//
//  BMAUtils.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAUtils.h"
#import "BMAConstants.h"
#import "BMAError.h"
#import "BMATransformer.h"
#import "BMAFactory+BMTargeting.h"
#import "BMAFactory+BMAdNetworkConfiguration.h"

@interface BMAUtils ()

@property (nonatomic, strong, readwrite) BMAFetcher *fetcher;

@end

@implementation BMAUtils

+ (instancetype)shared {
    static BMAUtils * _sharedUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = BMAUtils.new;
    });
    return _sharedUtils;
}

- (instancetype)init {
    if (self = [super init]) {
        _fetcher = BMAFetcher.new;
    }
    return self;
}

- (void)initializeBidMachineWithRequestInfo:(NSDictionary *)requestInfo completion:(void(^)(NSError *))completion {
    NSString *sellerID = [BMATransformer sellerIdFromValue:requestInfo[kBidMachineSellerId]];
    if (!sellerID) {
        BMAError *error = [BMAError errorWithDescription:@"BidMachine's initialization skipped: The seller id is empty or has an incorrect type"];
        completion ? completion(error) : nil;
        return;
    }
    
    BDMUserRestrictions *restrictions = [[BMAFactory sharedFactory] userRestrictionsWithRequestInfo:requestInfo];
    BDMSdkConfiguration *config = ({ BDMSdkConfiguration *config = BDMSdkConfiguration.new;
        config.testMode = [requestInfo[kBidMachineTestMode] boolValue];
        config.baseURL = [BMATransformer endpointUrl:requestInfo[kBidMachineEndpoint]];
        config.networkConfigurations = [[BMAFactory sharedFactory] headerBiddingConfigurationFromRequestInfo:requestInfo];
        config;
    });

    [BDMSdk.sharedSdk setEnableLogging:[requestInfo[kBidMachineLoggingEnabled] boolValue]];
    [BDMSdk.sharedSdk setRestrictions:restrictions];
    [BDMSdk.sharedSdk startSessionWithSellerID:sellerID
                                 configuration:config
                                    completion:^{
                                        completion ? completion(nil) : nil;
                                    }];
}

@end
