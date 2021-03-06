//
//  RemindersTableViewDataSource.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "RemindersTableViewDataSource.h"
#import "CustomDatePickerView.h"
#import "RemindersController.h"
#import "Reminder.h"
#import "UIColor+Colors.h"

static NSString * const cellIdentifier = @"cell";

@interface RemindersTableViewDataSource ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RemindersTableViewDataSource

- (void)registerTableView:(UITableView *)tableView {
    self.tableView = tableView;
    self.tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RemindersController sharedInstance].reminders.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    NSInteger index = [RemindersController sharedInstance].reminders.count;
    if (indexPath.row == index) {
        cell.textLabel.text = @"Add Reminder";
        cell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
    } else {
        Reminder *reminder = [[RemindersController sharedInstance].reminders objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", reminder.frequency, [NSDateFormatter localizedStringFromDate:reminder.date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Reminder *reminder = [RemindersController sharedInstance].reminders[indexPath.row];
        [[RemindersController sharedInstance] removeReminder:reminder];
        
        UILocalNotification *notification = [UIApplication sharedApplication].scheduledLocalNotifications[indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [RemindersController sharedInstance].reminders.count) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == [RemindersController sharedInstance].reminders.count) {
        CustomDatePickerView *datePickerView = [[CustomDatePickerView alloc] init];
        datePickerView.tableView = self.tableView;
        [self.tableView addSubview:datePickerView];
        if ([[UIScreen mainScreen] bounds].size.width == 375) {
            datePickerView.frame = CGRectMake(45, -280, 280, 250);
            [UIView animateWithDuration:1.0 animations:^{
                datePickerView.center = CGPointMake(datePickerView.center.x, datePickerView.center.y + 433);
            }];
        } else if ([[UIScreen mainScreen] bounds].size.width > 375) {
            datePickerView.frame = CGRectMake(65, -280, 280, 250);
            [UIView animateWithDuration:1.0 animations:^{
                datePickerView.center = CGPointMake(datePickerView.center.x, datePickerView.center.y + 500);
            }]; // 6+
        } else {
            datePickerView.frame = CGRectMake(20, -280, 280, 250);
            [UIView animateWithDuration:1.0 animations:^{
                datePickerView.center = CGPointMake(datePickerView.center.x, datePickerView.center.y + 380);
            }]; // 4s/5/5s
        }
    }
}

@end
