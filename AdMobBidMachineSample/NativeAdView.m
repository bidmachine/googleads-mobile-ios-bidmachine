//
//  NativeAdView.m
//  AdMobBidMachineSample
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "NativeAdView.h"

@implementation NativeAdView

+ (UINib *)nib {
    return [UINib nibWithNibName:@"NativeAdView" bundle:[NSBundle bundleForClass:self]];
}

@end
