//
//  BidMachineCustomEventBanner.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>


@interface BidMachineCustomEventBanner : NSObject <GADCustomEventBanner>

@property (nonatomic, weak) id<GADCustomEventBannerDelegate> delegate;

@end

