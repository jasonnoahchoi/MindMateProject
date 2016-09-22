//
//  SSInAppPurchaseController.m
//  MindMate
//
//  Created by Jason Noah Choi on 5/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "StorePurchaseController.h"

@interface StorePurchaseController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, assign) BOOL productsRequested;

@end

@implementation StorePurchaseController

+ (StorePurchaseController *)sharedInstance {
    static StorePurchaseController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StorePurchaseController alloc] init];
        [sharedInstance loadStore];
    });
    return sharedInstance;
}

- (UIViewController *)topVC {
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

- (NSSet *)bundledProducts {
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *bundleProducts = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[bundle URLForResource:@"Products" withExtension:@"json"]] options:0 error:nil];
    if (bundleProducts) {
        NSSet *products = [NSSet setWithArray:bundleProducts];
        return products;
    }
    return nil;
}


- (void)requestProducts {
    if (!self.productsRequest) {
        self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[self bundledProducts]];
        self.productsRequest.delegate = self;
    }

    if (!self.productsRequested) {
        
        // requests products from iTunes Connect
        
        [self.productsRequest start];
        self.productsRequested = YES;
    }
}

- (void) restorePurchases {
    
    // restores purchases for the user
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Actions

- (void)purchaseOptionSelectedObjectIndex:(NSUInteger)index {
    
    if ([SKPaymentQueue canMakePayments]) {
        if ([self.products count] > 0) {
            
            // create payment with the selected product
            
            SKPayment *payment = [SKPayment paymentWithProduct:self.products[index]];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to Purchase" message:@"This purchase is currently unavailable. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [[self topVC] presentViewController:alert animated:YES completion:nil];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to Purchase" message:@"In-app purchases are disabled. You'll have to enable them to enjoy the full app." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[self topVC] presentViewController:alert animated:YES completion:nil];
	}
}


#pragma mark - SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.productsRequested = NO;
    
    NSArray *products = response.products;
    self.products = products;
    for (SKProduct *validProduct in response.products) {
        NSLog(@"Found product: %@", validProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // notifies app that products were loaded
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseFetchedNotification object:self userInfo:nil];
}


#pragma mark - Store Methods

- (void)loadStore {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestProducts];
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    // notifies app that purchase succeeded and passes the product identifier
    
    NSString *productIdentifier = @"";
    if (transaction.payment.productIdentifier) {
        productIdentifier = transaction.payment.productIdentifier;
    } else if (transaction.originalTransaction.payment.productIdentifier) {
        productIdentifier = transaction.payment.productIdentifier;
    }
    
    [self finishTransaction:transaction wasSuccessful:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseCompletedNotification object:self userInfo:@{kProductIDKey:productIdentifier}];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restore Upgrade" message:@"Finished restoring. Enjoy!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[self topVC] presentViewController:alert animated:YES completion:nil];

    // notifies app that purchase was restored and passes the product identifier

    NSString *productIdentifier = @"";
    if (transaction.payment.productIdentifier) {
        productIdentifier = transaction.payment.productIdentifier;
    } else if (transaction.originalTransaction.payment.productIdentifier) {
        productIdentifier = transaction.payment.productIdentifier;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseRestoredNotification object:self userInfo:@{kProductIDKey:productIdentifier}];
    [self finishTransaction:transaction wasSuccessful:YES];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    // closes a failed transaction and logs the error
    if (transaction.error.code != SKErrorPaymentCancelled) {
		NSLog(@"Error: %@", [transaction error]);
        NSString *error = [NSString stringWithFormat:@"Error: %@", [transaction error]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oh no! Is your Apple ID correct?" message:error preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[self topVC] presentViewController:alert animated:YES completion:nil];

        [self finishTransaction:transaction wasSuccessful:NO];
    } else {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	NSLog(@"Payment Queue method called");
    
    // processes the transactions as they work through the queue
	
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
				NSLog(@"payment purchasing");
				break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
				NSLog(@"payment purchased");
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
				NSLog(@"payment failed");
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
				NSLog(@"payment restored");
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"payment deferred");
                break;

            default: break;
        }
    }
}


@end
