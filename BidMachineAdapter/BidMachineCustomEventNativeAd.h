//
//  BidMachineCustomEventNativeAd.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 11/18/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BidMachineCustomEventNativeAd : NSObject <GADCustomEventNativeAd>

@property(nonatomic, weak, nullable) id<GADCustomEventNativeAdDelegate> delegate;

@end

