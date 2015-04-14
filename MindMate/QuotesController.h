//
//  QuotesController.h
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/13/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const quoteKey = @"quote";
static NSString * const nameKey = @"name";

@interface QuotesController : NSObject

+ (QuotesController *)sharedInstance;
- (NSArray *)bundledQuotes;
//- (NSArray *)array;

@end
