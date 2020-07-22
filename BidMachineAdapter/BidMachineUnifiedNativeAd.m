//
//  BidMachineUnifiedNativeAd.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 11/19/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineUnifiedNativeAd.h"

@interface BidMachineNativeAdRendering : NSObject <BDMNativeAdRendering>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *callToActionLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIView *mediaContainerView;
@property (nonatomic, weak) UIView *adChoiceView;

+ (instancetype)nativeAdRenderingWith:(NSDictionary<GADUnifiedNativeAssetIdentifier,UIView *> *)assetViews;

@end

@interface BidMachineUnifiedNativeAd ()<BDMAdEventProducerDelegate>

@property(nonatomic, strong) BDMNativeAd *nativeAd;

@property(nonatomic, readwrite, nullable) NSArray<GADNativeAdImage *> *images;
@property(nonatomic, readwrite, nullable) GADNativeAdImage *icon;

@end

@implementation BidMachineUnifiedNativeAd

- (instancetype)initWithNativeAd:(BDMNativeAd *)nativeAd {
    if (self = [super init]) {
        NSURL *mainUrl = [NSURL URLWithString:nativeAd.mainImageUrl];
        NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
        
        _nativeAd = nativeAd;
        _images = @[[[GADNativeAdImage alloc] initWithURL:mainUrl scale:1.0]];
        _icon = [[GADNativeAdImage alloc] initWithURL:iconUrl scale:1.0];
        
        self.nativeAd.producerDelegate = self;
        
    }
    return self;
}

- (NSString *)headline {
    return self.nativeAd.title;
}

- (NSString *)body {
    return self.nativeAd.body;
}

- (NSString *)callToAction {
    return self.nativeAd.CTAText;
}

- (NSDecimalNumber *)starRating {
    if (self.nativeAd.starRating) {
        return [[NSDecimalNumber alloc] initWithInt:self.nativeAd.starRating.intValue];
    }
    return nil;
}

- (NSString *)store {
    return nil;
}

- (NSString *)price {
    return nil;
}

- (NSString *)advertiser {
    return nil;
}

- (NSDictionary<NSString *,id> *)extraAssets {
    return nil;
}

- (BOOL)hasVideoContent {
    return self.nativeAd.containsVideo;
}

- (void)didRenderInView:(UIView *)view
    clickableAssetViews:(NSDictionary<GADUnifiedNativeAssetIdentifier,UIView *> *)clickableAssetViews
 nonclickableAssetViews:(NSDictionary<GADUnifiedNativeAssetIdentifier,UIView *> *)nonclickableAssetViews
         viewController:(UIViewController *)viewController
{
    NSMutableDictionary<GADUnifiedNativeAssetIdentifier,UIView *> *assetViews = NSMutableDictionary.new;
    [assetViews addEntriesFromDictionary:clickableAssetViews];
    [assetViews addEntriesFromDictionary:nonclickableAssetViews];
    BidMachineNativeAdRendering *adRendering = [BidMachineNativeAdRendering nativeAdRenderingWith:assetViews];
    [self.nativeAd presentOn:view
    clickableViews:clickableAssetViews.allValues
       adRendering:adRendering
        controller:viewController
             error:nil];
    
}

- (void)didUntrackView:(UIView *)view {
    [self.nativeAd unregisterViews];
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    [GADMediatedUnifiedNativeAdNotificationSource mediatedNativeAdDidRecordClick:self];
}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [GADMediatedUnifiedNativeAdNotificationSource mediatedNativeAdDidRecordImpression:self];
}

@end

@implementation BidMachineNativeAdRendering

+ (instancetype)nativeAdRenderingWith:(NSDictionary<GADUnifiedNativeAssetIdentifier,UIView *> *)assetViews
{
    return [[self alloc] initWithAssetViews:assetViews];
}

- (instancetype)initWithAssetViews:(NSDictionary<GADUnifiedNativeAssetIdentifier,UIView *> *)assetViews {
    if (self = [super init]) {
        _titleLabel = (UILabel *)assetViews[GADUnifiedNativeHeadlineAsset];
        _callToActionLabel = (UILabel *)assetViews[GADUnifiedNativeCallToActionAsset];
        _descriptionLabel = (UILabel *)assetViews[GADUnifiedNativeBodyAsset];
        _iconView = (UIImageView *)assetViews[GADUnifiedNativeIconAsset];
        _mediaContainerView = assetViews[GADUnifiedNativeMediaViewAsset];
        _adChoiceView = assetViews[GADUnifiedNativeAdChoicesViewAsset];
    }
    return self;
}

@end
