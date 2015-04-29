//
//  AboutViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "AboutViewController.h"
#import "MenuView.h"
#import "UIColor+Colors.h"
@import WebKit;

@interface AboutViewController ()

@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) CGRect frame;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.frame = self.view.frame;
    self.view.backgroundColor = [UIColor whiteColor];

    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    [self.view addSubview:self.menuView];

    [self.menuView.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/7, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)/4)];
    NSString *html = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"about" withExtension:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    [webView loadHTMLString:html baseURL:[[NSBundle mainBundle] URLForResource:@"about" withExtension:@"html"]];
    [self.view addSubview:webView];
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
