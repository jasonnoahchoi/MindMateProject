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
#import "RemindersViewController.h"
#import "AboutViewController.h"
#import "SupportViewController.h"
#import "TermsViewController.h"
#import "AudioController.h"
#import "IntroViewController.h"
#import "MenuView.h"
#import "IAPViewController.h"

static NSString * const soundEffectsOnKey = @"soundEffects";

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MenuView *menuView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableViewCell *aboutCell;
@property (nonatomic, strong) UITableViewCell *remindersCell;
@property (nonatomic, strong) UITableViewCell *rateCell;
@property (nonatomic, strong) UITableViewCell *tsCell;
@property (nonatomic, strong) UITableViewCell *feedbackCell;
@property (nonatomic, strong) UITableViewCell *preferencesCell;
@property (nonatomic, strong) UITableViewCell *introCell;
@property (nonatomic, strong) UITableViewCell *IAPCell;

@property (nonatomic, strong) UISwitch *soundToggle;
@property (nonatomic, assign) BOOL soundEffectsOn;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/8, self.view.frame.size.height/6, self.view.frame.size.width - self.view.frame.size.width/4, self.view.frame.size.height/12*7)];
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
    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    [self.view addSubview:self.menuView];

    [self.menuView.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutTableViewCells {
    self.aboutCell = [[UITableViewCell alloc] init];
    self.aboutCell.textLabel.text = @"About";
    self.aboutCell.textLabel.textColor = [UIColor whiteColor];
    self.aboutCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
    self.aboutCell.backgroundColor = [UIColor customPurpleColor];

    self.IAPCell = [[UITableViewCell alloc] init];
    self.IAPCell.textLabel.text = @"Unlock Everything";
    self.IAPCell.textLabel.textColor = [UIColor customGreenColor];
    self.IAPCell.backgroundColor = [UIColor customPurpleColor];
    self.IAPCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];

    self.remindersCell = [[UITableViewCell alloc] init];
    self.remindersCell.textLabel.textColor = [UIColor whiteColor];
    self.remindersCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
    self.remindersCell.textLabel.text = @"Reminders";
    self.remindersCell.backgroundColor = [UIColor customPurpleColor];

    self.rateCell = [[UITableViewCell alloc] init];
    self.rateCell.textLabel.text = @"Please Rate Tomorrow";
    self.rateCell.backgroundColor = [UIColor customPurpleColor];
    self.rateCell.textLabel.textColor = [UIColor customBlueColor];
    self.rateCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];

    self.tsCell = [[UITableViewCell alloc] init];
    self.tsCell.textLabel.text = @"Terms of Service";
    self.tsCell.backgroundColor = [UIColor customPurpleColor];
    self.tsCell.textLabel.textColor = [UIColor whiteColor];
    self.tsCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];

    self.feedbackCell = [[UITableViewCell alloc] init];
    self.feedbackCell.textLabel.text = @"Send Feedback";
    self.feedbackCell.backgroundColor = [UIColor customPurpleColor];
    self.feedbackCell.textLabel.textColor = [UIColor whiteColor];
    self.feedbackCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];

    self.introCell = [[UITableViewCell alloc] init];
    self.introCell.textLabel.text = @"How to Use Tomorrow";
    self.introCell.textLabel.textColor = [UIColor whiteColor];
    self.introCell.backgroundColor = [UIColor customPurpleColor];
    self.introCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];

    self.preferencesCell = [[UITableViewCell alloc] init];
    self.preferencesCell.textLabel.text = @"Sound Effects";
    self.preferencesCell.backgroundColor = [UIColor customPurpleColor];
    self.preferencesCell.textLabel.textColor = [UIColor whiteColor];
    self.soundToggle = [[UISwitch alloc] init];
    self.soundToggle.tintColor = [UIColor customSwitchPurpleColor];
    self.soundToggle.onTintColor = [UIColor customSwitchPurpleColor];
    self.soundToggle.on = YES;
    [self.soundToggle addTarget:self action:@selector(soundToggleState) forControlEvents:UIControlEventValueChanged];
    self.preferencesCell.accessoryView = self.soundToggle;
    self.preferencesCell.textLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
}

- (void)soundToggleState {
    if (!self.soundToggle.on) {
        self.soundEffectsOn = NO;
    } else {
        self.soundEffectsOn = YES;
    }
    [[NSUserDefaults standardUserDefaults] setBool:self.soundEffectsOn forKey:soundEffectsOnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            AboutViewController *aboutVC = [[AboutViewController alloc] init];
            [self presentViewController:aboutVC animated:YES completion:nil];
        }
            break;
        case 1: {
            SupportViewController *supportVC = [[SupportViewController alloc] init];
            [self presentViewController:supportVC animated:YES completion:nil];
            break;
        }
        case 2: {
            IAPViewController *iapVC = [[IAPViewController alloc] init];
            [self presentViewController:iapVC animated:YES completion:nil];
        }
            break;
        case 3: {
            NSString *appID = @"984969197";
            NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID]];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
            break;
        case 4: {
            TermsViewController *termsVC = [[TermsViewController alloc] init];
            [self presentViewController:termsVC animated:YES completion:nil];
        }
            break;
        case 5: {
            IntroViewController *introVC = [[IntroViewController alloc] init];
            [self presentViewController:introVC animated:YES completion:nil];
        }
            break;
        case 6:
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
            return self.feedbackCell;
            break;
        case 2:
            return self.IAPCell;
            break;
        case 3:
            return self.rateCell;
            break;
        case 4:
            return self.tsCell;
            break;
        case 5:
            return self.introCell;
            break;
        case 6:
            return self.preferencesCell;
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


- (void)menuPressed {
    self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
    if (self.soundEffectsOn) {
        [[AudioController sharedInstance].menuSoundPlayer play];
    }
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
