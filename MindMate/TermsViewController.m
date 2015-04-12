//
//  TermsViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "TermsViewController.h"
#import "UIColor+Colors.h"

@interface TermsViewController ()

@property (nonatomic, strong) UIButton *menuButton;
@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.text = @"Terms Placeholder";
    [self.view addSubview:label];

    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor customGrayColor];
    self.menuButton.layer.masksToBounds = YES;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)menuPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
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
