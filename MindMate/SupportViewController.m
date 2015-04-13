//
//  SupportViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "SupportViewController.h"
#import "UIColor+Colors.h"
@import MessageUI;
@import QuartzCore;


@interface SupportViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, assign) CGRect frame;

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.frame = self.view.frame;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCard)];
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor customGrayColor];
    self.menuButton.layer.masksToBounds = YES;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 300, 80)];
    tempLabel.numberOfLines = 0;
    tempLabel.font = [UIFont systemFontOfSize:24];
    tempLabel.text = @"Let us know if you have any questions or suggestions.";
    tempLabel.textAlignment = NSTextAlignmentCenter;
    
    
    // Sets email compose
    UIButton *composeEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/3 - 30, CGRectGetHeight(self.frame)/2 + 70, CGRectGetWidth(self.frame)/3 + 60, 44)];
    [self.view addSubview:composeEmailButton];
    [composeEmailButton setTitle:@"Send Feedback" forState:UIControlStateNormal];
    [composeEmailButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    composeEmailButton.layer.borderWidth = 2;
    composeEmailButton.layer.cornerRadius = 10;
     composeEmailButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    composeEmailButton.tintColor = [UIColor lightGrayColor];
    [composeEmailButton addTarget:self action:@selector(sendFeedbackEmail:) forControlEvents:UIControlEventTouchUpInside];
    [composeEmailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self.view addSubview:tempLabel];
    [self.view addSubview:composeEmailButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)sendFeedbackEmail:(id)sender {
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController setToRecipients:@[@"jasonnoahchoi@gmail.com"]];
    [mailComposeViewController setSubject:@"Feedback for Tomorrow"];
    [mailComposeViewController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if ([MFMailComposeViewController canSendMail]) {
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

// allows user to hit 'cancel' and exit
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
//    [self.drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
