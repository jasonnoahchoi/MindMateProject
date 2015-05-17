//
//  ViewController.m
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "AudioViewController.h"
#import "ButtonView.h"
#import "CategoryContainerView.h"
#import "MenuView.h"
#import "RecordingController.h"
#import "Recording.h"
#import "AudioController.h"
#import "UIColor+Colors.h"
#import "TimeAndDateView.h"
#import "MenuViewController.h"
#import "NSDate+Utils.h"
#import "QuotesController.h"
#import "NSArray+RecordPlayStrings.h"
#import "RecordPlayView.h"
#import "PurchasedDataController.h"
#import "StorePurchaseController.h"
#import "SupportViewController.h"
#import "IntroViewController.h"

static NSString * const hasRecordingsKey = @"hasRecordings";
static NSString * const numberOfRecordingsKey = @"numberOfRecordings";
static NSString * const soundEffectsOnKey = @"soundEffects";
static NSString * const launchCountKey = @"launchCount";
static NSString * const remindLaterKey = @"remind";
static NSString * const clickedRateKey = @"rate";

@interface AudioViewController () <CategoryContainerViewDelegate, ButtonViewDelegate, MenuViewControllerDelegate>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) CategoryContainerView *containerView;
@property (nonatomic, strong) TimeAndDateView *tdView;
@property (nonatomic, strong) Recording *record;
@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) RecordPlayView *recordPlayView;
@property (nonatomic, strong) IntroViewController *introVC;

@property (nonatomic) CircleState circleState;

@property (nonatomic, strong) NSMutableArray *mutableRecordings;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *quoteLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *recordAgainButton;
@property (nonatomic, strong) UIButton *recordCornerButton;
@property (nonatomic, strong) UIButton *playCornerButton;
@property (nonatomic, strong) UIButton *centerRecordButtonClone;
@property (nonatomic, strong) UIButton *centerPlayButtonClone;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGPoint centerRecordAgainButton;
@property (nonatomic, assign) CGPoint centerConfirmButton;
@property (nonatomic, assign) CGPoint endPointRecordAgainButton;
@property (nonatomic, assign) CGPoint endPointConfirmButton;
@property (nonatomic, assign) CGPoint centerRecordButton;
@property (nonatomic, assign) CGPoint centerPlayButton;
@property (nonatomic, assign) CGPoint endPointRecordCornerButton;
@property (nonatomic, assign) CGPoint endPointPlayCornerButton;
@property (nonatomic, assign) CGPoint hidingPointRecordCornerPoint;
@property (nonatomic, assign) CGPoint hidingPointPlayCornerPoint;
@property (nonatomic, assign) CGPoint middlePointRecordCornerButton;
@property (nonatomic, assign) CGPoint middlePointPlayCornerButton;
@property (nonatomic, assign) CGPoint middlePointOfButton;
@property (nonatomic, assign) CGPoint halfwayPointRecorderCornerPoint;
@property (nonatomic, assign) CGPoint halfwayPointPlayCornerPoint;
@property (nonatomic, assign) CGRect circleRect;

@property (nonatomic, assign) NSInteger indexForRecording;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSUInteger sameRandomIndex;
@property (nonatomic, assign) NSNumber *groupIDNumber;
@property (nonatomic, assign) BOOL showedMenuVC;
@property (nonatomic, assign) BOOL hasPlayed;
@property (nonatomic, assign) BOOL micOn;
@property (nonatomic, assign) BOOL soundEffectsOn;
@property (nonatomic, assign) BOOL goPro;
@property (nonatomic, assign) BOOL clickedRate;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.circleState = CircleStateRecord;
    [self loadRecordingsToPlay];
    //self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    //self.title = @"Record";
    self.groupIDNumber = @0;
    self.frame = self.view.frame;
    [self afterRecordButtons];
    [self micCheck];
    CGSize size = self.view.superview.frame.size;
    [self.view setCenter:CGPointMake(size.width/2, size.height/2)];

    self.circleRect = CGRectMake(CGRectGetWidth(self.frame)/8, self.view.frame.size.height/5, CGRectGetWidth(self.frame)/1.35, CGRectGetWidth(self.frame)/1.35);
    self.buttonView = [[ButtonView alloc] initWithFrame:self.circleRect];
    //self.buttonView.center = self.view.center;
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];
    self.buttonView.hidden = YES;

    if (![AudioController sharedInstance]) {
        [AudioController sharedInstance];
    };

    self.tdView = [[TimeAndDateView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 30, self.view.frame.size.width/2-10, 100)];

    [self.view addSubview:self.tdView];
    self.recordPlayView = [[RecordPlayView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/12, CGRectGetHeight(self.frame)/18, CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/10)];
    [self.view addSubview:self.recordPlayView];
    self.recordPlayView.hidden = YES;

    self.menuVC = [[MenuViewController alloc] init];
    self.menuVC.delegate = self;
    self.menuView = [[MenuView alloc] init];

    self.goPro = [PurchasedDataController sharedInstance].goPro;
    [self inAppPurchase];

    
    self.clickedRate = [[NSUserDefaults standardUserDefaults] boolForKey:clickedRateKey];

    [self layoutUnderCircleLabel];
    [self initQuotes];
    [self showQuote];
}

#pragma mark - Helper Methods

- (void)startScreen {
    [self buttonClones];
    [self initialAnimation];
    [self layoutMenuButton];
    [self cornerButtons];
    [self showMessageForHasRecordings];
}

- (void)setAlphaOfBottomButtons {
    self.confirmButton.alpha = 1;
    self.recordAgainButton.alpha = 1;
}

