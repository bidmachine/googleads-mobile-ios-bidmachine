//
//  BMAFactory.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 21.07.2020.
//  Copyright © 2020 bidmachine. All rights reserved.
//

#import "BMAFactory.h"

@implementation BMAFactory

+ (instancetype)sharedFactory {
    static dispatch_once_t onceToken;
    static id _sharedFactory;
    dispatch_once(&onceToken, ^{
        _sharedFactory = BMAFactory.new;
    });
    
    return _sharedFactory;
}

@end
