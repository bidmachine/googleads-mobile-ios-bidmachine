//
//  BMAConstants.h
//  AdMobBidMachineSample
//
//  Created by Yaroslav Skachkov on 5/16/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

typedef NS_ENUM(NSInteger, BMAAdType) {
    BMAAdTypeBanner = 0,
    BMAAdTypeInterstitial,
    BMAAdTypeRewarded,
    BMAAdTypeNative
};

static NSString * const kBidMachineBidId                        = @"bm_id";
static NSString * const kBidMachinePrice                        = @"bm_pf";
static NSString * const kBidMachineSellerId                     = @"seller_id";
static NSString * const kBidMachineTestMode                     = @"test_mode";
static NSString * const kBidMachineEndpoint                     = @"endpoint";
static NSString * const kBidMachineLoggingEnabled               = @"logging_enabled";
static NSString * const kBidMachineCoppa                        = @"coppa";
static NSString * const kBidMachineAdContentType                = @"ad_content_type";
static NSString * const kBidMachineSubjectToGDPR                = @"subject_to_gdpr";
static NSString * const kBidMachineHasConsent                   = @"has_consent";
static NSString * const kBidMachineConsentString                = @"consent_string";
static NSString * const kBidMachineUserId                       = @"user_id";
static NSString * const kBidMachineGender                       = @"gender";
static NSString * const kBidMachineYearOfBirth                  = @"yob";
static NSString * const kBidMachineKeywords                     = @"keywords";
static NSString * const kBidMachineCountry                      = @"country";
static NSString * const kBidMachineCity                         = @"city";
static NSString * const kBidMachineZip                          = @"zip";
static NSString * const kBidMachineStoreURL                     = @"sturl";
static NSString * const kBidMachineStoreId                      = @"stid";
static NSString * const kBidMachinePaid                         = @"paid";
static NSString * const kBidMachineBlockedCategories            = @"bcat";
static NSString * const kBidMachineBlockedAdvertisers           = @"badv";
static NSString * const kBidMachineBlockedApps                  = @"bapps";
static NSString * const kBidMachinePriceFloors                  = @"price_floors";
static NSString * const kBidMachineLatitude                     = @"lat";
static NSString * const kBidMachineLongitude                    = @"lon";
static NSString * const kBidMachineHeaderBiddingConfig          = @"mediation_config";
static NSString * const kBidMachineHeaderBiddingNetworkName     = @"network";
static NSString * const kBidMachineHeaderBiddingNetworkClass    = @"network_class";
static NSString * const kBidMachineHeaderBiddingAdUnits         = @"ad_units";
static NSString * const kBidMachineHeaderBiddingAdUnitFormat    = @"format";
