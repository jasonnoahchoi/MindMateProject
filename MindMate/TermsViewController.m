//
//  TermsViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 4/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "TermsViewController.h"
#import "MenuView.h"
#import "UIColor+Colors.h"
@import WebKit;

@interface TermsViewController ()

@property (nonatomic, strong) MenuView *menuView;

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    [self.view addSubview:self.menuView];

    [self.menuView.menuButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/10, CGRectGetHeight(self.view.frame)/7, CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.view.frame)/5, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.view.frame)/4)];
    NSString *html = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"privacy" withExtension:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    [webView loadHTMLString:html baseURL:[[NSBundle mainBundle] URLForResource:@"privacy" withExtension:@"html"]];
    [self.view addSubview:webView];

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