- (void)layoutUnderCircleLabel {
    self.recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/12, CGRectGetMaxY(self.frame) - CGRectGetHeight(self.frame)/2.9, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/6, self.view.frame.size.height/5)];
    [self.view addSubview:self.recordLabel];
    self.recordLabel.hidden = YES;
    if ([[UIScreen mainScreen] bounds].size.width == 320 && [[UIScreen mainScreen] bounds].size.height == 480) {
        self.recordLabel.font = [UIFont fontWithName:@"Open Sans" size:14];
    } else if ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height > 480) {
        self.recordLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
    }
    //self.recordLabel.text = @"Saved";
    self.recordLabel.numberOfLines = 0;
    self.recordLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
    self.recordLabel.textColor = [UIColor customTextColor];
    self.recordLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)initQuotes {
    self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/12, CGRectGetHeight(self.frame)/12, CGRectGetWidth(self.frame)-CGRectGetWidth(self.frame)/6, CGRectGetHeight(self.frame)-CGRectGetHeight(self.frame)/4)];
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    self.quoteLabel.textColor = [UIColor customTextColor];
    self.quoteLabel.font = [UIFont fontWithName:@"Open Sans" size:22];
    self.quoteLabel.alpha = 0;
    self.nameLabel = [[UILabel alloc] initWithFrame:self.recordLabel.frame];
    self.nameLabel.textColor = [UIColor customTextColor];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans-Italic" size:18];
    self.nameLabel.alpha = 0;
    [self.view addSubview:self.quoteLabel];
    [self.view addSubview:self.nameLabel];
}

- (void)rateApp {
    BOOL remind = [[NSUserDefaults standardUserDefaults] boolForKey:remindLaterKey];
    if (self.clickedRate != YES && ([RecordingController sharedInstance].memos.count > 2 || remind)) {
        UIAlertController *rateAppAlertController = [UIAlertController alertControllerWithTitle:@"Rate Tomorrow" message:@"If you enjoy using Tomorrow, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!" preferredStyle:UIAlertControllerStyleAlert];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Rate It Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"rate app");
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:clickedRateKey];
            NSString *appID = @"984969197";
            NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID]];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }]];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Not a Fan" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            SupportViewController *rateAppVC = [[SupportViewController alloc] init];
            //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rateAppVC];
            [self presentViewController:rateAppVC animated:YES completion:nil];
        }]];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Remind Me Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:remindLaterKey];
        }]];

        [self presentViewController:rateAppAlertController animated:YES completion:nil];
    }
}


#pragma mark - In App Purchases
- (void)inAppPurchase {
    [[StorePurchaseController sharedInstance] requestProducts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRequested:) name:kInAppPurchaseFetchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsPurchased:) name:kInAppPurchaseCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRestored:) name:kInAppPurchaseRestoredNotification object:nil];
}

- (void)productsRequested:(NSNotification *)notification {
}

- (void)productsPurchased:(NSNotification *)notification {
    self.goPro = YES;
}

- (void)productsRestored:(NSNotification *)notification {
    self.goPro = YES;
}

#pragma mark - Animations
- (void)initialAnimation {
    [UIView animateWithDuration:.3 delay:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
        if (self.soundEffectsOn) {
            [[AudioController sharedInstance].babyPopPlayer play];
        }
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.buttonView.recordButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)hideBottomButtons {
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recordAgainButton.center = self.centerRecordAgainButton;
        self.confirmButton.center = self.centerConfirmButton;
        // self.confirmLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.recordAgainButton.hidden = YES;
        self.confirmButton.hidden = YES;
    }];
    self.containerView.alpha = 1;
    self.containerView.hidden = YES;
}

- (void)showBottomButtons {
    self.recordAgainButton.alpha = 1;
    self.recordAgainButton.hidden = NO;
    self.confirmButton.alpha = 1;
    self.confirmButton.hidden = NO;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recordAgainButton.center = self.endPointRecordAgainButton;
        self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
        self.confirmButton.center = self.endPointConfirmButton;
        self.confirmButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordAgainButton.transform = CGAffineTransformIdentity;
            self.confirmButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)reanimateCircles {
    switch (self.circleState) {
        case (CircleStateNone):
        case (CircleStateLoad):
        case (CircleStateRecord):
        {
            self.centerRecordButtonClone.center = self.endPointRecordCornerButton;
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.menuView.menuButton.alpha = 0;
                    self.menuView.menuButton.hidden = NO;
                    self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.menuView.menuButton.alpha = 1;
                        self.centerRecordButtonClone.center = self.middlePointRecordCornerButton;
                        self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.centerRecordButtonClone.center = self.halfwayPointRecorderCornerPoint;
                            self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.centerRecordButtonClone.center = self.buttonView.center;
                                self.centerRecordButtonClone.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                self.buttonView.hidden = NO;
                                self.centerRecordButtonClone.hidden = YES;
                                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                    self.menuView.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                                    self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.menuView.menuButton.transform = CGAffineTransformIdentity;
                                        self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveLinear animations:^{
                                            self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                                        } completion:nil];

                                    }];
                                    //self.buttonView.hidden = NO;
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
            break;
        case (CircleStatePlay):
        {
            self.centerPlayButtonClone.hidden = NO;
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.centerPlayButtonClone.center = self.endPointPlayCornerButton;
                self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.menuView.menuButton.alpha = 0;
                    self.menuView.menuButton.hidden = NO;
                    self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.menuView.menuButton.alpha = 1;
                        self.centerPlayButtonClone.center = self.middlePointPlayCornerButton;
                        self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.centerPlayButtonClone.center = self.halfwayPointPlayCornerPoint;
                            self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.centerPlayButtonClone.center = self.buttonView.center;
                                self.centerPlayButtonClone.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                self.buttonView.hidden = NO;
                                self.centerPlayButtonClone.hidden = YES;
                                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                    self.menuView.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                                    self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.menuView.menuButton.transform = CGAffineTransformIdentity;
                                        self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveLinear animations:^{
                                            self.buttonView.playButton.transform = CGAffineTransformIdentity;
                                        } completion:nil];
                                    }];
                                    //self.buttonView.hidden = NO;
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
    }
}

- (void)addPlayButtonAnimation {
    [UIView animateWithDuration:.25 delay:.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.playCornerButton.hidden = NO;
        self.playCornerButton.alpha = 1;
        self.playCornerButton.center = self.endPointPlayCornerButton;
        self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    } completion:^(BOOL finished) {
        self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
        if (self.soundEffectsOn) {
            [[AudioController sharedInstance].babyPopAgainPlayer play];
        }
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.playCornerButton.transform = CGAffineTransformIdentity;
            self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:nil];
    }];
}

