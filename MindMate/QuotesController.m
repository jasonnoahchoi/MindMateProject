//
//  QuotesController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/13/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "QuotesController.h"

@implementation QuotesController

+ (QuotesController *)sharedInstance {
    static QuotesController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QuotesController alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)bundledQuotes {
    NSBundle *bundle = [NSBundle mainBundle];
    id bundleQuotes = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[bundle URLForResource:@"quotes" withExtension:@"json"]] options:0 error:nil];
    NSArray *results = bundleQuotes;
    return results;
//    if (bundleProducts) {
//        NSSet *products = [NSSet setWithArray:bundleProducts];
//        return products;
//    }
//    return nil;
}

//- (NSArray *)array {
//    [[self bundledQuotes] allObjects];
//     NSUInteger randomIndex = arc4random() % [[[self bundledQuotes] allObjects] count];
//}

@end
