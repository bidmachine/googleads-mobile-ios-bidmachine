//
//  NativeAdRenderer.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "NativeAdRenderer.h"
#import "NativeAdView.h"

@implementation NativeAdRenderer

+ (void)renderAd:(GADUnifiedNativeAd *)ad onView:(UIView *)view {
    [ad unregisterAdView];
    
    // Create and place ad in view hierarchy.
    NativeAdView *nativeAdView = [[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;
    [ad registerAdView:view
   clickableAssetViews:@{ GADUnifiedNativeHeadlineAsset      : nativeAdView.headlineView,
                          GADUnifiedNativeCallToActionAsset  : nativeAdView.callToActionView }
nonclickableAssetViews:@{ GADUnifiedNativeMediaViewAsset     : nativeAdView.mediaView,
                          GADUnifiedNativeIconAsset          : nativeAdView.iconView,
                          GADUnifiedNativeBodyAsset          : nativeAdView.bodyView}];
    
    nativeAdView.nativeAd = ad;
    [self replaceNativeAdView:nativeAdView inPlaceholder:view];
    
    ((UILabel *)nativeAdView.storeView).text = ad.store;
    if (ad.store) {
        nativeAdView.storeView.hidden = NO;
    } else {
        nativeAdView.storeView.hidden = YES;
    }

    ((UILabel *)nativeAdView.priceView).text = ad.price;
    if (ad.price) {
        nativeAdView.priceView.hidden = NO;
    } else {
        nativeAdView.priceView.hidden = YES;
    }

    ((UILabel *)nativeAdView.advertiserView).text = ad.advertiser;
    if (ad.advertiser) {
        nativeAdView.advertiserView.hidden = NO;
    } else {
        nativeAdView.advertiserView.hidden = YES;
    }
}

+ (void)replaceNativeAdView:(UIView *)nativeAdView
              inPlaceholder:(UIView *)placeholder {
    // Remove anything currently in the placeholder.
    [placeholder.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!nativeAdView) {
        return;
    }
    
    // Add new ad view and set constraints to fill its container.
    [placeholder addSubview:nativeAdView];
    nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(nativeAdView);
    [placeholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nativeAdView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewDictionary]];
    [placeholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nativeAdView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewDictionary]];
}

/// Gets an image representing the number of stars. Returns nil if rating is less than 3.5 stars.
+ (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
  double starRating = numberOfStars.doubleValue;
  if (starRating >= 5) {
    return [UIImage imageNamed:@"stars_5"];
  } else if (starRating >= 4.5) {
    return [UIImage imageNamed:@"stars_4_5"];
  } else if (starRating >= 4) {
    return [UIImage imageNamed:@"stars_4"];
  } else if (starRating >= 3.5) {
    return [UIImage imageNamed:@"stars_3_5"];
  } else {
    return nil;
  }
}

@end
