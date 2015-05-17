//
//  IAPViewController.m
//  Tomorrow
//
//  Created by Jason Noah Choi on 5/12/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "IAPViewController.h"
#import "MenuView.h"
#import "UIColor+Colors.h"
#import "StorePurchaseController.h"
#import "AudioController.h"
@import QuartzCore;

@interface IAPViewController ()

@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIButton *unlockButton;
@property (nonatomic, strong) UIButton *recordCornerButtonClone;
@property (nonatomic, strong) UIButton *playCornerButton;
@property (nonatomic, strong) UIButton *restoreButton;

@end

@implementation IAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.frame = self.view.frame;

    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    [self.view addSubview:self.menuView];

    [self.menuView.menuButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CGRectGetWidth(self.frame)- 40, CGRectGetHeight(self.frame)/1.5)];
    tempLabel.numberOfLines = 0;
    tempLabel.font = [UIFont fontWithName:@"Open Sans" size:15];
    tempLabel.text = @"CURRENTLY:\n- Even more quotes\n- Quote displayed after playback of recording\n- Minor improved sound quality\n\nFUTURE:\n- Social\n- Scheduled messages\n- Send me some suggestions :)\n\nNOTE: One more screen will pop up to confirm you actually do want to unlock everything";
    [self.view addSubview:tempLabel];

    UILabel *unlockLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)/4.4, CGRectGetWidth(self.frame)/2, 44)];
    unlockLabel.textColor = [UIColor customTextColor];
    unlockLabel.text = @"Unlock Everything";
    unlockLabel.font = [UIFont fontWithName:@"Open Sans" size:13];
    [self.view addSubview:unlockLabel];

    UILabel *restoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/2.8, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)/4.4, CGRectGetWidth(self.frame)/2, 44)];
    restoreLabel.textColor = [UIColor customTextColor];
    restoreLabel.text = @"Restore Purchases";
    restoreLabel.font = [UIFont fontWithName:@"Open Sans" size:13];
    [self.view addSubview:restoreLabel];

    self.restoreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/3, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
    [self.view addSubview:self.restoreButton];
    self.restoreButton.backgroundColor = [UIColor customBlueColor];
    self.restoreButton.layer.cornerRadius = self.restoreButton.frame.size.height/2;
    self.restoreButton.layer.masksToBounds = YES;
    self.restoreButton.layer.shouldRasterize = YES;
    [self.restoreButton addTarget:self action:@selector(restoreFeatures) forControlEvents:UIControlEventTouchUpInside];

    self.unlockButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - CGRectGetWidth(self.frame)/6, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame)/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
    [self.view addSubview:self.unlockButton];
    self.unlockButton.backgroundColor = [UIColor customGreenColor];
    self.unlockButton.layer.cornerRadius = self.unlockButton.frame.size.height/2;
    self.unlockButton.layer.masksToBounds = YES;
    self.unlockButton.layer.shouldRasterize = YES;
    [self.unlockButton addTarget:self action:@selector(unlockFeatures) forControlEvents:UIControlEventTouchUpInside];
}

- (void)unlockFeatures {
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.unlockButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        [[AudioController sharedInstance].babyPopAgainPlayer play];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.unlockButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(unlocking) userInfo:nil repeats:NO];
        }];
    }];
}

- (void)restoreFeatures {
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.restoreButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        [[AudioController sharedInstance].babyPopAgainTwoPlayer play];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.restoreButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(restoring) userInfo:nil repeats:NO];
        }];
    }];
}

- (void)unlocking {
    [[StorePurchaseController sharedInstance] purchaseOptionSelectedObjectIndex:0];
}

- (void)restoring {
    [[StorePurchaseController sharedInstance] restorePurchases];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
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
