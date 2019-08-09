//
//  GADBidMachineTransformer.h
//  BidMachineAdapter
//
//  Created by Stas Kochkin on 09/08/2019.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface GADBidMachineTransformer : NSObject

+ (GADVersionNumber)versionFromBidMachineString:(NSString *)version;
+ (BDMBannerAdSize)adSizeFromGADAdSize:(GADAdSize)gadAdSize;
+ (BDMFullscreenAdType)adTypeFromString:(NSString *)string;
+ (BDMUserGender *)genderFromString:(NSString *)gender;
+ (NSString *)sellerIdFromValue:(id)sellerId;
+ (NSArray<BDMPriceFloor *> *)priceFloorsFromArray:(NSArray *)priceFloors;

@end

NS_ASSUME_NONNULL_END