- (void)showMessageForHasRecordings {
    self.circleState = CircleStateLoad;
    if (self.circleState == CircleStateLoad) {
        if ([RecordingController sharedInstance].memos.count > 0) {
            self.recordLabel.alpha = 0;
            self.recordLabel.hidden = NO;
            NSUInteger randomIndex = arc4random() % [[NSArray arrayOfMessagesArrived] count];
            NSUInteger randomIndexRecord = arc4random() % [[NSArray arrayOfRecordYourselfMessages] count];
            self.recordLabel.text = [NSArray arrayOfMessagesArrived][randomIndex];
            [UIView animateWithDuration:.5 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 delay:2 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.recordLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.recordLabel.text = @"Record something today for tomorrow with some inspiration...";
                    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.recordLabel.alpha = 1;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.5 delay:1 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                            self.recordLabel.alpha = 0;
                        } completion:^(BOOL finished) {
                            self.recordLabel.text = [NSArray arrayOfRecordYourselfMessages][randomIndexRecord];
                            [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                                self.recordLabel.alpha = 1;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.5 delay:2.5 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                                    self.recordLabel.alpha = 0;
                                } completion:^(BOOL finished) {
//                                    self.circleState = CircleStateRecord;
                                }];
                            }];
                        }];

                    }];
                }];
            }];
        } else {
            self.recordLabel.alpha = 0;
            self.recordLabel.hidden = NO;
            NSUInteger randomIndex = arc4random() % [[NSArray arrayOfRecordYourselfMessages] count];
            self.recordLabel.text = [NSArray arrayOfRecordYourselfMessages][randomIndex];
            [UIView animateWithDuration:.5 delay:1.5 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                self.recordLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 delay:2 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.recordLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.reminderNotification = [[UILocalNotification alloc] init];
                    NSUInteger randomIndexRecord = arc4random() % [[NSArray arrayOfRecordYourselfMessages] count];
                    self.reminderNotification.alertBody = [NSArray arrayOfRecordYourselfMessages][randomIndexRecord];
                    self.reminderNotification.timeZone = [NSTimeZone localTimeZone];
                    self.reminderNotification.fireDate = [NSDate reminderNotificationTime];
                    self.reminderNotification.applicationIconBadgeNumber = 1;
                    self.reminderNotification.soundName = @"babypopagain.caf";
                    [[UIApplication sharedApplication] scheduleLocalNotification:self.reminderNotification];
//                    self.circleState = CircleStateRecord;
                }];
            }];
        }
    }

}

- (void)showQuote {
    NSArray *quotesArray = [[QuotesController sharedInstance] bundledQuotes];
    uint32_t randomIndex = (uint32_t)arc4random_uniform([quotesArray count]);
    self.sameRandomIndex = *(&(randomIndex));
    [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.quoteLabel.text = [[quotesArray objectAtIndex:randomIndex] objectForKey:quoteKey];
        self.quoteLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.nameLabel.text = [[quotesArray objectAtIndex:self.sameRandomIndex] objectForKey:nameKey];
            self.nameLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 delay:2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.quoteLabel.alpha = 0;
                self.nameLabel.alpha = 0;
            } completion:^(BOOL finished) {
                if (self.circleState == CircleStatePlay) {
                    return;
                }
                self.buttonView.alpha = 0;
                self.buttonView.hidden = NO;
                [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.buttonView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (self.circleState == CircleStatePlay) {
                        return;
                    } else {
                        [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(startScreen) userInfo:nil repeats:NO];
                    }
                }];
            }];
        }];
    }];
}

#pragma mark - Mic Check
- (BOOL)requestForPermisssion {
    __block BOOL result=NO;

    PermissionBlock permissionBlock = ^(BOOL granted) {
        if (granted) {
            //[self setupRecording];
            result = YES;
        } else {
            // Warn no access to microphone
            result = NO;
        }
    };

    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:)
                                              withObject:permissionBlock];
    }

    return result;
}

- (void)micCheck {
    [self requestForPermisssion];
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"granted");
            self.micOn = YES;
        } else {
            NSLog(@"denied");
            self.micOn = NO;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your microphone isn't set up"
                                                                           message:@"You must allow microphone access in Settings > Privacy > Microphone"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"No Mic");
            }]];

            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - Buttons on View Controller

- (void)buttonClones {
    self.centerRecordButtonClone = [[UIButton alloc] initWithFrame:self.circleRect];
    self.centerPlayButtonClone = [[UIButton alloc] initWithFrame:self.circleRect];
    [self.view addSubview:self.tdView];

    self.centerPlayButtonClone.layer.cornerRadius = self.centerPlayButtonClone.frame.size.width/2;
    self.centerRecordButtonClone.layer.cornerRadius = self.centerRecordButtonClone.frame.size.width/2;
    self.centerRecordButtonClone.backgroundColor = [UIColor customGreenColor];
    self.centerPlayButtonClone.backgroundColor = [UIColor customBlueColor];
    [self.view addSubview:self.centerRecordButtonClone];
    [self.view addSubview:self.centerPlayButtonClone];
    self.centerRecordButtonClone.hidden = YES;
    self.centerPlayButtonClone.hidden = YES;
}

- (void)layoutMenuButton {
    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    [self.view addSubview:self.menuView];

    [self.menuView.menuButton addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)afterRecordButtons {
    UIImage *redX = [UIImage imageNamed:@"redx"];
    self.recordAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), redX.size.width, redX.size.height)];
    [self.recordAgainButton setImage:[UIImage imageNamed:@"redx"] forState:UIControlStateNormal];
    // self.recordAgainButton.layer.cornerRadius = self.recordAgainButton.frame.size.width/2;
    self.recordAgainButton.layer.shouldRasterize = YES;
    self.recordAgainButton.hidden = YES;
    [self.view addSubview:self.recordAgainButton];
    self.centerRecordAgainButton = self.recordAgainButton.center;

    [self.recordAgainButton addTarget:self action:@selector(recordAgainPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *greenCheck = [UIImage imageNamed:@"greencheck"];
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - greenCheck.size.width, CGRectGetMaxY(self.frame), greenCheck.size.width, greenCheck.size.height)];
    [self.view addSubview:self.confirmButton];
    self.confirmButton.hidden = YES;
    //self.confirmButton.backgroundColor = [UIColor customGreenColor];
    // self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.width/2;
    [self.confirmButton setImage:[UIImage imageNamed:@"greencheck"] forState:UIControlStateNormal];
    //self.confirmButton.layer.shouldRasterize = YES;
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchDown];
    self.centerConfirmButton = self.confirmButton.center;

    CGRect endPointRecordAgainButton = CGRectMake(0, CGRectGetMaxY(self.frame) - redX.size.height, redX.size.width, redX.size.height);
    self.endPointRecordAgainButton = CGPointMake(CGRectGetMidX(endPointRecordAgainButton), CGRectGetMidY(endPointRecordAgainButton));

    CGRect endPointConfirmButton = CGRectMake(CGRectGetWidth(self.frame) - greenCheck.size.width, CGRectGetMaxY(self.frame) - greenCheck.size.height, greenCheck.size.width, greenCheck.size.height);
    self.endPointConfirmButton = CGPointMake(CGRectGetMidX(endPointConfirmButton), CGRectGetMidY(endPointConfirmButton));

    self.containerView = [[CategoryContainerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/10 * 7, self.view.frame.size.width, self.view.frame.size.height/5)];
    self.containerView.delegate = self;
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
}

