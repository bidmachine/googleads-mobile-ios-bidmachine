//
//  BMATransformer.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMATransformer : NSObject

+ (NSURL *)endpointUrl:(id)endpoint;
+ (NSString *)sellerIdFromValue:(id)sellerId;
+ (BDMUserGender *)genderFromString:(NSString *)gender;
+ (BDMFullscreenAdType)adTypeFromString:(NSString *)string;
+ (BDMBannerAdSize)adSizeFromGADAdSize:(GADAdSize)gadAdSize;
+ (GADVersionNumber)versionFromBidMachineString:(NSString *)version;
+ (NSArray<BDMPriceFloor *> *)priceFloorsFromArray:(NSArray *)priceFloors;

@end

NS_ASSUME_NONNULL_END
