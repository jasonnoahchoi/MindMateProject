//
//  RemindersController.h
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reminder;

@interface RemindersController : NSObject

@property (nonatomic, strong, readonly) NSArray *reminders;

+ (RemindersController *)sharedInstance;

- (void)addReminder:(Reminder *)reminder;
- (void)removeReminder:(Reminder *)reminder;

- (void)save;

@end