- (void)layoutCornerEndPoints {
    CGRect endPointRecordCornerButton = CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointRecordCornerButton = CGPointMake(endPointRecordCornerButton.origin.x + (endPointRecordCornerButton.size.width/2), endPointRecordCornerButton.origin.y + (endPointRecordCornerButton.size.height/2));

    CGRect endPointPlayCornerButton = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointPlayCornerButton = CGPointMake(endPointPlayCornerButton.origin.x + (endPointPlayCornerButton.size.width/2), endPointPlayCornerButton.origin.y + (endPointPlayCornerButton.size.height/2));

    CGRect middlePointRecordAgain = CGRectMake(0 - self.view.frame.size.width/5, self.view.frame.size.height - self.view.frame.size.height/3, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.middlePointRecordCornerButton = CGPointMake(middlePointRecordAgain.origin.x + (middlePointRecordAgain.size.width/2), middlePointRecordAgain.origin.y + (middlePointRecordAgain.size.height/2));

    CGRect middlePointPlayAgain = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/3, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.middlePointPlayCornerButton = CGPointMake(middlePointPlayAgain.origin.x + (middlePointPlayAgain.size.width/2), middlePointPlayAgain.origin.y + (middlePointPlayAgain.size.height/2));

    CGRect halfwayRecordPoint = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height/1.5, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.halfwayPointRecorderCornerPoint = CGPointMake(halfwayRecordPoint.origin.x + (halfwayRecordPoint.size.width/2), halfwayRecordPoint.origin.y + (halfwayRecordPoint.size.height/2));

    CGRect halfwayPlayPoint = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/2, self.view.frame.size.height - self.view.frame.size.height/1.5, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.halfwayPointPlayCornerPoint = CGPointMake(halfwayPlayPoint.origin.x + (halfwayPlayPoint.size.width/2), halfwayPlayPoint.origin.y + (halfwayPlayPoint.size.height/2));
}

- (void)cornerButtons {
    [self layoutCornerEndPoints];

    self.recordCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - self.view.frame.size.width/3, self.view.frame.size.height + self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.recordCornerButton];
    self.recordCornerButton.backgroundColor = [UIColor customGreenColor];
    self.recordCornerButton.hidden = YES;
    self.recordCornerButton.layer.cornerRadius = self.recordCornerButton.frame.size.height/2;
    self.recordCornerButton.layer.masksToBounds = YES;
    self.recordCornerButton.layer.shouldRasterize = YES;
    self.centerRecordButton = self.recordCornerButton.center;
    [self.recordCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.playCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width + self.view.frame.size.width/3, self.view.frame.size.height + self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.playCornerButton];
    self.playCornerButton.backgroundColor = [UIColor customBlueColor];
    self.playCornerButton.layer.cornerRadius = self.playCornerButton.frame.size.height/2;
    self.playCornerButton.layer.masksToBounds = YES;
    self.playCornerButton.layer.shouldRasterize = YES;
    self.centerPlayButton = self.playCornerButton.center;
    [self.playCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addPlayButtonAnimation];
}

#pragma mark - Action Methods

- (void)recordAgainPressed:(id)sender {
    Recording *recording = [RecordingController sharedInstance].memos.lastObject;
    [[RecordingController sharedInstance] removeRecording:recording];
    [[RecordingController sharedInstance] save];

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self hideBottomButtons];
        self.recordLabel.text = @"Not saved";
        self.recordLabel.alpha = 0;
        self.recordLabel.hidden = NO;
        [UIView animateWithDuration:.3 delay:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.recordLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 delay:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.menuView.menuButton.alpha = 1;
                self.recordLabel.alpha = 0;
            } completion:^(BOOL finished) {
                self.recordLabel.hidden = YES;
                [self noneState:ButtonStateNone];
            }];
        }];
        self.containerView.state = ButtonStateNone;
    }];
}

- (void)confirmPressed:(id)sender {
    self.confirmButton.alpha = 0;
    self.containerView.alpha = 0;
    if (self.containerView.state != ButtonStateZero || self.containerView.state != ButtonStateNone) {
        [[RecordingController sharedInstance] addGroupID:self.groupIDNumber];
        [[RecordingController sharedInstance] save];

        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        } completion:^(BOOL finished) {
            [self hideBottomButtons];
            self.recordLabel.text = @"Saved";
            self.recordLabel.alpha = 0;
            self.recordLabel.hidden = NO;
            [UIView animateWithDuration:.3 delay:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.recordLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.3 delay:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.menuView.menuButton.alpha = 1;
                    self.recordLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.recordLabel.hidden = YES;
                    [self noneState:ButtonStateNone];
                }];
            }];
            self.containerView.state = ButtonStateNone;

            self.counter++;
            self.hasRecordings = YES;
            self.notification = [[UILocalNotification alloc] init];
            self.notification.alertBody = @"Tomorrow has brought you yesterday's messages, today.";
            self.notification.timeZone = [NSTimeZone localTimeZone];
            self.notification.fireDate = [NSDate notificationTime];
            self.notification.applicationIconBadgeNumber = 1;
            self.notification.soundName = @"babypop.caf";
            [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];

            if (self.hasRecordings) {
                if (self.reminderNotification) {
                    [[UIApplication sharedApplication] cancelLocalNotification:self.reminderNotification];
                }
                if ([[self.longTimeNotification.userInfo valueForKey:@"reminding"] isEqualToString:@"Been a while"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:self.longTimeNotification];
                    }
                if ([[self.reallyLongTimeNotification.userInfo valueForKey:@"remindingAgain"] isEqualToString:@"Really long while"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:self.reallyLongTimeNotification];
                }
            } else {
                if (self.notification) {
                    [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
                }
                if ([[self.longTimeNotification.userInfo valueForKey:@"reminding"] isEqualToString:@"Been a while"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:self.longTimeNotification];
                }
                if ([[self.reallyLongTimeNotification.userInfo valueForKey:@"remindingAgain"] isEqualToString:@"Really long while"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:self.reallyLongTimeNotification];
                }

            }
        }];
    }
}

