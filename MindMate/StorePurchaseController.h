//
//  StorePurchaseController.h
//  MindMate
//
//  Created by Jason Noah Choi on 5/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@import UIKit;

static NSString * const kInAppPurchaseFetchedNotification = @"kInAppPurchaseFetchedNotification";
static NSString * const kInAppPurchaseCompletedNotification = @"kInAppPurchaseCompletedNotification";
static NSString * const kInAppPurchaseRestoredNotification = @"kInAppPurchaseRestoredNotification";

static NSString * const kProductIDKey = @"productID";

@interface StorePurchaseController : NSObject

@property (nonatomic, strong) NSArray *products;

+ (StorePurchaseController *)sharedInstance;

- (void)requestProducts;
- (void)restorePurchases;
- (void)purchaseOptionSelectedObjectIndex:(NSUInteger)index;

- (NSSet *)bundledProducts;

@end
