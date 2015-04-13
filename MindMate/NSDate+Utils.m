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
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

// Take a date and return an integer based on the time.
// For instance, if passed a date that contains the time 22:30, return 2230
+ (int)timeAsIntegerFromDate:(NSDate *)date {
    NSCalendar *currentCal      = [NSCalendar currentCalendar];
    NSDateComponents *nowComps  = [currentCal components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    return nowComps.hour * 100 + nowComps.minute;
}

+ (NSDate *)midnightTime {
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];

    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];

    return [cal dateFromComponents:components];
}

+ (NSDate *)sixAMTime {
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

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
    int nowTime   = [NSDate timeAsIntegerFromDate:[NSDate date]];

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


    if ([NSDate currentTimeIsBetweenTimeFromStartDate:[NSDate midnightTime] andTimeFromEndDate:[NSDate sixAMTime]]) {
        NSUInteger count = 0;
        dayComponent.day = count;
    } else {
        NSUInteger count = 1;
        dayComponent.day = count;
    }

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];

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

+ (NSDate *)createdAtDate {
    NSDate *now = [NSDate date];
    return now;
}

+ (NSDate *)fetchDateForRecording {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];

    NSUInteger count = -1;
    dayComponent.day = count;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];

    return nextDate;
}

+ (NSDate *)beginningOfDay {
    NSDate *date = [NSDate fetchDateForRecording];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];

    [components setHour:0];
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