- (void)menuPressed:(id)sender {
    //self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
   // if (self.soundEffectsOn) {
        [[AudioController sharedInstance].menuSoundPlayer play];
        //    NSURL *menuURL = [[NSBundle mainBundle] URLForResource:@"menu" withExtension:@"wav"];
        //    [[AudioController sharedInstance] playAudioFileSoftlyAtURL:menuURL];
    //}
    switch (self.circleState) {
        case CircleStateRecord:
        case CircleStateLoad:
        {
            self.buttonView.hidden = YES;
            self.centerRecordButtonClone.hidden = NO;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.menuView.menuButton.alpha = 0;
                self.centerRecordButtonClone.center = self.halfwayPointRecorderCornerPoint;
                self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.centerRecordButtonClone.center = self.middlePointRecordCornerButton;
                    self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.centerRecordButtonClone.center = self.centerRecordAgainButton;
                        self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.centerRecordButtonClone.center = self.endPointRecordCornerButton;
                            self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                            }completion:^(BOOL finished) {
                                [self presentViewController:self.menuVC animated:YES completion:^{
                                    self.centerRecordButtonClone.hidden = NO;
                                    // self.centerRecordButtonClone.transform = CGAffineTransformIdentity;
                                    // self.centerRecordButtonClone.center = self.buttonView.center;
                                    self.menuView.menuButton.hidden = YES;
                                    //self.buttonView.hidden = NO;
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
            break;
        case CircleStatePlay:
        {
            self.buttonView.hidden = YES;
            self.centerPlayButtonClone.hidden = NO;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.menuView.menuButton.alpha = 0;
                self.centerPlayButtonClone.center = self.halfwayPointPlayCornerPoint;
                self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.centerPlayButtonClone.center = self.middlePointPlayCornerButton;
                    self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.centerPlayButtonClone.center = self.centerConfirmButton;
                        self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.centerPlayButtonClone.center = self.endPointPlayCornerButton;
                            self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                            }completion:^(BOOL finished) {
                                [self presentViewController:self.menuVC animated:YES completion:^{
                                    self.centerPlayButtonClone.hidden = NO;
                                    self.menuView.menuButton.hidden = YES;
                                    // self.centerRecordButtonClone.transform = CGAffineTransformIdentity;
                                    // self.centerRecordButtonClone.center = self.buttonView.center;
                                    //self.recordCornerButton.hidden = NO;
                                    //self.buttonView.hidden = NO;
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)cornerButtonPressed:(id)sender {
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (sender == self.recordCornerButton) {
            self.recordLabel.hidden = YES;
            self.buttonView.playButton.alpha = 0;
            self.circleState = CircleStateRecord;
            self.centerPlayButtonClone.hidden = NO;
        }
        if (sender == self.playCornerButton) {
            self.recordLabel.hidden = YES;
            self.buttonView.recordButton.alpha = 0;
            self.circleState = CircleStatePlay;
            self.centerRecordButtonClone.hidden = NO;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (sender == self.recordCornerButton) {
                self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                self.recordCornerButton.center = self.middlePointRecordCornerButton;

                self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                self.centerPlayButtonClone.center = self.halfwayPointPlayCornerPoint;
                self.recordCornerButton.alpha = 1;
            }
            if (sender == self.playCornerButton) {

                self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                self.playCornerButton.center = self.middlePointPlayCornerButton;
                self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                self.centerRecordButtonClone.center = self.halfwayPointRecorderCornerPoint;

                self.playCornerButton.alpha = 1;
            }
        } completion:^(BOOL finished) {
            if (sender == self.recordCornerButton) {
                [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.recordCornerButton.center = self.halfwayPointRecorderCornerPoint;
                    self.centerPlayButtonClone.center = self.middlePointPlayCornerButton;
                    self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                        self.recordCornerButton.center = self.buttonView.center;
                        self.centerPlayButtonClone.center = self.endPointPlayCornerButton;
                        self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                    } completion:^(BOOL finished) {
                        self.playCornerButton.center = self.endPointPlayCornerButton;
                        self.playCornerButton.alpha = 1;
                        self.centerPlayButtonClone.hidden = YES;
                        self.playCornerButton.hidden = NO;
                        [UIView animateWithDuration:.075 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                            self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                            self.centerPlayButtonClone.transform = CGAffineTransformIdentity;
                            self.centerPlayButtonClone.center = self.buttonView.center;
                        } completion:^(BOOL finished) {
                            self.recordCornerButton.hidden = YES;
                            self.recordCornerButton.transform = CGAffineTransformIdentity;
                            self.buttonView.playButton.alpha = 1;
                            self.buttonView.playButton.hidden = YES;
                            self.buttonView.hidden = NO;
                            self.buttonView.recordButton.alpha = 1;
                            self.buttonView.recordButton.hidden = NO;
                            self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                            self.recordCornerButton.center = self.centerRecordButton;
                            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.playCornerButton.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                    //                                    self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                        self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                        self.playCornerButton.transform = CGAffineTransformIdentity;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveLinear animations:^{
                                            self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                                        } completion:nil];
                                    }];
                                }];

                            }];
                        }];
                    }];
                }];
            }
            if (sender == self.playCornerButton) {
                [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.playCornerButton.center = self.halfwayPointPlayCornerPoint;
                    self.centerRecordButtonClone.center = self.middlePointRecordCornerButton;
                    self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                        self.playCornerButton.center = self.buttonView.center;
                        self.centerRecordButtonClone.center = self.endPointRecordCornerButton;
                        self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                    } completion:^(BOOL finished) {
                        self.recordCornerButton.center = self.endPointRecordCornerButton;
                        self.recordCornerButton.alpha = 1;
                        self.centerRecordButtonClone.hidden = YES;
                        self.recordCornerButton.hidden = NO;
                        [UIView animateWithDuration:.075 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                            self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                            self.centerRecordButtonClone.transform = CGAffineTransformIdentity;
                            self.centerRecordButtonClone.center = self.buttonView.center;
                        } completion:^(BOOL finished) {
                            self.playCornerButton.hidden = YES;
                            self.playCornerButton.transform = CGAffineTransformIdentity;
                            self.buttonView.hidden = NO;
                            self.buttonView.playButton.alpha = 1;
                            self.buttonView.playButton.hidden = NO;
                            self.buttonView.recordButton.alpha = 1;
                            self.buttonView.recordButton.hidden = YES;
                            self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                            self.playCornerButton.center = self.centerPlayButton;
                            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.recordCornerButton.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                    //      self.buttonView.playButton.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                        self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                        self.recordCornerButton.transform = CGAffineTransformIdentity;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveLinear animations:^{
                                            self.buttonView.playButton.transform = CGAffineTransformIdentity;
                                        } completion:nil];

                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }
        }];
    }];
}

