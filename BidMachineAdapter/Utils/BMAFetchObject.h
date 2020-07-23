//
//  BMAFetchObject.h
//  AdMobBidMachineHBSample
//
//  Created by Ilia Lozhkin on 23.07.2020.
//  Copyright © 2020 Ilia Lozhkin. All rights reserved.
//

#import <BidMachine/BidMachine.h>
#import "BMAConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMAFetchObject : NSObject

@property (nonatomic, strong, readonly) BDMRequest *request;
@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, strong, readonly) NSString *price;
@property (nonatomic, assign, readonly) BMAAdType type;

- (instancetype)initWithRequest:(BDMRequest *)request;

@end

NS_ASSUME_NONNULL_END
