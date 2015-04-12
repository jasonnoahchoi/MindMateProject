//
//  SupportViewController.m
//  cardalot
//
//  Created by Ross McIlwaine on 3/15/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "SupportViewController.h"
#import <MMDrawerController.h>
#import "CardViewController.h"
#import "UIColor+Colors.h"
#import <MessageUI/MessageUI.h>
@import MessageUI;

@interface SupportViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Support";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCard)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 300, 80)];
    tempLabel.numberOfLines = 0;
    tempLabel.text = @"Let us know if you have any questions or suggestions.";
    
    
    // Sets email compose
    UIButton *composeEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 180, 80)];
    composeEmailButton.tintColor = [UIColor lightGrayColor];
    composeEmailButton.layer.borderWidth = 1.0;
    composeEmailButton.layer.cornerRadius = 3;
    composeEmailButton.layer.borderColor = [UIColor customBlueColor].CGColor;
    [composeEmailButton setTitle:@"Send feedback" forState:UIControlStateNormal];
    [composeEmailButton setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
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
    
    [mailComposeViewController setToRecipients:@[@"weekendconcept@gmail.com"]];
    [mailComposeViewController setSubject:@""];
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

- (void)addCard {
    CardViewController *cardVC = [[CardViewController alloc] init];
    [self.navigationController pushViewController:cardVC animated:YES];
}

@end
