//
//  PurchasedDataController.m
//  MindMate
//
//  Created by Jason Noah Choi on 5/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "PurchasedDataController.h"
#import "StorePurchaseController.h"

static NSString * const kGoPro = @"goPro";

@interface PurchasedDataController ()

@property (assign, nonatomic) BOOL goPro;

@end

@implementation PurchasedDataController

+ (PurchasedDataController *)sharedInstance {
    static PurchasedDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PurchasedDataController new];
        [sharedInstance registerForNotifications];
        [sharedInstance loadFromDefaults];
    });
    return sharedInstance;
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseNotification:) name:kInAppPurchaseCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseNotification:) name:kInAppPurchaseRestoredNotification object:nil];
}

#pragma mark - Properties to/from NSUserDefaults

- (void)loadFromDefaults {

    self.goPro = [[NSUserDefaults standardUserDefaults] boolForKey:kGoPro];

    if (!self.goPro) {
        self.goPro = NO;
    }
}

- (void)setGoPro:(BOOL)goPro {
    _goPro = goPro;

    [[NSUserDefaults standardUserDefaults] setBool:goPro forKey:kGoPro];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Handle Purchase Notification

- (void)purchaseNotification:(NSNotification *)notification {
    
    NSString *productIdentifer = notification.userInfo[kProductIDKey];
    
    if ([productIdentifer isEqualToString:@"gives.tomorrow.jason.Tomorrow.gopro"]) {
        self.goPro = YES;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kPurchasedContentUpdated object:nil userInfo:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