#pragma mark - Delegates

- (void)didTryToPlayWithPlayButton:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([RecordingController sharedInstance].memos.count < 1) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
                [animation setDuration:0.07];
                [animation setRepeatCount:2];
                [animation setAutoreverses:YES];
                [animation setFromValue:[NSValue valueWithCGPoint:
                                         CGPointMake([button center].x + 20, [button center].y)]];
                [animation setToValue:[NSValue valueWithCGPoint:
                                       CGPointMake([button center].x - 20, [button center].y)]];
                [[button layer] addAnimation:animation forKey:@"position"];
                // NSLog(@"Shaking");
            }
            if ([RecordingController sharedInstance].memos.count > 0) {
                self.tdView.hidden = NO;
                self.recordCornerButton.hidden = YES;
                self.recordPlayView.hidden = NO;
                self.recordPlayView.recordImageView.alpha = 0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                [animation setFromValue:[NSNumber numberWithFloat:1.0]];
                [animation setToValue:[NSNumber numberWithFloat:0.0]];
                [animation setDuration:0.5f];
                [animation setTimingFunction:[CAMediaTimingFunction
                                              functionWithName:kCAMediaTimingFunctionLinear]];
                [animation setAutoreverses:YES];
                [animation setRepeatCount:HUGE_VALF];
                [self.recordPlayView.playImageView.layer addAnimation:animation forKey:@"opacity"];

                [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.menuView.menuButton.alpha = 0;
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3.5, 3.5);
                } completion:^(BOOL finished) {
                    self.menuView.menuButton.hidden = YES;

                    // ---- Another Queue Player Attempt
                    //                        NSArray *array = [RecordingController sharedInstance].memos;
                    //                        //NSArray *array = [RecordingController sharedInstance].fetchMemos;
                    //                        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
                    //                        self.mutableRecordings = [[NSMutableArray alloc] init];
                    //                        //Recording *recording = [RecordingController sharedInstance].memos.firstObject;
                    //                        for (int i = 0; i < [array count]; i++) {
                    //                            Recording *recording = [RecordingController sharedInstance].memos[i];
                    //                           // Recording *recording = [RecordingController sharedInstance].fetchMemos[i];
                    //                            [self.mutableRecordings addObject:recording.timeCreated];
                    //                            self.tdView.timeLabel.text = recording.timeCreated;
                    //                            self.tdView.dateLabel.text = recording.simpleDate;
                    //
                    //                            //AVAsset *asset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:recording.simpleDate]];
                    //                            //AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
                    //                            //[mutableArray addObject:item];
                    //                            NSArray *documentsPath = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], recording.urlPath, nil];
                    //                            NSURL *urlPath = [NSURL fileURLWithPathComponents:documentsPath];
                    //
                    //                            [mutableArray addObject:urlPath];
                    //
                    //                            self.record = recording;
                    //                        }

                    self.indexForRecording = self.mutableRecordings.count - 2;
                    //self.tdView.hidden = NO;
                    for (int i = 0; i < [AudioController sharedInstance].audioFileQueue.count; i++) {
                        [AudioController sharedInstance].index = i;
                        self.tdView.timeLabel.text = self.record.timeCreated;
                        self.tdView.dateLabel.text = self.record.simpleDate;
                        [[AudioController sharedInstance] playAudioWithInt:i];
                    }

                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelDidChange:) name:kLabelDidChange object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:kAudioFileFinished object:nil];
                    if (self.notification) {
                        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
                        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                    }


                    //              [[AudioController sharedInstance] initWithFileNameQueue:mutableArray];
                    //AVQueuePlayer *playing = [[AVQueuePlayer alloc] init];
                    //                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [[AudioController sharedInstance] playQueueAudio:mutableArray];
                    //                });

                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if ([RecordingController sharedInstance].memos.count < 1) {
                [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                    self.recordCornerButton.alpha = .5;
                    self.menuView.menuButton.alpha = .5;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:.13 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        self.recordCornerButton.alpha = 1;
                        self.menuView.menuButton.alpha = 1;
                    } completion:^(BOOL finished) {
                        self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
                        if (self.soundEffectsOn) {
                            [[AudioController sharedInstance].babyPopAgainPlayer play];
                            //                            NSURL *popURL = [[NSBundle mainBundle] URLForResource:@"babypopagain" withExtension:@"aiff"];
                            //                            [[AudioController sharedInstance] playAudioFileSoftlyAtURL:popURL];
                        }
                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.15 initialSpringVelocity:.08 options:UIViewAnimationOptionCurveLinear animations:^{
                            button.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                            self.recordLabel.alpha = 0;
                            self.recordLabel.text = @"You have no messages today. Record something inspiring to get it tomorrow.";
                            self.recordLabel.hidden = NO;
                            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.recordLabel.alpha = 1;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.2 delay:2.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.recordLabel.alpha = 0;
                                    self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.recordCornerButton.transform = CGAffineTransformIdentity;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                            self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                                        } completion:^(BOOL finished) {
                                            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                self.recordCornerButton.transform = CGAffineTransformIdentity;
                                            } completion:^(BOOL finished) {
                                                
                                            }];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            } else {
                [[AudioController sharedInstance] stopPlayingAudio];
                [self.recordPlayView.playImageView.layer removeAllAnimations];
                self.recordPlayView.hidden = YES;
                self.tdView.hidden = YES;
                self.menuView.menuButton.hidden = NO;
                self.hasPlayed = YES;
                self.recordCornerButton.alpha = 0;
                self.recordCornerButton.hidden = NO;

                if ([PurchasedDataController sharedInstance].goPro == YES) {
                    self.quoteLabel.textColor = [UIColor whiteColor];
                    self.nameLabel.textColor = [UIColor whiteColor];
                    [self showQuote];
                }
                if ([PurchasedDataController sharedInstance].goPro == YES) {
                    [UIView animateWithDuration:.13 delay:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                        self.recordCornerButton.alpha = .5;
                        self.menuView.menuButton.alpha = .5;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.13 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                            self.recordCornerButton.alpha = 1;
                            self.menuView.menuButton.alpha = 1;
                        } completion:^(BOOL finished) {
                            self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
                            if (self.soundEffectsOn) {
                                [[AudioController sharedInstance].babyPopAgainPlayer play];
                                //                            NSURL *popURL = [[NSBundle mainBundle] URLForResource:@"babypopagain" withExtension:@"aiff"];
                                //                            [[AudioController sharedInstance] playAudioFileSoftlyAtURL:popURL];
                            }
                            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.15 initialSpringVelocity:.08 options:UIViewAnimationOptionCurveLinear animations:^{
                                button.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                self.hasRecordings = NO;
                                self.quoteLabel.textColor = [UIColor customTextColor];
                                self.quoteLabel.textColor = [UIColor customTextColor];
                                [self rateApp];
                            }];
                        }];
                    }];
                } else {
                    [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                        self.recordCornerButton.alpha = .5;
                        self.menuView.menuButton.alpha = .5;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.13 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                            self.recordCornerButton.alpha = 1;
                            self.menuView.menuButton.alpha = 1;
                        } completion:^(BOOL finished) {
                            self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
                            if (self.soundEffectsOn) {
                                [[AudioController sharedInstance].babyPopAgainPlayer play];
                                //                            NSURL *popURL = [[NSBundle mainBundle] URLForResource:@"babypopagain" withExtension:@"aiff"];
                                //                            [[AudioController sharedInstance] playAudioFileSoftlyAtURL:popURL];
                            }
                            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.15 initialSpringVelocity:.08 options:UIViewAnimationOptionCurveLinear animations:^{
                                button.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                self.hasRecordings = NO;
                                self.quoteLabel.textColor = [UIColor customTextColor];
                                self.quoteLabel.textColor = [UIColor customTextColor];
                                [self rateApp];
                            }];
                        }];
                    }];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)didTryToZoom:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    self.tdView.hidden = YES;
    if (!self.micOn) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.07];
        [animation setRepeatCount:2];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([button center].x + 20, [button center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([button center].x - 20, [button center].y)]];
        [[button layer] addAnimation:animation forKey:@"position"];
        // NSLog(@"Shaking");
        self.recordLabel.alpha = 0;
        self.recordLabel.text = @"To record, you must enable your microphone in Settings > Privacy > Microphone";
        self.recordLabel.hidden = NO;
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 delay:.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordLabel.alpha = 0;
            } completion:^(BOOL finished) {
                //  self.recordLabel.hidden = YES;
            }];
        }];
    } else {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordAgainButton.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
        
//        if (self.circleState == CircleStateLoad) {
//            return;
//        }

        if (self.containerView.state != ButtonStateZero) {
            self.circleState = CircleStateRecord;
            if (self.circleState == CircleStateRecord) {
                self.recordLabel.hidden = YES;
            }
//        if (self.containerView.state != ButtonStateZero && self.circleState == CircleStateRecord) {

            switch (sender.state) {
                case UIGestureRecognizerStateBegan:
                {
                    self.recordLabel.alpha = 0;
                    [self recording];
                    self.playCornerButton.alpha = 0;
                    self.recordPlayView.hidden = NO;
                    self.recordPlayView.playImageView.alpha = 0;
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
                    [animation setToValue:[NSNumber numberWithFloat:0.0]];
                    [animation setDuration:0.5f];
                    [animation setTimingFunction:[CAMediaTimingFunction
                                                  functionWithName:kCAMediaTimingFunctionLinear]];
                    [animation setAutoreverses:YES];
                    [animation setRepeatCount:HUGE_VALF];
                    [self.recordPlayView.recordImageView.layer addAnimation:animation forKey:@"opacity"];
                    [UIView animateWithDuration:.2
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         self.menuView.menuButton.alpha = 0;
                                         button.transform = CGAffineTransformScale(button.transform, 3.5, 3.5);
                                         button.alpha = .7;
                                         self.playCornerButton.hidden = YES;
                                     } completion:^(BOOL finished) {

                                     }];
                    // self.buttonView.playButton.enabled = NO;
                    //self.on = YES;

                } break;
                case UIGestureRecognizerStateEnded:
                {
                    [self.recordPlayView.recordImageView.layer removeAllAnimations];
                    self.recordPlayView.hidden = YES;
                    self.menuView.menuButton.alpha = 0;
                    [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                        button.alpha = 1;


                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            button.transform = CGAffineTransformScale(button.transform, .9, .9);

                        } completion:^(BOOL finished) {
                            [self stopRecording];
                            self.soundEffectsOn = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsOnKey];
                            if (self.soundEffectsOn) {
                               NSURL *popURL = [[NSBundle mainBundle] URLForResource:@"babypop" withExtension:@"caf"];
                                [[AudioController sharedInstance] playAudioFileSoftlyAtURL:popURL];
                            }

                            [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);

                                //self.buttonView.recordingComplete = YES;

                            } completion:^(BOOL finished) {

                                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.15 initialSpringVelocity:.08 options:UIViewAnimationOptionCurveLinear animations:^{
                                    button.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished) {
                                    //                                self.containerView.alpha = 0;
                                    //                                self.containerView.hidden = NO;

                                    button.backgroundColor = [UIColor customGreenColor];
                                    self.recordAgainButton.hidden = NO;
                                    self.recordAgainButton.alpha = 0;
                                    [self zeroState:ButtonStateZero];
                                    self.containerView.state = ButtonStateZero;
                                    self.recordCornerButton.hidden = YES;
                                    self.playCornerButton.hidden = YES;
                                    [UIView animateWithDuration:.01 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                        //  self.containerView.alpha = 1;
                                        // [self.containerView animateLayoutButtons];
                                        self.recordAgainButton.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        [self showBottomButtons];
                                        self.menuView.menuButton.enabled = YES;
                                    }];
                                }];
                            }];
                        }];
                    }];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


