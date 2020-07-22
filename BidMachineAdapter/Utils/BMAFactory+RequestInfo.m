//
//  BMAFactory+RequestInfo.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory+RequestInfo.h"
#import "BMAConstants.h"
#import "BMANetworkExtras.h"
#import "BMATransformer.h"

@implementation BMAFactory (RequestInfo)

- (NSDictionary *)requestInfoFromConnector:(id<GADMAdNetworkConnector>)connector {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    NSString *parameters = [connector.credentials valueForKey:@"parameter"];
    // Test mode
    if (connector.testMode) {
        requestInfo[kBidMachineTestMode] = @YES;
    }
    // COPPA
    if (connector.childDirectedTreatment) {
        requestInfo[kBidMachineCoppa] = @YES;
    }
    // Network extrass
    if ([connector.networkExtras isKindOfClass:BMANetworkExtras.class]) {
        NSDictionary *networkExtras = [(BMANetworkExtras *)connector.networkExtras allExtras];
        [requestInfo addEntriesFromDictionary:networkExtras];
    }
    // Credentials
    if (connector.credentials && parameters) {
        NSDictionary *params = [self deserializedString:parameters];
        if (params) {
            [requestInfo addEntriesFromDictionary:params];
        }
    }
    // Seller ID
    requestInfo[kBidMachineSellerId] = [BMATransformer sellerIdFromValue:requestInfo[kBidMachineSellerId]];
    return requestInfo;
}

- (NSDictionary *)requestInfoFrom:(NSString *)string
                          request:(GADCustomEventRequest *)request {
    // Get data from request
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    if (request.additionalParameters) {
        [requestInfo addEntriesFromDictionary:request.additionalParameters];
    }
    // Get data from serialized string
    NSDictionary *deserializedInfo = [self deserializedString:string];
    if (deserializedInfo.count) {
        [requestInfo addEntriesFromDictionary:deserializedInfo];
    }
    // Get user location info
    if (request.userHasLocation) {
        requestInfo[kBidMachineLatitude] = @(request.userLatitude);
        requestInfo[kBidMachineLongitude] = @(request.userLongitude);
    }
    return requestInfo;
}

- (NSDictionary *)deserializedString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *requestInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return requestInfo;
}

@end
