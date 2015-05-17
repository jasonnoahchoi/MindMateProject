//
//  SupportViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "SupportViewController.h"
#import "UIColor+Colors.h"
#import "MenuView.h"
@import MessageUI;
@import QuartzCore;


@interface SupportViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) UIButton *composeEmailButton;
@property (nonatomic, assign) CGRect frame;

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.frame = self.view.frame;

    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    [self.view addSubview:self.menuView];

    [self.menuView.menuButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(self.view.frame)/2)];
    tempLabel.numberOfLines = 0;
    tempLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
    tempLabel.text = @"Let me know if you have any questions or suggestions. I will absolutely read and consider every email, but I can't respond to them all. Thank you for understanding.";
    tempLabel.textAlignment = NSTextAlignmentCenter;

    self.composeEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/3 - 30, CGRectGetHeight(self.frame)/2 + 70, CGRectGetWidth(self.frame)/3 + 60, 44)];
    [self.view addSubview:self.composeEmailButton];
    [self.composeEmailButton setTitle:@"Send Feedback" forState:UIControlStateNormal];
    [self.composeEmailButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.composeEmailButton.layer.borderWidth = 2;
    self.composeEmailButton.layer.cornerRadius = 10;
    self.composeEmailButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.composeEmailButton.tintColor = [UIColor darkGrayColor];
    [self.composeEmailButton addTarget:self action:@selector(sendFeedbackEmail:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:tempLabel];
    [self.view addSubview:self.composeEmailButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)sendFeedbackEmail:(id)sender {
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController setToRecipients:@[@"jason@tomorrow.gives"]];
    [mailComposeViewController setSubject:@"Feedback for Tomorrow"];
    [mailComposeViewController.navigationBar setTintColor:[UIColor customBlueColor]];
    
    if ([MFMailComposeViewController canSendMail]) {
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
