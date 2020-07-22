//
//  BMAFactory.h
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAFactory : NSObject

+ (instancetype)sharedFactory;

@end

NS_ASSUME_NONNULL_END
