//
//  BMAFetchObject.m
//  AdMobBidMachineHBSample
//
//  Created by Ilia Lozhkin on 23.07.2020.
//  Copyright © 2020 Ilia Lozhkin. All rights reserved.
//

#import "BMAFetchObject.h"
#import "BMAUtils.h"

#import <StackFoundation/StackFoundation.h>

@implementation BMAFetchObject

- (instancetype)initWithRequest:(BDMRequest *)request {
    if (self = [super init]) {
        _request = request;
        _creationDate = NSDate.date;
        _type = [self typeByRequest:request];
        _price = [BMAUtils.shared.fetcher.formatter stringFromNumber:request.info.price];
    }
    return self;
}

- (BMAAdType)typeByRequest:(BDMRequest *)request {
    BMAAdType type;
    if (BDMInterstitialRequest.stk_isValid(request)) {
        type = BMAAdTypeInterstitial;
    } else if (BDMRewardedRequest.stk_isValid(request)) {
        type = BMAAdTypeRewarded;
    } else if (BDMNativeAdRequest.stk_isValid(request)) {
        type = BMAAdTypeNative;
    } else {
        type = BMAAdTypeBanner;
    }
    return type;
}

@end
