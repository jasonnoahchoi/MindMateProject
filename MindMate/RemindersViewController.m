//
//  RemindersViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "RemindersViewController.h"
#import "RemindersTableViewDataSource.h"
#import "UIColor+Colors.h"

@interface RemindersViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) RemindersTableViewDataSource *dataSource;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *notificationLabel;

@end

@implementation RemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor customGrayColor];
    self.menuButton.layer.masksToBounds = YES;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];


    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height/6) style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];

    self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMidX(self.view.frame), CGRectGetWidth(self.view.frame) - 30, CGRectGetWidth(self.view.frame))];
    [self.view addSubview:self.notificationLabel];
    self.notificationLabel.hidden = YES;
    self.notificationLabel.numberOfLines = 0;

    self.dataSource = [[RemindersTableViewDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    [self.dataSource registerTableView:self.tableView];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) { // Check it's iOS 8 and above

        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];

        if (grantedSettings.types == UIUserNotificationTypeNone) {
            self.notificationLabel.text = @"To set up reminders, you must enable notifications. Please exit Tomorrow and go to Settings > Notifications > Tomorrow > Allow Notifications and turn on the switch.";
            self.notificationLabel.alpha = 0;
            self.notificationLabel.hidden = NO;
            self.tableView.hidden = YES;
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.notificationLabel.alpha = 1;
            } completion:nil];
           // NSLog(@"No permission granted");
        }
        else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){
           // NSLog(@"Sound and alert permissions ");
            self.notificationLabel.hidden = YES;
            self.tableView.hidden = NO;
        }
        else if (grantedSettings.types  & UIUserNotificationTypeAlert){
            self.notificationLabel.hidden = YES;
            self.tableView.hidden = NO;
           // NSLog(@"Alert Permission Granted");
        }
    }
}

- (void)currrentUserNotificationSettings {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil]];
}

- (void)done {
//    [self.drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

@end
