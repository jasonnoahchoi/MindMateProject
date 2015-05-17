//
//  NSDate+Utils.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/30/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

+ (NSDate *)dateWithoutTime;

+ (int)timeAsIntegerFromDate:(NSDate *)date;

+ (NSDate *)midnightTime;

+ (NSDate *)sixAMTime;

+ (BOOL)currentTimeIsBetweenTimeFromStartDate:(NSDate *)startDate andTimeFromEndDate:(NSDate *)endDate;

+ (NSDate *)fetchDate;
+ (NSDate *)reminderNotificationTime;
+ (NSDate *)beenLongTimeNotification;
+ (NSDate *)reallyLongTimeNotification;

+ (NSDate *)notificationTime;
+ (NSDate *)createdAtDate;
+ (NSDate *)fetchDateForRecording;
+ (NSDate *)beginningOfDay;
+ (NSDate *)endOfDay;


@end
