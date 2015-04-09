//
//  MenuViewController.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/8/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "MenuViewController.h"
#import "UIColor+Colors.h"
@import QuartzCore;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *menuButton;

@property (nonatomic, strong) UITableViewCell *aboutCell;
@property (nonatomic, strong) UITableViewCell *remindersCell;
@property (nonatomic, strong) UITableViewCell *preferencesCell;
@property (nonatomic, strong) UITableViewCell *tsCell;
@property (nonatomic, strong) UITableViewCell *purchasesCell;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/8, self.view.frame.size.height/6, self.view.frame.size.width - self.view.frame.size.width/4, self.view.frame.size.height/9*5)];
    //self.tableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tableView];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    [self layoutTableViewCells];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor customMenuColor];
    self.menuButton.layer.masksToBounds = YES;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutTableViewCells {
    self.aboutCell = [[UITableViewCell alloc] init];
    self.aboutCell.textLabel.text = @"About";
    self.aboutCell.textLabel.textColor = [UIColor whiteColor];
    self.aboutCell.textLabel.font = [UIFont boldSystemFontOfSize:28];
    self.aboutCell.backgroundColor = [UIColor customPurpleColor];

    self.remindersCell = [[UITableViewCell alloc] init];
    self.remindersCell.textLabel.textColor = [UIColor whiteColor];
    self.remindersCell.textLabel.font = [UIFont boldSystemFontOfSize:28];
    self.remindersCell.textLabel.text = @"Reminders";
    self.remindersCell.backgroundColor = [UIColor customPurpleColor];

    self.preferencesCell = [[UITableViewCell alloc] init];
    self.preferencesCell.textLabel.text = @"Preferences";
    self.preferencesCell.backgroundColor = [UIColor customPurpleColor];
    self.preferencesCell.textLabel.textColor = [UIColor whiteColor];
    self.preferencesCell.textLabel.font = [UIFont boldSystemFontOfSize:28];

    self.tsCell = [[UITableViewCell alloc] init];
    self.tsCell.textLabel.text = @"Terms of Service";
    self.tsCell.backgroundColor = [UIColor customPurpleColor];
    self.tsCell.textLabel.textColor = [UIColor whiteColor];
    self.tsCell.textLabel.font = [UIFont boldSystemFontOfSize:28];

    self.purchasesCell = [[UITableViewCell alloc] init];
    self.purchasesCell.textLabel.text = @"Purchases";
    self.purchasesCell.backgroundColor = [UIColor customPurpleColor];
    self.purchasesCell.textLabel.textColor = [UIColor whiteColor];
    self.purchasesCell.textLabel.font = [UIFont boldSystemFontOfSize:28];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
           // [[StorePurchaseController sharedInstance] purchaseOptionSelectedObjectIndex:0];
            break;
        case 1:
          //  [[StorePurchaseController sharedInstance] restorePurchases];
            break;
        case 2:
         //   [[StorePurchaseController sharedInstance] restorePurchases];
            break;
        case 3:
        //    [[StorePurchaseController sharedInstance] restorePurchases];
            break;
        case 4:
         //   [[StorePurchaseController sharedInstance] restorePurchases];
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return self.aboutCell;
            break;
        case 1:
            return self.remindersCell;
            break;
        case 2:
            return self.preferencesCell;
            break;
        case 3:
            return self.purchasesCell;
            break;
        case 4:
            return self.tsCell;
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (void)menuPressed {
    [self dismissViewControllerAnimated:YES completion:^{

        if ([self.delegate respondsToSelector:@selector(reanimateCircles)]) {
            [self.delegate reanimateCircles];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
