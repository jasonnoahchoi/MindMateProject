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

@end

@implementation RemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"Reminders";
//     UIImage *backButton = [UIImage imageNamed:@"backbutton"];
//    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backButtonWithImage:backButton target:self action:@selector(done)];
//    //[self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

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

    
    self.dataSource = [[RemindersTableViewDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    [self.dataSource registerTableView:self.tableView];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
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
