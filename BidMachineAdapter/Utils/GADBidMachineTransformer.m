//
//  GADBidMachineTransformer.m
//  BidMachineAdapter
//
//  Created by Stas Kochkin on 09/08/2019.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineTransformer.h"


@implementation GADBidMachineTransformer

+ (GADVersionNumber)versionFromBidMachineString:(NSString *)version {
    GADVersionNumber gadVersion = {0};
    NSArray<NSString *> *components = [version componentsSeparatedByString:@"."];
    if (components.count == 3) {
        gadVersion.majorVersion = components[0].integerValue;
        gadVersion.minorVersion = components[1].integerValue;
        gadVersion.patchVersion = components[2].integerValue;
    }
    return gadVersion;
}

+ (BDMBannerAdSize)adSizeFromGADAdSize:(GADAdSize)gadAdSize {
    BDMBannerAdSize adSize;
    CGSize transformedSize = CGSizeFromGADAdSize(gadAdSize);
    switch ((int)transformedSize.height) {
        case 50:  adSize = BDMBannerAdSize320x50;   break;
        case 90:  adSize = BDMBannerAdSize728x90;   break;
        case 250: adSize = BDMBannerAdSize300x250;  break;
        default:  adSize = BDMBannerAdSizeUnknown;  break;
    }
    return adSize;
}

+ (BDMFullscreenAdType)adTypeFromString:(NSString *)string {
    BDMFullscreenAdType type;
    NSString *lowercasedString = [string lowercaseString];
    if ([lowercasedString isEqualToString:@"all"]) {
        type = BDMFullscreenAdTypeAll;
    } else if ([lowercasedString isEqualToString:@"video"]) {
        type = BDMFullscreenAdTypeVideo;
    } else if ([lowercasedString isEqualToString:@"static"]) {
        type = BDMFullsreenAdTypeBanner;
    } else {
        type = BDMFullscreenAdTypeAll;
    }
    return type;
}

+ (BDMUserGender *)genderFromString:(NSString *)gender {
    BDMUserGender *userGender;
    if ([gender isEqualToString:@"F"]) {
        userGender = kBDMUserGenderFemale;
    } else if ([gender isEqualToString:@"M"]) {
        userGender = kBDMUserGenderMale;
    } else if ([gender isEqualToString:@"O"]) {
        userGender = kBDMUserGenderUnknown;
    }
    return userGender;
}

+ (NSString *)sellerIdFromValue:(id)sellerId {
    NSString *stringSellerId;
    if ([sellerId isKindOfClass:NSString.class] && [sellerId integerValue]) {
        stringSellerId = sellerId;
    } else if ([sellerId isKindOfClass:NSNumber.class]) {
        stringSellerId = [sellerId stringValue];
    }
    return stringSellerId;
}

+ (NSArray<BDMPriceFloor *> *)priceFloorsFromArray:(NSArray *)priceFloors {
    NSMutableArray<BDMPriceFloor *> *priceFloorsArr = priceFloors.count > 0 ? [NSMutableArray new] : nil;
    [priceFloors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSDictionary.class]) {
            NSDictionary *dict = (NSDictionary *)obj;
            NSString *key = dict.allKeys.firstObject;
            NSDecimalNumber *value = [dict[key] isKindOfClass:NSNumber.class] ?
                [NSDecimalNumber decimalNumberWithDecimal:[dict[key] decimalValue]] :
                nil;
            if (key && value) {
                BDMPriceFloor *priceFloor = [BDMPriceFloor new];
                [priceFloor setID:key];
                [priceFloor setValue:value];
                [priceFloorsArr addObject:priceFloor];
            }
        } else if ([obj isKindOfClass:NSNumber.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSNumber *object = (NSNumber *)obj;
            [priceFloor setID:NSUUID.UUID.UUIDString.lowercaseString];
            [priceFloor setValue:[NSDecimalNumber decimalNumberWithDecimal:object.decimalValue]];
            [priceFloorsArr addObject:priceFloor];
        }
    }];
    return priceFloorsArr;
}

@end
