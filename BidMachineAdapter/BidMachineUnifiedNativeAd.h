//
//  BidMachineUnifiedNativeAd.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 11/19/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BidMachine/BidMachine.h>

@interface BidMachineUnifiedNativeAd : NSObject <GADMediatedUnifiedNativeAd>

- (instancetype)initWithNativeAd:(BDMNativeAd *)nativeAd;

@end
