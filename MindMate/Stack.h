//
//  Stack.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Stack : NSObject

+ (Stack *)sharedInstance;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
