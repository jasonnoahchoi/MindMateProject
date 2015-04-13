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

+ (BOOL)currentTimeIsBetweenTimeFromDate1:(NSDate *)date1 andTimeFromDate2:(NSDate *)date2;

+ (NSDate *)fetchDate;

+ (NSDate *)notificationTime;
+ (NSDate *)createdAtDate;
+ (NSDate *)fetchDateForRecording;
+ (NSDate *)beginningOfDay;
+ (NSDate *)endOfDay;


@end
