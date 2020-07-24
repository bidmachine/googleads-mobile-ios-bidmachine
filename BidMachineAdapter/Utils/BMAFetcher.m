//
//  BMAFetcher.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFetcher.h"
#import "BMAFetchObject.h"

#import <StackFoundation/StackFoundation.h>

@interface BDMRequest (Adapter)

- (void)registerDelegate:(id<BDMRequestDelegate>)delegate;

@end

@interface BMAFetcher () <BDMRequestDelegate>

@property (nonatomic, strong) NSMutableArray <BMAFetchObject *> *fetchObjects;
@property (nonatomic, strong, readwrite) NSNumberFormatter *formatter;

@end



@implementation BMAFetcher

- (instancetype)init {
    if (self = [super init]) {
        _fetchObjects = NSMutableArray.array;
    }
    return self;
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSNumberFormatter new];
        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
        _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _formatter.roundingMode = NSNumberFormatterRoundCeiling;
        _formatter.positiveFormat = @"0.00";
    }
    return _formatter;
}

- (void)setRoundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    self.formatter.roundingMode = roundingMode;
}

- (NSNumberFormatterRoundingMode)roundingMode {
    return self.formatter.roundingMode;
}

- (void)setFormat:(NSString *)format {
    self.formatter.positiveFormat = format;
}

- (NSString *)format {
    return self.formatter.positiveFormat;
}

- (NSDictionary<NSString *,id> *)fetchParamsFromRequest:(BDMRequest *)request {
    return [self fetchParamsFromRequest:request withCustomParams:nil];
}

- (NSDictionary<NSString *,id> *)fetchParamsFromRequest:(BDMRequest *)request withCustomParams:(NSDictionary<NSString *,id> *)params {
    if (!request.info.bidID) {
        return nil;
    }
    
    [request registerDelegate:self];
    [self associateRequest:request];
    
    NSMutableDictionary *fetchedParams = [request.info extrasWithCustomParams:params].mutableCopy;
    fetchedParams[@"bm_pf"] = [self.formatter stringFromNumber:request.info.price];
    return fetchedParams;
}

- (BDMRequest *)requestForPrice:(NSString *)price type:(BMAAdType)type {
    __block BMAFetchObject *fetchObject = nil;
    [self.fetchObjects enumerateObjectsUsingBlock:^(BMAFetchObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (type == obj.type && [price isEqualToString:obj.price] && (!fetchObject || (fetchObject.creationDate < obj.creationDate))) {
            fetchObject = obj;
        }
    }];
    BDMRequest *request = fetchObject.request;
    [self removeRequest:request];
    return request;
}

- (BOOL)isPrebidRequestsForType:(BMAAdType)type {
    __block BOOL isPrebid = NO;
    [self.fetchObjects enumerateObjectsUsingBlock:^(BMAFetchObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        isPrebid = obj.type == type;
        *stop = isPrebid;
    }];
    return isPrebid;
}

#pragma mark - Storage

- (void)associateRequest:(BDMRequest *)request {
    [self.fetchObjects addObject:[[BMAFetchObject alloc] initWithRequest:request]];
}

- (void)removeRequest:(BDMRequest *)request {
    self.fetchObjects = [self.fetchObjects stk_filter:^BOOL(BMAFetchObject *obj) {
        return ![obj.request isEqual:request];
    }].mutableCopy;
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    
}
- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    
}
- (void)requestDidExpire:(BDMRequest *)request {
    [self removeRequest:request];
}

@end

