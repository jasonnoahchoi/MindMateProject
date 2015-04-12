//
//  AboutViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+Colors.h"

@interface AboutViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, assign) CGRect frame;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor customGrayColor];
    self.menuButton.layer.masksToBounds = YES;
    self.frame = self.view.frame;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/7, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)/4)];
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.numberOfLines = 0;
    self.label.text = @"This is where I thank people";
   // self.label.text = @"Thank you to the following people: \n\nDesign & UX Guidance: Ben Adamson\nIntro Voice: Krista\nTechnical Guidance: Caleb Hicks, Bryan Bryce, Joshua Howland, Andrew Madsen, Taylor Mott, Daniel Curvelo, Shawn Sou \n\nFinally, a very special thanks to my family and friends for their support and DevMountain for guiding me throughout these past few months.";

  //  self.label.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.label];
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
