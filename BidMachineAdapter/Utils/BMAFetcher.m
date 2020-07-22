//
//  BMAFetcher.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFetcher.h"
#import "BMAConstants.h"

@interface BDMRequest (Adapter)

- (void)registerDelegate:(id<BDMRequestDelegate>)delegate;

@end


@interface BMAFetcher () <BDMRequestDelegate>

@property (nonatomic, strong) NSMapTable <NSString *, BDMRequest *> *requestByBidId;
@property (nonatomic, strong) NSMapTable <BDMRequest *, NSString *> *bidIdByRequest;

@end

@implementation BMAFetcher

- (instancetype)initPrivately {
    self = [super init];
    return self;
}

- (NSMapTable<NSString *,BDMRequest *> *)requestByBidId {
    if (!_requestByBidId) {
        _requestByBidId = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _requestByBidId;
}

- (NSMapTable<BDMRequest *,NSString *> *)bidIdByRequest {
    if (!_bidIdByRequest) {
        _bidIdByRequest = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _bidIdByRequest;
}

- (NSDictionary<NSString *,id> *)fetchParamsFromRequest:(BDMRequest *)request {
    return [self fetchParamsFromRequest:request withCustomParams:nil];
}

- (NSDictionary<NSString *,id> *)fetchParamsFromRequest:(BDMRequest *)request withCustomParams:(NSDictionary<NSString *,id> *)params {
    if (!request.info.bidID) {
        return nil;
    }
    
    [request registerDelegate:self];
    [self associateRequest:request bidId:request.info.bidID];
    return [request.info extrasWithCustomParams:params];
}

- (BDMRequest *)requestForBidId:(NSString *)bidId {
    BDMRequest *request = [self.requestByBidId objectForKey:bidId];
    [self removeBidId:bidId];
    return request;
}

#pragma mark - Storage

- (void)associateRequest:(BDMRequest *)request bidId:(NSString *)bidId {
    [self.requestByBidId setObject:request forKey:bidId];
    [self.bidIdByRequest setObject:bidId forKey:request];
}

- (void)removeRequest:(BDMRequest *)request {
    NSString *bidId = [self.bidIdByRequest objectForKey:request];
    [self.bidIdByRequest removeObjectForKey:request];
    [self.requestByBidId removeObjectForKey:bidId];
}

- (void)removeBidId:(NSString *)bidId {
    BDMRequest *request = [self.requestByBidId objectForKey:bidId];
    [self.bidIdByRequest removeObjectForKey:request];
    [self.requestByBidId removeObjectForKey:bidId];
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

