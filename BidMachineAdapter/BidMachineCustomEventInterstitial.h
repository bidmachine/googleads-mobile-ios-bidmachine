//
//  BidMachineCustomEventInterstitial.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>


@interface BidMachineCustomEventInterstitial : NSObject <GADCustomEventInterstitial>

@property (nonatomic, weak) id<GADCustomEventInterstitialDelegate> delegate;

@end

