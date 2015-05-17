//
//  PurchasedDataController.h
//  MindMate
//
//  Created by Jason Noah Choi on 5/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kPurchasedContentUpdated = @"kPurchasedContentUpdated";

@interface PurchasedDataController : NSObject

@property (assign, nonatomic, readonly) BOOL goPro;

+ (PurchasedDataController *)sharedInstance;

@end
