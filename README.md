# BidMachine adapter for AdMob

- [Getting Started](#user-content-getting-started)
- [BidMachine adapter](#user-content-bidmachine-adapter)
  - [Initialize sdk](#user-content-initialize-sdk)
  - [Transfer targeting data](#user-content-transfer-targeting-data-to-bidmachine)
  - [Banner implementation](#user-content-banners-implementation)
  - [Interstitial implementation](#user-content-interstitial-implementation)
  - [Rewarded implementation](#user-content-rewarded-implementation)
  - [Native ad implementation](#user-content-native-ad-implementation)
  - [Header Bidding](#user-content-header-bidding)
- [BidMachine header bidding adapter](#user-content-bidmachine-header-bidding-adapter)
  - [Initialize sdk](#user-content-initialize-sdk-1)
  - [Banner implementation](#user-content-banners-implementation-1)
  - [Interstitial implementation](#user-content-interstitial-implementation-1)
  - [Rewarded implementation](#user-content-rewarded-implementation-1)
  - [Native ad implementation](#user-content-native-ad-implementation-1)
  - [Fetching options](#user-content-fetching-options)
- [Changelog](#user-content-changelog)

## Getting Started

Add following lines into your project Podfile

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'GoogleMobileAds-BidMachine-Adapters', '~> 1.5'
end
```

> *Note* If you want to use BidMachine Header Bidding, please, also add following lines

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'GoogleMobileAds-BidMachine-Adapters', '~> 1.5'
  pod "BidMachine/VungleAdapter"
  pod "BidMachine/TapjoyAdapter"
  pod "BidMachine/MyTargetAdapter"
  pod "BidMachine/FacebookAdapter"
  pod "BidMachine/AdColonyAdapter"
end
```

## BidMachine adapter

### Initialize SDK

All configuration and targeting parameters are setting up through GADCustomEventExtras.Create and instance of this class and set a NSDictionary with parameters. When you are setting the extras you must make sure to use the same label as you set in AdMob interface when creating a custom event.

To initialize BidMachine you can define your's seller id in GADCustomEventExtras of bannerView and interstitial (also you can define parameters like test mode and logging that are set during initialization and define all parameters that can be used to set the targeting):

You can use BMANetworkExtras class to pass additional params to BidMachine custom events.

```objc
- (void)loadBannerView {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    BMANetworkExtras *bmExtras = [BMANetworkExtras new];
    bmExtras.sellerId = @"1";
    // Do any additional setup here
    // Pass extras dictionary into GADCustomEventExtras
    [extras setExtras:bmExtras.allExtras forLabel: @"BannerLabel"];
    [self.bannerView loadRequest:request];
}
```

Also you can use JSON dictionary:
```json
{
  "badv": "https://domain_1.com,https://domain_2.org",
  "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
  "bcat": "IAB-1,IAB-3,IAB-5",
  "city": "Los Angeles",
  "consent_string": "BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
  "coppa": "true",
  "country": "USA",
  "gender": "F",
  "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
  "logging_enabled": "true",
  "paid": "true",
  "price_floors": [
    {
      "id_1": 300.06
    },
    {
      "id_2": 1000
    },
    302.006,
    1002
  ],
  "seller_id": "YOUR_SELLER_ID",
  "sturl": "https://store_url.com",
  "test_mode": "true",
  "user_id": "user123",
  "yob": 2000,
  "zip": "90001–90084"
}
```

And set it to GADCustomEventExtras as serialized NSDictionary:
```objc
- (void)loadBannerView {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    NSDictionary *JSON = [self serializedBidMachineExtras];
    [extras setExtras:JSON forLabel: @"BannerLabel"];
    [self.bannerView loadRequest:request];
}
```

Or you can set it from the AdMobUI in parameter string.

#### Test mode

To setup test mode in BidMachine add to ***GADCustomEventExtras*** @"test_mode" : @"true". You ***GADCustomEventExtras*** will be similar to what is shown below:
```objc
GADCustomEventExtras *extras = [GADCustomEventExtras new];
NSDictionary *localExtras = @{ @"test_mode": @"true" };
[extras setExtras:localExtras forLabel: @"BannerLable"];
```

#### Logging

To setup logging in BidMachine add @"logging_enabled" : @"true" flag to ***GADCustomEventExtras***:
```objc
GADCustomEventExtras *extras = [GADCustomEventExtras new];
NSDictionary *localExtras = @{ @"logging_enabled": @"true" };
[extras setExtras:localExtras forLabel: @"BannerLable"];
```

#### Initialization

All parameters that are used during initialization are presented in table below:

| Parameter | Type | Required |
| --- | --- | --- |
| seller_id | String | Required |
| test_mode | String | Optional |
| logging_enabled | String | Optional |

### Transfer targeting data to BidMachine

If you want to transfer targeting information you can use custom event's property ***localExtras*** which represents dictionary.
Keys for ***localExtras*** are listed below (Banner and Interstitial):

```
@"user_id"  --> Vendor-specific ID for the user (NSString)
@"gender"   --> User gender refer to OpenRTB 2.5 spec (kBDMUserGenderMale, kBDMUserGenderFemale, kBDMUserGenderUnknown)
@"yob"      --> User year of birth (NSNumber)
@"keywords" --> Comma separated list of keywords about the app (NSString)
@"bcat"     --> Blocked advertiser categories using the IAB content categories. Refer to List 5.1 (NSArray <NSString *>)
@"badv"     --> Block list of advertisers by their domains (e.g., “ford.com”) (NSArray <NSString *>)
@"bapps"    --> Block list of applications by their platform-specific exchange- independent application identifiers (NSArray <NSString *>)
@"country"  --> User country (NSString)
@"city"     --> User city (NSString)
@"zip"      --> User zip code (NSString)
@"sturl"    --> Store URL (NSURL)
@"stid"     --> Numeric store id identifier (NSString)
@"paid"     --> Paid version of app (NSNumber: 0-free, 1-paid)
@"endpoint" --> String URL that should be used as base URL for sdk (NSString)
```

Also you can transfer user location via extras. You can ad two more keys:

```
@"lat" --> User's latitude (double)
@"lon" --> User's longitude (double)
```
### Banners implementation

In the snippet below you can see transfering of local extra data:

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBannerViewToView:self.bannerView];
    // You can use test ad unit id - @"ca-app-pub-1405929557079197/7727940578" - to test banner ad.
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = @"YOUR_AD_UNIT_ID";
    self.bannerView.rootViewController = self;
}

- (IBAction)loadBanner:(id)sender {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    NSDictionary *localExtras = @{
                                  @"seller_id":         @"YOUR_SELLER_ID",
                                  @"coppa":             @"true",
                                  @"consent_string":    @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
                                  @"logging_enabled":   @"true",
                                  @"test_mode":         @"true",
                                  @"banner_width":      @"320",
                                  @"user_id":           @"user123",
                                  @"gender":            @"F",
                                  @"yob":               @2000,
                                  @"keywords":          @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country":           @"USA",
                                  @"city":              @"Los Angeles",
                                  @"zip":               @"90001–90084",
                                  @"sturl":             @"https://store_url.com",
                                  @"paid":              @"true",
                                  @"bcat":              @"IAB-1,IAB-3,IAB-5",
                                  @"badv":              @"https://domain_1.com,https://domain_2.org",
                                  @"bapps":             @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors":      @[
                                          @{ @"id_1": @300.06 },
                                          @{ @"id_2": @1000 },
                                          @302.006,
                                          @1002
                                          ]
                                  };
    [extras setExtras:localExtras forLabel: @"BannerLabel"];
    [self.bannerView loadRequest:request];
}
```

But also you can receive extra data from server. It will be sent in (NSString *)***serverParameter*** may look like this. But ***serverParameter*** is limited by 250 symbols:

```json
{
  "seller_id": "1",
  "coppa": "true",
  "logging_enabled": "true",
  "test_mode": "true"
}
```

### Interstitial implementation

With local extra data:

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"YOUR_AD_UNIT_ID"];
    self.interstitial.delegate = self;
}

- (IBAction)loadInterstitial:(id)sender {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    NSDictionary *localExtras = @{
                                  @"seller_id":         @"YOUR_SELLER_ID",
                                  @"coppa":             @"true",
                                  @"consent_string":    @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
                                  @"logging_enabled":   @"true",
                                  @"test_mode":         @"true",
                                  @"banner_width":      @"320",
                                  @"user_id":           @"user123",
                                  @"gender":            @"F",
                                  @"yob":               @2000,
                                  @"keywords":          @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country":           @"USA",
                                  @"city":              @"Los Angeles",
                                  @"zip":               @"90001–90084",
                                  @"sturl":             @"https://store_url.com",
                                  @"paid":              @"true",
                                  @"bcat":              @"IAB-1,IAB-3,IAB-5",
                                  @"badv":              @"https://domain_1.com,https://domain_2.org",
                                  @"bapps":             @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors":      @[
                                          @{ @"id_1": @300.06 },
                                          @{ @"id_2": @1000 },
                                          @302.006,
                                          @1002
                                          ]
                                  };
    [extras setExtras:localExtras forLabel: @"InterstitialLabel"];
    [self.interstitial loadRequest:request];
}
```

Servers extra data:

```json
{
  "seller_id": "1",
  "coppa": "true",
  "logging_enabled": "true",
  "test_mode": "true"
}
```

### Rewarded implementation

Rewarded adapter is not custom event and extras should be passed as BMANetworkExtras instance that conforms GADAdNetworkExtras.
Sample of extras passing attached bellow:

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rewarded = [[GADRewardBasedVideoAd alloc] init];
    self.rewarded.delegate = self;
}

- (IBAction)loadRewardedAd:(id)sender {
    GADRequest *request = [GADRequest request];
    BMANetworkExtras *extra = [BMANetworkExtras new];
    [extra setSellerId:@"1"];
    [extra setCoppa:NO];
    [extra setLoggingEnabled:YES];
    [extra setTestMode:YES];
    [extra setHasUserConsent:YES];
    [extra setConsentString:@"some_consent_string"];
    [extra setIsUnderGDPR:NO];
    [extra setUserLatitude:12.34];
    [extra setUserLongitude:56.78];
    [extra setUserId:@"some_user_id"];
    [extra setGender:@"F"];
    [extra setYearOfBirth:@1996];
    [extra setKeywords:@"Keyword_1,Keyword_2,Keyword_3,Keyword_4"];
    [extra setCountry:@"USA"];
    [extra setCity:@"Los Angeles"];
    [extra setZip:@"90001–90084"];
    [extra setStoreURL:[NSURL URLWithString:@"https://store_url.com"]];
    [extra setStoreId:@"123123"];
    [extra setPaid:NO];
    [extra setBaseURL:[NSURL URLWithString:@"https://some.url.com"]];
    [extra setPriceFloors:@[
                            @{ @"id_1": @300.06 },
                            @{ @"id_2": @1000 },
                            @302.006,
                            @1002
                            ]];
    [extra setBlockedCategories:@[@"IAB-1", @"IAB-3", @"IAB-5"]];
    [extra setBlockedAdvertisers:@[@"https://domain_1.com", @"https://domain_2.org"]];
    [extra setBlockedApps:@[@"com.test.application_1", @"com.test.application_2", @"com.test.application_3"]];
    [request registerAdNetworkExtras:extra];
    [self.rewarded loadRequest:request withAdUnitID:@"YOUR_AD_UNIT_ID"];
}
```

Servers extra data:

```json
{
  "seller_id": "1",
  "coppa": "true",
  "logging_enabled": "true",
  "test_mode": "true"
}
```
### Native ad implementation

Native Ad adapter is not custom event and extras should be passed as BMANetworkExtras instance that conforms GADAdNetworkExtras.
Sample of extras passing attached bellow:

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nativeLoader = [[GADAdLoader alloc] initWithAdUnitID:@UNIT_ID
                                           rootViewController:self
                                                      adTypes:@[kGADAdLoaderAdTypeUnifiedNative]
                                                      options:@[self.viewOptions, self.videoOptions, self.mediaOptions]];
    self.nativeLoader.delegate = self;
}

- (IBAction)loadNativeAd:(id)sender {
    GADRequest *request = [GADRequest request];
    BMANetworkExtras *extra = [BMANetworkExtras new];
    [extra setSellerId:@"1"];
    [extra setCoppa:NO];
    [extra setLoggingEnabled:YES];
    [extra setTestMode:YES];
    [extra setHasUserConsent:YES];
    [extra setConsentString:@"some_consent_string"];
    [extra setIsUnderGDPR:NO];
    [extra setUserLatitude:12.34];
    [extra setUserLongitude:56.78];
    [extra setUserId:@"some_user_id"];
    [extra setGender:@"F"];
    [extra setYearOfBirth:@1996];
    [extra setKeywords:@"Keyword_1,Keyword_2,Keyword_3,Keyword_4"];
    [extra setCountry:@"USA"];
    [extra setCity:@"Los Angeles"];
    [extra setZip:@"90001–90084"];
    [extra setStoreURL:[NSURL URLWithString:@"https://store_url.com"]];
    [extra setStoreId:@"123123"];
    [extra setPaid:NO];
    [extra setBaseURL:[NSURL URLWithString:@"https://some.url.com"]];
    [extra setPriceFloors:@[
                            @{ @"id_1": @300.06 },
                            @{ @"id_2": @1000 },
                            @302.006,
                            @1002
                            ]];
    [extra setBlockedCategories:@[@"IAB-1", @"IAB-3", @"IAB-5"]];
    [extra setBlockedAdvertisers:@[@"https://domain_1.com", @"https://domain_2.org"]];
    [extra setBlockedApps:@[@"com.test.application_1", @"com.test.application_2", @"com.test.application_3"]];
    [request registerAdNetworkExtras:extra];
    [self.nativeAdLoader loadRequest:request"];
}

- (IBAction)showNativeAd:(id)sender {
    [self.nativeAd unregisterAdView];
    NativeAdView *nativeAdView = [[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;
    nativeAdView.nativeAd = self.nativeAd;
    [self.view addSubview:nativeAdView];
}

```

Servers extra data:

```json
{
  "seller_id": "1",
  "coppa": "true",
  "logging_enabled": "true",
  "test_mode": "true"
}
```

### Header Bidding

To pass data for Header Bidding you should add networks configurations to extras. 

```objc
- (BMANetworkExtras *)bidMachineExtras {
    BMANetworkExtras *extras = [BMANetworkExtras new];
    /// Sample of Header Bidding configs
    /// For supported ad networks
    BMANetworkConfiguration *networkConfig = [BMANetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
        builder.appendName(@"some_network");
        builder.appendNetworkClass(NSClassFromString(@"SomeNetworkClass"));
        builder.appendAdUnit(BDMAdUnitFormatInterstitialUnknown, @{ @"some key" : @"some value" });
        builder.appendInitializationParams(@{ @"sone key": @"some value"} );
    }];
    
    extras.headerBiddingConfigs = @[vungle];
    return extras;
}

- (void)loadInterstitial {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:self.bidMachineExtras forLabel: @"InterstitialLabel"];
    [self.interstitial loadRequest:request];
}
```

JSON configuration example:

```json
{
  "logging_enabled": "true",
  "mediation_config": [
    {
      "ad_units": [
        {
          "format": "interstitial_static",
          "placement_id": "95298PL39048"
        }
      ],
      "app_id": "5a35a75845eaab51250070a5",
      "network": "vungle",
      "network_class": "BDMVungleAdNetwork"
    },
    {
      "ad_units": [
        {
          "format": "interstitial_static",
          "slot_id": "287052"
        },
        {
          "format": "banner",
          "slot_id": "262713"
        }
      ],
      "network": "my_target",
      "network_class": "BDMMyTargetAdNetwork"
    },
    {
      "ad_units": [
        {
          "facebook_key": "1419966511382477_2249153695130417",
          "format": "banner"
        },
        {
          "facebook_key": "754722298026822_1251166031715777",
          "format": "interstitial_static"
        }
      ],
      "app_id": "754722298026822",
      "network": "facebook",
      "network_class": "BDMFacebookAdNetwork",
      "placement_ids": [
        "754722298026822_1251166031715777",
        "1419966511382477_2249153695130417"
      ]
    },
    {
      "ad_units": [
        {
          "format": "interstitial_video",
          "placement_name": "video_without_cap_pb"
        }
      ],
      "network": "tapjoy",
      "network_class": "BDMTapjoyAdNetwork",
      "sdk_key": "6gwG-HstT_aLMpZXUXlhNgEBja6Q5bq7i4GtdFMJoarOufnp36PaVlG2OBmw"
    },
    {
      "ad_units": [
        {
          "format": "rewarded_video",
          "zone_id": "vzf07cd496be04483cad"
        },
        {
          "format": "interstitial_video",
          "zone_id": "vz7fdef471647c416682"
        }
      ],
      "app_id": "app327320f8ced14e61b2",
      "network": "adcolony",
      "network_class": "BDMAdColonyAdNetwork",
      "zones": [
        "vzf07cd496be04483cad",
        "vz7fdef471647c416682"
      ]
    }
  ],
  "paid": "true",
  "seller_id": "1",
  "stid": "13241536",
  "sturl": "https://store_url.com",
  "test_mode": "true",
  "user_id": "user123",
  "yob": 2000,
  "zip": "610000"
}
```

And set it to GADCustomEventExtras as serialized NSDictionary:
```objc
- (void)loadBannerView {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    NSDictionary *JSON = [self serializedBidMachineExtras];
    [extras setExtras:JSON forLabel: @"BannerLabel"];
    [self.bannerView loadRequest:request];
}
```

All network required fileds and values types are described in BidMachine doc. ([WIKI](https://wiki.appodeal.com/display/BID/BidMachine+iOS+SDK+Documentation#BidMachineiOSSDKDocumentation-AdNetworksConfigurationsParameters))  If ad network has initialisation parameters, it should be added in root of mediation config object. Ad network ad unit specific paramters should be added in root of ad unit object.

| Parameter | Description | Required |
| --- | --- | --- |
| network | Registered network name | Required |
| network_class | Linked network class, should conform BDMNetwork represented as string | Required |
| ad_units | Array of ad units that contains info about format and network specific params | Required |
| - | Any params that needed for initialisation | Optional |

#### Available ad units formats for Header Bidding

You can pass constants that are listed below:

* banner
* banner_320x50
* banner_728x90
* banner_300x250
* interstitial_video
* interstitial_static
* interstitial
* rewarded_video
* rewarded_static
* rewarded

## BidMachine header bidding adapter

### Initialize sdk

#### Start sdk

Before initialize Admob sdk should start BM sdk

``` objc
BDMSdkConfiguration *config = [BDMSdkConfiguration new];
config.testMode = YES;
[BDMSdk.sharedSdk startSessionWithSellerID:SELLER_ID configuration:config completion:nil];
```
#### Test mode

To setup test mode in BidMachine before initialization set up

```objc
BDMSdkConfiguration *config = [BDMSdkConfiguration new];
config.testMode = YES;
```

#### Logging

To setup logging in BidMachine before initialization set up

```objc
BDMSdk.sharedSdk.enableLogging = true
```

#### Initialization

All parameters that are used during initialization are presented in table below:

| Parameter | Type | Required |
| --- | --- | --- |
| seller_id | String | Required |
| test_mode | String | Optional |
| logging_enabled | String | Optional |

Yours implementation of initialization should look like this:

```objc
 BDMSdkConfiguration *config = [BDMSdkConfiguration new];
 config.testMode = YES;
 [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:^{
                                      [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
                                      
                                      }];
                                    }];
```

### Banners implementation

Make request

```objc
self.request = [BDMBannerRequest new];
[self.request performWithDelegate:self];

```
Load ad object

```objc

- (void)makeBannerRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.bannerView loadRequest:request];
}

- (void)addBannerInContainer {
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.container addSubview:self.bannerView];
}

- (GADBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _bannerView.delegate = self;
        _bannerView.adUnitID = @UNIT_ID;
        _bannerView.rootViewController = self;
        _bannerView.translatesAutoresizingMaskIntoConstraints = YES;
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _bannerView;
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // rouned price
    if (info.price.doubleValue <= 1) {
        [BMAUtils.shared.fetcher setFormat:@"0.2"];
     } else {
         [BMAUtils.shared.fetcher setFormat:@"1000.0"];
     }
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BMAUtils.shared.fetcher fetchParamsFromRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeBannerRequestWithExtras:extras];
}

```

### Interstitial implementation

Make request

```objc
self.request = [BDMInterstitialRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc

- (GADInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [[GADInterstitial alloc] initWithAdUnitID:@UNIT_ID];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (void)makeInterstitialRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.interstitial loadRequest:request];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // rouned price
    if (info.price.doubleValue <= 1) {
        [BMAUtils.shared.fetcher setFormat:@"0.2"];
     } else {
         [BMAUtils.shared.fetcher setFormat:@"1000.0"];
     }
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BMAUtils.shared.fetcher fetchParamsFromRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeInterstitialRequestWithExtras:extras];
}


```

### Rewarded implementation

Make request

```objc
self.request = [BDMRewardedRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc

- (GADRewardedAd *)rewarded {
    if (!_rewarded) {
        _rewarded = [[GADRewardedAd alloc] initWithAdUnitID:@UNIT_ID];
    }
    return _rewarded;
}

- (void)makeRewardedRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.rewarded loadRequest:request completionHandler:^(GADRequestError * error) {
        if (error) {
            NSLog(@"Reward video fail to load");
        } else {
            NSLog(@"Reward video ad is received");
        }
    }];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // rouned price
    if (info.price.doubleValue <= 1) {
        [BMAUtils.shared.fetcher setFormat:@"0.2"];
     } else {
         [BMAUtils.shared.fetcher setFormat:@"1000.0"];
     }
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BMAUtils.shared.fetcher fetchParamsFromRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRewardedRequestWithExtras:extras];
}

```

### Native ad implementation

Make request

```objc
self.request = [BDMNativeAdRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc
- (GADAdLoader *)nativeLoader {
    if (!_nativeLoader) {
        _nativeLoader = [[GADAdLoader alloc] initWithAdUnitID:@UNIT_ID
                                           rootViewController:self
                                                      adTypes:@[kGADAdLoaderAdTypeUnifiedNative]
                                                      options:@[self.viewOptions, self.videoOptions, self.mediaOptions]];
        _nativeLoader.delegate = self;
    }
    return _nativeLoader;
}

- (GADAdLoaderOptions *)videoOptions {
    GADVideoOptions *options = GADVideoOptions.new;
    options.startMuted = YES;
    return options;
}

- (GADAdLoaderOptions *)mediaOptions {
    GADNativeAdMediaAdLoaderOptions *options = GADNativeAdMediaAdLoaderOptions.new;
    options.mediaAspectRatio = GADMediaAspectRatioLandscape;
    return options;
}

- (GADAdLoaderOptions *)viewOptions {
    GADNativeAdViewAdOptions *options = GADNativeAdViewAdOptions.new;
    options.preferredAdChoicesPosition = GADAdChoicesPositionTopRightCorner;
    return options;
}

- (void)makeNativeRequestWithExtras:(NSDictionary *)localExtras {
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:localExtras forLabel:@EXTRAS_MARK];
    [request registerAdNetworkExtras:extras];
    
    [self.nativeLoader loadRequest:request];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // rouned price
    if (info.price.doubleValue <= 1) {
        [BMAUtils.shared.fetcher setFormat:@"0.2"];
     } else {
         [BMAUtils.shared.fetcher setFormat:@"1000.0"];
     }
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BMAUtils.shared.fetcher fetchParamsFromRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeNativeRequestWithExtras:extras];
}
```

### Fetching options

Setup bm_pf format and rounding mode
Formats described in [link](https://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns)

``` objc
BMAUtils.shared.fetcher.roundingMode = NSNumberFormatterRoundDown;
BMAUtils.shared.fetcher.format = @"0.00";

```

##  Changelog

### Version 1.5.0.1

* Update 'Google-Mobile-Ads-SDK' to '7.62.0'

### Version 1.5.0.0

* Update BidMachine to 1.5.0

### Version 1.4.2.0

* Update BidMachine to 1.4.2

### Version 1.4.1.0

* Update BidMachine to 1.4.1

### Version 1.4.0.0

* Update BidMachine to 1.4.0
* Add Native Ad support

### Version 1.3.0.0

* Update BidMachine to 1.3.0
* Add Header Bidding Supports
