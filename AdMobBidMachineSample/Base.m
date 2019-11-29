//
//  Base.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Base.h"

//ca-app-pub-1405929557079197~7823969450
//ca-app-pub-7058320987613523~2982310503

@interface Base ()

@end

@implementation Base

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BaseView" owner:nil options:nil].firstObject;
    if (view) {
        [self.view addSubview:view];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[[view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                                  [view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                                  [view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                                  [view.heightAnchor constraintEqualToConstant:100]]];
    }
}

/// You can use test application id - @"ca-app-pub-1405929557079197~9998880699" - to test ad.
//  NSString *appID = @"ca-app-pub-1405929557079197~9998880699";
//  [GoogleMobileAdsMediationTestSuite presentOnViewController:self
//                                                  delegate:nil];

- (void)loadAd:(id)sender {
    // no-op
}

- (void)showAd:(id)sender {
    // no-op
}

@end