// ---- Not using this for now as I don't need it if I'm not using CategoryContainerView
- (void)didTryToPlay:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    if (self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateAmbition || self.containerView.state == ButtonStateZero) {

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.07];
        [animation setRepeatCount:2];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([button center].x + 20, [button center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([button center].x - 20, [button center].y)]];
        [[button layer] addAnimation:animation forKey:@"position"];
        //   NSLog(@"Shaking");
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordAgainButton.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }
}

#pragma mark - Notifications

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog(@"Notification received");
    self.nameLabel.alpha = 0;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = @"No more messages";
    self.tdView.hidden = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.nameLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.nameLabel.alpha = 0;
        } completion:^(BOOL finished) {
            //self.nameLabel.textColor = [UIColor customTextColor];
            //self.nameLabel.text = @"";
            self.indexForRecording = [RecordingController sharedInstance].memos.count;
        }];
    }];
    // ---- TO REMOVE RECORDINGS COMPLETELY FROM CORE DATA:
    //self.record = [RecordingController sharedInstance].memoNames.lastObject;
    //    [[RecordingController sharedInstance] removeRecording:self.record];
    //self.counter--;
}

- (void)labelDidChange:(NSNotification *)notification {

    if (self.indexForRecording <= (self.mutableRecordings.count)) {
        self.tdView.timeLabel.text =  self.mutableRecordings[self.indexForRecording];

        self.tdView.dateLabel.text = self.record.simpleDate;
    } else {
        return;
    }
    self.indexForRecording--;

    NSLog(@"Called Label did change");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Audio Recorder & Player

- (void)recording {
    [[AudioController sharedInstance] recordAudioToDirectory];
    //  NSLog(@"----------RECORDING STARTED-------------- %@", [[AudioController sharedInstance] recordAudioToDirectory]);
    //    }
}

- (void)stopRecording {
    [[AudioController sharedInstance] stopRecording];
}

// Puts each instance 
- (void)loadRecordingsToPlay {
    NSArray *array = [RecordingController sharedInstance].memos;
    self.mutableArray = [[NSMutableArray alloc] init];
    self.mutableRecordings = [[NSMutableArray alloc] init];
    //Recording *recording = [RecordingController sharedInstance].memos.firstObject;
    for (int i = 0; i < [array count]; i++) {
        Recording *recording = [RecordingController sharedInstance].memos[i];
        // Recording *recording = [RecordingController sharedInstance].fetchMemos[i];
        [self.mutableRecordings addObject:recording.timeCreated];
        self.tdView.timeLabel.text = recording.timeCreated;
        self.tdView.dateLabel.text = recording.simpleDate;

        // ---- ATTEMPT TO USE AVQUEUEPLAYER
        //AVAsset *asset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:recording.simpleDate]];
        //AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        //[mutableArray addObject:item];
        NSArray *documentsPath = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], recording.urlPath, nil];
        NSURL *urlPath = [NSURL fileURLWithPathComponents:documentsPath];

        [self.mutableArray addObject:urlPath];

        self.record = recording;
    }
    [AudioController sharedInstance].audioFileQueue = self.mutableArray;
}

