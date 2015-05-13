//
//  NSDate+Utils.m
//  MindMate
//
//  Created by Jason Noah Choi on 3/30/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

+ (NSDate *)dateWithoutTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

// Take a date and return an integer based on the time.
+ (int)timeAsIntegerFromDate:(NSDate *)date {
    NSCalendar *currentCal      = [NSCalendar currentCalendar];
    currentCal.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *nowComps  = [currentCal components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    return nowComps.hour * 100 + nowComps.minute;
}

//- (NSDate *)dateByAddingHours:(NSInteger)hours {
//    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + 
//}

+ (NSDate *)midnightTime {
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone localTimeZone];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];

    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];

    return [cal dateFromComponents:components];
}

+ (NSDate *)sixAMTime {
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone localTimeZone];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];

    [components setHour:6];
    [components setMinute:0];
    [components setSecond:0];

    return [cal dateFromComponents:components];
}


// Check to see if the current time is between the two arbitrary times, ignoring the date portion:
+ (BOOL)currentTimeIsBetweenTimeFromStartDate:(NSDate *)startDate andTimeFromEndDate:(NSDate *)endDate {
    // date1 = [self midnightTime];
    // date2 = [self sixAMTime];
    int time1     = [NSDate timeAsIntegerFromDate:startDate];
    int time2     = [NSDate timeAsIntegerFromDate:endDate];
    int nowTime   = [NSDate timeAsIntegerFromDate:[self createdAtDate]];

    // If the times are the same, we can never be between them
    if (time1 == time2) {
        return NO;
    }

    // Two cases:
    // 1.  Time 1 is smaller than time 2 which means that they are both on the same day
    // 2.  the reverse (time 1 is bigger than time 2) which means that time 2 is after midnight
    if (time1 < time2) {
        // Case 1
        if (nowTime > time1) {
            if (nowTime < time2) {
                return YES;
            }
        }
        return NO;
    } else {
        // Case 2
        if (nowTime > time1 || nowTime < time2) {
            return YES;
        }
        return NO;
    }
}

+ (NSDate *)fetchDate {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.timeZone = [NSTimeZone localTimeZone];


    if ([NSDate currentTimeIsBetweenTimeFromStartDate:[NSDate midnightTime] andTimeFromEndDate:[NSDate sixAMTime]]) {
        NSUInteger count = 0;
        dayComponent.day = count;
    } else {
        NSUInteger count = 1;
        dayComponent.day = count;
    }

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[self createdAtDate] options:0];

    return nextDate;
}


+ (NSDate *)notificationTime {
    NSDate *date = [self fetchDate];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
    [components setHour:12];

    [components setMinute:0];

    [components setSecond:0];
    
    return [cal dateFromComponents:components];
}

+ (NSDate *)reminderNotificationTime {
    NSDate *date = [self fetchDate];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
    [components setHour:18];

    [components setMinute:0];

    [components setSecond:0];

    return [cal dateFromComponents:components];
}

+ (NSDate *)beenLongTimeNotification {
    NSDate *date = [self fetchDate];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [components setHour: 18];
    [components setMinute:00];
    [components setSecond:00];

    NSDate *tempDate = [cal dateFromComponents: components];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:3];
    NSDate *fireDateOfNotification = [cal dateByAddingComponents:comps
                                                          toDate:tempDate
                                                         options:0];
    return fireDateOfNotification;
}

+ (NSDate *)createdAtDate {
    NSDate *now = [NSDate date];
    return now;
}

+ (NSDate *)fetchDateForRecording {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.timeZone = [NSTimeZone localTimeZone];

    if ([NSDate currentTimeIsBetweenTimeFromStartDate:[NSDate midnightTime] andTimeFromEndDate:[NSDate sixAMTime]]) {
        NSUInteger count = 0;
        dayComponent.day = count;
    } else {
        NSUInteger count = -1;
        dayComponent.day = count;
    }

    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[self createdAtDate] options:0];

    return nextDate;
}

+ (NSDate *)beginningOfDay {
    NSDate *date = [NSDate fetchDateForRecording];
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone localTimeZone];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];

    [components setHour:6];
    [components setMinute:0];
    [components setSecond:0];

    return [cal dateFromComponents:components];
}

+ (NSDate *)endOfDay {
    NSDate *date = [NSDate fetchDateForRecording];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
    //    [components setYear:0];
    //    [components setMonth:0];
    //    [components setDay:1];

    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];

    //    NSUInteger count = 1;
    //    components.day = count;

    return [cal dateByAddingComponents:components toDate:[NSDate beginningOfDay] options:0];
}

@end
