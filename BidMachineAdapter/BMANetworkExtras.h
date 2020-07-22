//
//  BMANetworkExtras.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BMANetworkConfiguration.h"

@interface BMANetworkExtras : NSObject <GADAdNetworkExtras>
/**
 Your publisher id registered in exchange dashboard
 */
@property (nonatomic, copy) NSString *sellerId;
/**
 Enable/disable test mode
 */
@property (nonatomic, assign) BOOL testMode;
/**
 Enable logging. By default logging disabled.
 */
@property (nonatomic, assign) BOOL loggingEnabled;
/**
 Base URL for SDK initialisation
 */
@property (nonatomic, copy) NSURL *baseURL;
/**
 Setup that user is under GDPR.
 */
@property (nonatomic, assign) BOOL isUnderGDPR;
/**
 Setup that user give consent
 */
@property (nonatomic, assign) BOOL hasUserConsent;
/**
 Setup that user is under COPPA.
 */
@property (nonatomic, assign) BOOL coppa;
/**
 * The consent string for sending the GDPR consent.
 */
@property (nonatomic, copy) NSString *consentString;
/**
 Vendor-specific ID for the user
 */
@property (nonatomic, copy) NSString *userId;
/**
 Comma separated list of keywords about the app
 */
@property (nonatomic, copy) NSString *keywords;
/**
 Blocked advertiser categories using the IAB content categories. Refer to List 5.1
 */
@property (nonatomic, copy) NSArray <NSString *> *blockedCategories;
/**
 Block list of advertisers by their domains (e.g., “ford.com”).
 */
@property (nonatomic, copy) NSArray <NSString *> *blockedAdvertisers;
/**
 Block list of applications by their platform-specific exchange- independent application identifiers. These are numeric IDs.
 */
@property (nonatomic, copy) NSArray <NSString *> *blockedApps;
/**
 Current latitude of user device.
 */
@property (nonatomic, assign) CGFloat userLatitude;
/**
 Current longitude of user device.
 */
@property (nonatomic, assign) CGFloat userLongitude;
/**
 User yob refer to OpenRTB 2.5 spec
 */
@property (nonatomic, copy) NSNumber *yearOfBirth;
/**
 User gender refer to OpenRTB 2.5 spec.
 */
@property (nonatomic, copy) NSString *gender;
/**
 User country.
 */
@property (nonatomic, copy) NSString *country;
/**
 User city.
 */
@property (nonatomic, copy) NSString *city;
/**
 User zip code.
 */
@property (nonatomic, copy) NSString *zip;
/**
 Store URL.
 */
@property (nonatomic, copy) NSURL *storeURL;
/**
 Numeric store id identifier.
 */
@property (nonatomic, copy) NSString *storeId;
/**
 Paid version of app.
 */
@property (nonatomic, assign) BOOL paid;
/**
 Bids configuration for current request.
 */
@property (nonatomic, copy) NSArray *priceFloors;

@property (nonatomic, copy) NSArray <BMANetworkConfiguration *> *headerBiddingConfigs;
/**
 Creates dictionary from properties.
 */
- (NSDictionary *)allExtras;

@end