#pragma mark - States Typedef

- (void)noneState:(ButtonState)state {
    state = ButtonStateNone;
    [self.containerView setState:ButtonStateNone];
    self.playCornerButton.alpha = 0;
    [self hideBottomButtons];
    self.groupIDNumber = @0;
    self.playCornerButton.center = self.centerPlayButton;
    [UIView animateWithDuration:.5 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        self.playCornerButton.hidden = NO;
        self.playCornerButton.alpha = 1;
        [self addPlayButtonAnimation];
    }];
}

- (void)focusState:(ButtonState)state {
    state = ButtonStateFocus;
    [self showBottomButtons];
    self.groupIDNumber = @1;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.focusButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        [self setAlphaOfBottomButtons];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.containerView.focusButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)courageState:(ButtonState)state {
    state = ButtonStateCourage;
    [self showBottomButtons];
    self.groupIDNumber = @2;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.courageButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.buttonView.recordButton.layer.backgroundColor = [UIColor redColor].CGColor;
        [self setAlphaOfBottomButtons];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.containerView.courageButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];

}

- (void)ambitionState:(ButtonState)state {
    state = ButtonStateAmbition;
    [self showBottomButtons];
    self.groupIDNumber = @3;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.ambitionButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.buttonView.recordButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
        [self setAlphaOfBottomButtons];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.containerView.ambitionButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];

}
- (void)imaginationState:(ButtonState)state {
    state = ButtonStateImagination;
    [self showBottomButtons];
    self.groupIDNumber = @4;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.imaginationButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        [self setAlphaOfBottomButtons];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.containerView.imaginationButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];

}
- (void)funState:(ButtonState)state {
    state = ButtonStateFun;
    [self showBottomButtons];
    self.groupIDNumber = @5;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.funButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.buttonView.recordButton.layer.backgroundColor = [UIColor cyanColor].CGColor;
        [self setAlphaOfBottomButtons];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.containerView.funButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)presenceState:(ButtonState)state {
    state = ButtonStatePresence;
    [self showBottomButtons];
    self.groupIDNumber = @6;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.presenceButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.buttonView.recordButton.layer.backgroundColor = [UIColor yellowColor].CGColor;
        [self setAlphaOfBottomButtons];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.containerView.presenceButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)zeroState:(ButtonState)state {
    state = ButtonStateZero;
    [self.containerView setState:ButtonStateZero];
    //self.confirmButton.hidden = NO;
    self.groupIDNumber = @0;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
