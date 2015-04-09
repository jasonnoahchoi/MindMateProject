//
//  MenuViewController.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/8/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *menuButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor blueColor];
    self.menuButton.layer.masksToBounds = YES;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
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
