//
//  Reminder.h
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *frequency;

- (NSDictionary *)reminderDictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)save;

@end
