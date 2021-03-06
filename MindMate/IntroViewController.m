//
//  IntroViewController.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/9/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "IntroViewController.h"
#import "ButtonView.h"
#import "CategoryContainerView.h"
#import "RecordingController.h"
#import "MenuView.h"
#import "Recording.h"
#import "AudioController.h"
#import "UIColor+Colors.h"
#import "TimeAndDateView.h"
#import "MenuViewController.h"
#import "AudioViewController.h"
#import "RecordPlayView.h"
#import "NSDate+Utils.h"

static NSString * const finishedIntroKey = @"finishedIntro";
static NSString * const micOnKey = @"micOnKey";

@interface IntroViewController () <CategoryContainerViewDelegate, ButtonViewDelegate, MenuViewControllerDelegate>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) CategoryContainerView *containerView;
@property (nonatomic, strong) TimeAndDateView *tdView;
@property (nonatomic, strong) Recording *record;
@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, strong) AudioViewController *audioVC;
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) RecordPlayView *recordPlayView;
@property (nonatomic) IntroCircleState circleState;

@property (nonatomic, strong) NSMutableArray *mutableRecordings;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *recordAgainButton;
@property (nonatomic, strong) UILabel *confirmLabel;
@property (nonatomic, strong) UILabel *recordAgainLabel;

@property (nonatomic, assign) CGPoint centerRecordAgainButton;
@property (nonatomic, assign) CGPoint centerConfirmButton;
@property (nonatomic, assign) CGPoint endPointRecordAgainButton;
@property (nonatomic, assign) CGPoint endPointConfirmButton;

@property (nonatomic, strong) UIButton *recordCornerButton;
@property (nonatomic, strong) UIButton *playCornerButton;
@property (nonatomic, strong) UIButton *recordCornerButtonClone;

@property (nonatomic, assign) CGPoint centerRecordButton;
@property (nonatomic, assign) CGPoint centerPlayButton;
@property (nonatomic, assign) CGPoint endPointRecordCornerButton;
@property (nonatomic, assign) CGPoint endPointPlayCornerButton;

@property (nonatomic, assign) NSNumber *groupIDNumber;
@property (nonatomic, assign) NSInteger indexForRecording;
@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, strong) UIButton *nextScreenButton;

@property (nonatomic, strong) UIButton *centerRecordButtonClone;
@property (nonatomic, strong) UIButton *centerPlayButtonClone;
@property (nonatomic, assign) CGPoint hidingPointRecordCornerPoint;
@property (nonatomic, assign) CGPoint hidingPointPlayCornerPoint;
@property (nonatomic, assign) CGPoint middlePointRecordCornerButton;
@property (nonatomic, assign) CGPoint middlePointPlayCornerButton;
@property (nonatomic, assign) CGPoint middlePointBelowButton;
@property (nonatomic, assign) CGPoint halfwayPointRecorderCornerPoint;
@property (nonatomic, assign) CGPoint halfwayPointPlayCornerPoint;
@property (nonatomic, assign) CGRect circleRect;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL showedMenuVC;
@property (nonatomic, assign) BOOL micOn;
@property (nonatomic, assign) BOOL hasRecordings;
@property (nonatomic, assign) BOOL finishedIntro;

@property (nonatomic, strong) UIView *comeDownCircle;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, assign) CGPoint middleTopLabel;
@property (nonatomic, assign) CGPoint middleBottomLabel;
@property (nonatomic, assign) CGPoint centerTitleLabel;
@property (nonatomic, assign) CGPoint leftOfMiddlePointBelowButton;
@property (nonatomic, assign) CGPoint rightOfMiddlePointBelowButton;
@property (nonatomic, assign) CGPoint middleOfRecordLabel;
@property (nonatomic, assign) CGPoint aboveTitleCenterPoint;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.circleState = IntroCircleStateNone;
    self.groupIDNumber = @0;
    self.frame = self.view.frame;

    if (![AudioController sharedInstance]) {
        [AudioController sharedInstance];
    };

    [self cornerButtons];
    [self afterRecordButtons];
    self.audioVC = [[AudioViewController alloc] init];

    self.circleRect = CGRectMake(CGRectGetWidth(self.frame)/8, self.view.frame.size.height/5, CGRectGetWidth(self.frame)/1.35, CGRectGetWidth(self.frame)/1.35);
    self.buttonView = [[ButtonView alloc] initWithFrame:self.circleRect];
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];
    self.buttonView.hidden = YES;

    [self buttonClones];

    self.tdView = [[TimeAndDateView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 30, CGRectGetWidth(self.frame)/2-10, 100)];

    [self.view addSubview:self.tdView];
    [self layoutMenuButton];
    self.menuVC = [[MenuViewController alloc] init];
    self.menuVC.delegate = self;

    self.recordPlayView = [[RecordPlayView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/12, CGRectGetHeight(self.frame)/18, CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/10)];
    [self.view addSubview:self.recordPlayView];
    self.recordPlayView.hidden = YES;


    [self layoutLabels];

    [self layoutButton];
    [self setupPoints];
    [self initialAnimation];
}

#pragma mark - Animations 

- (void)initialAnimation {
    [UIView animateWithDuration:.5 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.introLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 delay:.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.menuView.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.menuView.menuButton.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }];
}

- (void)addPlayButtonAnimation {
    [UIView animateWithDuration:.25 delay:.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.playCornerButton.hidden = NO;
        self.playCornerButton.alpha = 1;
        self.playCornerButton.center = self.endPointPlayCornerButton;
        self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.playCornerButton.transform = CGAffineTransformIdentity;
            self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:nil];
    }];
}

- (void)addCornerButtonsAnimation {
    [UIView animateWithDuration:.25 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recordCornerButton.hidden = NO;
        self.recordCornerButton.alpha = 1;
        self.recordCornerButton.center = self.endPointRecordCornerButton;
        self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);

    } completion:^(BOOL finished) {

        [[AudioController sharedInstance].babyPopPlayer play];

        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.playCornerButton.hidden = NO;
            self.playCornerButton.alpha = 1;
            self.playCornerButton.center = self.endPointPlayCornerButton;
            self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
            self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        } completion:^(BOOL finished) {
            [[AudioController sharedInstance].babyPopAgainPlayer play];
            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.playCornerButton.transform = CGAffineTransformIdentity;
                self.recordCornerButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.recordCornerButtonClone.hidden = NO;
                self.recordCornerButton.hidden = YES;
                [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.titleLabel.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.sloganLabel.alpha = 1;
                    } completion:^(BOOL finished) {
                        self.nextScreenButton.hidden = NO;
                        [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                            self.nextScreenButton.alpha = 1;
                        } completion:nil];
                    }];
                }];
            }];
        }];
    }];
}

- (void)reanimateCircles {
    switch (self.circleState) {
        case IntroCircleStateNone:
        case IntroCircleStateStarted:
        case IntroCircleStateGetStarted:
        case IntroCircleStateReady:
        case IntroCircleStateFinished:
        case IntroCircleStateNotifications:
            break;
        case IntroCircleStateRecord:
        {
            [self introRecordAnimation];
        }
            break;
        case IntroCircleStatePlay:
        {
            [self introPlayAnimation];
        }
    }
}

- (void)introRecordAnimation {
    self.centerRecordButtonClone.center = self.endPointRecordCornerButton;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.menuView.menuButton.alpha = 0;
            self.menuView.menuButton.hidden = NO;
            self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.menuView.menuButton.alpha = 1;
                self.centerRecordButtonClone.center = self.middlePointRecordCornerButton;
                self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.centerRecordButtonClone.center = self.halfwayPointRecorderCornerPoint;
                    self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.centerRecordButtonClone.center = self.buttonView.center;
                        self.centerRecordButtonClone.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        self.buttonView.hidden = NO;
                        self.centerRecordButtonClone.hidden = YES;
                        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.menuView.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                            self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.menuView.menuButton.transform = CGAffineTransformIdentity;
                                self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                                    } completion:^(BOOL finished) {

                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)introPlayAnimation {
    self.centerPlayButtonClone.hidden = NO;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.centerPlayButtonClone.center = self.endPointPlayCornerButton;
        self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.menuView.menuButton.alpha = 0;
            self.menuView.menuButton.hidden = NO;
            self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.menuView.menuButton.alpha = 1;
                self.centerPlayButtonClone.center = self.middlePointPlayCornerButton;
                self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.centerPlayButtonClone.center = self.halfwayPointPlayCornerPoint;
                    self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.centerPlayButtonClone.center = self.buttonView.center;
                        self.centerPlayButtonClone.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        self.buttonView.hidden = NO;
                        self.centerPlayButtonClone.hidden = YES;
                        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.menuView.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                            self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.menuView.menuButton.transform = CGAffineTransformIdentity;
                                self.buttonView.playButton.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.2 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.buttonView.playButton.transform = CGAffineTransformIdentity;
                                    } completion:^(BOOL finished) {
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)hideBottomButtons {
    self.confirmLabel.hidden = YES;
    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.recordAgainButton.center = self.centerRecordAgainButton;
        self.confirmButton.center = self.centerConfirmButton;
        self.confirmLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.recordAgainButton.hidden = YES;
        self.recordAgainLabel.hidden = YES;
        self.recordAgainLabel.alpha = 1;
        self.confirmLabel.alpha = 1;
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

- (void)setAlphaOfBottomButtons {
    self.confirmButton.alpha = 1;
    self.recordAgainButton.alpha = 1;
}

- (void)recordCornerFinalAnimation {
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
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                            self.playCornerButton.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.2 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                            } completion:nil];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)playCornerFinalAnimation {
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
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                            self.recordCornerButton.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveLinear animations:^{
                                self.buttonView.playButton.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                self.recordLabel.text = @"You get your messages tomorrow, but today, press and hold the circle to playback. Release to stop.";
                                self.recordLabel.hidden = NO;
                                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                    self.recordLabel.center = self.middleOfRecordLabel;
                                    self.recordLabel.alpha = 1;
                                } completion:nil];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)shakingAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.07];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.buttonView center].x + 20, [self.buttonView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.buttonView center].x - 20, [self.buttonView center].y)]];
    [[self.buttonView layer] addAnimation:animation forKey:@"position"];
}

- (void)recordPlayBlinkingAnimation {
    switch (self.circleState) {
        case IntroCircleStateRecord:
        {
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
        }
            break;
        case IntroCircleStateNotifications:
        case IntroCircleStatePlay:
        {
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
        }
        case CircleStateNone:
        default:
            break;
    }
}

#pragma mark - Helpers

- (void)layoutButton {
    self.nextScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/3 - 30, CGRectGetHeight(self.frame)/2 + 70, CGRectGetWidth(self.frame)/3 + 60, 44)];
    [self.view addSubview:self.nextScreenButton];

    [self.nextScreenButton setTitle:@"Get Started" forState:UIControlStateNormal];
    [self.nextScreenButton setTitleColor:[UIColor customTextColor] forState:UIControlStateNormal];
    self.nextScreenButton.layer.borderWidth = 2;
    self.nextScreenButton.layer.cornerRadius = 10;
    self.nextScreenButton.alpha = 0;
    self.nextScreenButton.hidden = YES;
    self.nextScreenButton.layer.borderColor = [UIColor customTextColor].CGColor;
    [self.nextScreenButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setupPoints {
    self.middlePointBelowButton = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.circleRect) + 80);
    self.leftOfMiddlePointBelowButton = CGPointMake(CGRectGetMinX(self.frame)- 150, CGRectGetMidX(self.circleRect) + 80);
    self.rightOfMiddlePointBelowButton = CGPointMake(CGRectGetMaxX(self.frame) + 150, CGRectGetMidX(self.circleRect) + 80);

    self.centerTitleLabel = CGPointMake(CGRectGetMidX(self.titleLabel.frame), CGRectGetMidY(self.titleLabel.frame));
}

- (void)layoutLabels {
    self.recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/12, CGRectGetMaxY(self.frame) - CGRectGetHeight(self.frame)/2.9, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/6, self.view.frame.size.height/5)];
    [self.view addSubview:self.recordLabel];
    self.recordLabel.hidden = YES;
    self.recordLabel.text = @"Press and hold on the circle to record. \nRelease to stop.";
    self.recordLabel.numberOfLines = 0;
    self.recordLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
    self.recordLabel.textColor = [UIColor customTextColor];
    self.recordLabel.textAlignment = NSTextAlignmentLeft;
    self.middleOfRecordLabel = CGPointMake(CGRectGetMidX(self.recordLabel.frame), CGRectGetMidY(self.recordLabel.frame));

    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/6, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)/6)];
    self.topLabel.numberOfLines = 0;
    self.topLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
    self.topLabel.textAlignment = NSTextAlignmentLeft;
    self.topLabel.textColor = [UIColor customTextColor];
    [self.view addSubview:self.topLabel];

    self.middleTopLabel = CGPointMake(CGRectGetMidX(self.topLabel.frame), CGRectGetMidY(self.topLabel.frame));

    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/3, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)/6)];
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.textColor = [UIColor customTextColor];
    self.bottomLabel.font = [UIFont fontWithName:@"Open Sans" size:18];
    self.bottomLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.bottomLabel];
    self.middleBottomLabel = CGPointMake(CGRectGetMidX(self.bottomLabel.frame), CGRectGetMidY(self.bottomLabel.frame));

    self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/10, CGRectGetHeight(self.frame)/6, CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)/1.5)];

    self.introLabel.text = @"Hey there! \n\nTomorrow uses your mic to record your voice. \n\nTap the Square to enable your mic.";
    self.introLabel.numberOfLines = 0;
    self.introLabel.alpha = 0;
    self.introLabel.textColor = [UIColor customTextColor];
    self.introLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
    self.introLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.introLabel];

    self.sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/12, self.view.frame.size.height/4, CGRectGetWidth(self.frame)/1.2, 120)];
    self.sloganLabel.text = @"Inspire your future self";
    self.sloganLabel.textAlignment = NSTextAlignmentCenter;
    self.sloganLabel.textColor = [UIColor customTextColor];
    self.sloganLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
    self.sloganLabel.alpha = 0;
    self.sloganLabel.numberOfLines = 1;
    self.sloganLabel.minimumScaleFactor = .8/self.sloganLabel.font.pointSize;
    self.sloganLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.sloganLabel];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/8, self.view.frame.size.height/5, CGRectGetWidth(self.frame)/1.35, 44)];
    self.titleLabel.text = @"Tomorrow";
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor customBlueColor];
    self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:36];
    self.titleLabel.minimumScaleFactor = .8/self.titleLabel.font.pointSize;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.aboveTitleCenterPoint = CGPointMake(CGRectGetMidX(self.titleLabel.frame), CGRectGetMidY(self.titleLabel.frame) - 20);

    self.titleLabel.alpha = 0;
    [self.view addSubview:self.titleLabel];
}


- (void)showRecordLabel {
    self.recordLabel.alpha = 0;
    self.recordLabel.hidden = NO;
    [UIView animateWithDuration:1 delay:1.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recordLabel.alpha = 1;
    } completion:nil];
}

-(BOOL)requestForPermisssion {
    __block BOOL result=NO;

    PermissionBlock permissionBlock = ^(BOOL granted) {
        if (granted) {
            result = YES;
        }
        else {
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


- (void)newView {
    [self presentViewController:self.audioVC animated:YES completion:nil];
}

- (void)loadFromDefaults {

    self.finishedIntro = [[NSUserDefaults standardUserDefaults] boolForKey:finishedIntroKey];

    if (!self.finishedIntro) {
        self.finishedIntro = NO;
    }
}

- (void)setFinishedIntro:(BOOL)finishedIntro {
    _finishedIntro = finishedIntro;

    [[NSUserDefaults standardUserDefaults] setBool:finishedIntro forKey:finishedIntroKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    self.menuView = [[MenuView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame)/6), self.view.frame.size.height/18, CGRectGetWidth(self.frame)/8, CGRectGetWidth(self.frame)/7.8)];
    [self.view addSubview:self.menuView];

    self.menuView.menuButton.alpha = 1;
    self.menuView.menuButton.enabled = YES;
    [self.menuView.menuButton addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)afterRecordButtons {
    UIImage *redX = [UIImage imageNamed:@"redX"];
    self.recordAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), redX.size.width, redX.size.height)];
    [self.recordAgainButton setImage:[UIImage imageNamed:@"redX"] forState:UIControlStateNormal];
    self.recordAgainButton.layer.shouldRasterize = YES;
    self.recordAgainButton.hidden = YES;
    [self.view addSubview:self.recordAgainButton];
    self.centerRecordAgainButton = self.recordAgainButton.center;

    [self.recordAgainButton addTarget:self action:@selector(recordAgainPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *greenCheck = [UIImage imageNamed:@"greencheck"];
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - greenCheck.size.width, CGRectGetMaxY(self.frame), greenCheck.size.width, greenCheck.size.height)];
    [self.view addSubview:self.confirmButton];
    self.confirmButton.hidden = YES;
    [self.confirmButton setImage:[UIImage imageNamed:@"greencheck"] forState:UIControlStateNormal];
    self.confirmButton.layer.shouldRasterize = YES;
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchDown];
    self.centerConfirmButton = self.confirmButton.center;


    CGRect endPointRecordAgainButton = CGRectMake(0, CGRectGetMaxY(self.frame) - redX.size.height, redX.size.width, redX.size.height);
    self.endPointRecordAgainButton = CGPointMake(CGRectGetMidX(endPointRecordAgainButton), CGRectGetMidY(endPointRecordAgainButton));

    CGRect endPointConfirmButton = CGRectMake(CGRectGetWidth(self.frame) - greenCheck.size.width, self.view.frame.size.height - greenCheck.size.height, greenCheck.size.width, greenCheck.size.height);
     self.endPointConfirmButton = CGPointMake(CGRectGetMidX(endPointConfirmButton), CGRectGetMidY(endPointConfirmButton));

    self.containerView = [[CategoryContainerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/10 * 7, CGRectGetWidth(self.frame), self.view.frame.size.height/5)];
    self.containerView.delegate = self;
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
}

- (void)layoutCornerEndPoints {
    CGRect endPointRecordCornerButton = CGRectMake(0 - CGRectGetWidth(self.frame)/6, self.view.frame.size.height - self.view.frame.size.height/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
    self.endPointRecordCornerButton = CGPointMake(endPointRecordCornerButton.origin.x + (endPointRecordCornerButton.size.width/2), endPointRecordCornerButton.origin.y + (endPointRecordCornerButton.size.height/2));

    CGRect endPointPlayCornerButton = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/3, self.view.frame.size.height - self.view.frame.size.height/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
    self.endPointPlayCornerButton = CGPointMake(endPointPlayCornerButton.origin.x + (endPointPlayCornerButton.size.width/2), endPointPlayCornerButton.origin.y + (endPointPlayCornerButton.size.height/2));

    CGRect middlePointRecordAgain = CGRectMake(0 - CGRectGetWidth(self.frame)/5, self.view.frame.size.height - self.view.frame.size.height/3, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
    self.middlePointRecordCornerButton = CGPointMake(middlePointRecordAgain.origin.x + (middlePointRecordAgain.size.width/2), middlePointRecordAgain.origin.y + (middlePointRecordAgain.size.height/2));

    CGRect middlePointPlayAgain = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/3, self.view.frame.size.height - self.view.frame.size.height/3, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
    self.middlePointPlayCornerButton = CGPointMake(middlePointPlayAgain.origin.x + (middlePointPlayAgain.size.width/2), middlePointPlayAgain.origin.y + (middlePointPlayAgain.size.height/2));

    CGRect halfwayRecordPoint = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height/1.5, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
    self.halfwayPointRecorderCornerPoint = CGPointMake(halfwayRecordPoint.origin.x + (halfwayRecordPoint.size.width/2), halfwayRecordPoint.origin.y + (halfwayRecordPoint.size.height/2));

    CGRect halfwayPlayPoint = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame)/2, self.view.frame.size.height - self.view.frame.size.height/1.5, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
    self.halfwayPointPlayCornerPoint = CGPointMake(halfwayPlayPoint.origin.x + (halfwayPlayPoint.size.width/2), halfwayPlayPoint.origin.y + (halfwayPlayPoint.size.height/2));
}

- (void)cornerButtons {
    [self layoutCornerEndPoints];
    self.recordCornerButtonClone = [[UIButton alloc] initWithFrame:CGRectMake(0 - CGRectGetWidth(self.frame)/3, self.view.frame.size.height + self.view.frame.size.height/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
    [self.view addSubview:self.recordCornerButtonClone];
    self.recordCornerButtonClone.backgroundColor = [UIColor customGreenColor];
    self.recordCornerButtonClone.layer.cornerRadius = self.recordCornerButtonClone.frame.size.height/2;
    self.recordCornerButtonClone.layer.masksToBounds = YES;
    self.recordCornerButtonClone.layer.shouldRasterize = YES;
    self.recordCornerButtonClone.center = self.endPointRecordCornerButton;
    self.recordCornerButtonClone.hidden = YES;
    [self.recordCornerButtonClone addTarget:self action:@selector(recordCornerPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.recordCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - CGRectGetWidth(self.frame)/3, self.view.frame.size.height + self.view.frame.size.height/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
    [self.view addSubview:self.recordCornerButton];
    self.recordCornerButton.backgroundColor = [UIColor customGreenColor];
    self.recordCornerButton.layer.cornerRadius = self.recordCornerButton.frame.size.height/2;
    self.recordCornerButton.layer.masksToBounds = YES;
    self.recordCornerButton.layer.shouldRasterize = YES;
    self.centerRecordButton = self.recordCornerButton.center;
    [self.recordCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.playCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) + CGRectGetWidth(self.frame)/3, self.view.frame.size.height + self.view.frame.size.height/6, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
    [self.view addSubview:self.playCornerButton];
    self.playCornerButton.backgroundColor = [UIColor customBlueColor];
    self.playCornerButton.layer.cornerRadius = self.playCornerButton.frame.size.height/2;
    self.playCornerButton.layer.masksToBounds = YES;
    self.playCornerButton.layer.shouldRasterize = YES;
    self.centerPlayButton = self.playCornerButton.center;
    [self.playCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action Methods

- (void)nextPressed:(id)sender {
    if (self.circleState == IntroCircleStateNone) {
        [UIView animateWithDuration:.3 delay:.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.nextScreenButton.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.4 delay:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.sloganLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.4 delay:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.titleLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.topLabel.alpha = 0;
                    self.menuView.menuButton.alpha = 0;
                    self.topLabel.text = @"Tomorrow records your voice today and sends you your message tomorrow.";
                    if ([[UIScreen mainScreen] bounds].size.width < 375) {
                        self.bottomLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
                    }
                    self.bottomLabel.alpha = 0;
                    self.bottomLabel.text = @"Leave your future self inspiring notes, goals, or affirmations. \nHave fun with it!";

                    [UIView animateWithDuration:.3 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.topLabel.alpha = 1;


                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.4 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.bottomLabel.alpha = 1;

                        } completion:^(BOOL finished) {
                            self.circleState = IntroCircleStateGetStarted;
                            [self.nextScreenButton setTitle:@"I'm Ready" forState:UIControlStateNormal];
                            [UIView animateWithDuration:.4 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.nextScreenButton.alpha = 1;
                            } completion:nil];
                        }];
                    }];
                }];
            }];
        }];
    }

    if (self.circleState == IntroCircleStateGetStarted) {
        self.recordCornerButtonClone.enabled = NO;
        self.recordCornerButton.enabled = NO;
        self.playCornerButton.enabled = NO;
        [UIView animateWithDuration:.4 delay:.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.nextScreenButton.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.4 delay:.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.bottomLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.4 delay:.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.topLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.bottomLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
                    self.bottomLabel.text = @"Let's start recording...\nTap the green button!";
                    [UIView animateWithDuration:.4 delay:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.bottomLabel.alpha = 1;
                    } completion:^(BOOL finished) {
                        self.circleState = IntroCircleStateReady;
                        self.recordCornerButtonClone.enabled = YES;
                        self.menuView.menuButton.alpha = 1;
                    }];
                }];
            }];
        }];
    }
}

- (void)recordAgainPressed:(id)sender {
    self.confirmLabel.alpha = 0;
    self.recordAgainLabel.alpha = 0;
    Recording *recording = [RecordingController sharedInstance].memos.lastObject;
    [[RecordingController sharedInstance] removeRecording:recording];
    [[RecordingController sharedInstance] save];
    self.menuView.menuButton.hidden = NO;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        self.menuView.menuButton.alpha = 1;
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self hideBottomButtons];
        self.recordLabel.alpha = 0;
        self.recordLabel.text = @"Hold down on the circle to record again.";
        self.circleState = IntroCircleStatePlay;
        self.containerView.state = ButtonStateNone;
        [self noneState:ButtonStateNone];
        [UIView animateWithDuration:.3 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordLabel.alpha = 1;
        } completion:nil];
    }];
}

- (void)confirmPressed:(id)sender {
    self.confirmButton.alpha = 0;
    self.containerView.alpha = 0;
    if (self.containerView.state != ButtonStateZero || self.containerView.state != ButtonStateNone) {
        [[RecordingController sharedInstance] addGroupID:self.groupIDNumber];
        [[RecordingController sharedInstance] save];
        self.menuView.menuButton.hidden = NO;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
            self.menuView.menuButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self hideBottomButtons];
            self.recordLabel.alpha = 0;
            self.recordLabel.text = @"Awesome! Now, tap the blue button!";
            self.circleState = IntroCircleStatePlay;
            self.containerView.state = ButtonStateNone;
            [self noneState:ButtonStateNone];
            self.counter++;
            [UIView animateWithDuration:.3 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordLabel.alpha = 1;
            } completion:^(BOOL finished) {
                self.hasRecordings = YES;
                self.notification = [[UILocalNotification alloc] init];
                self.notification.alertBody = @"Tomorrow has brought you yesterday's messages, today.";
                self.notification.timeZone = [NSTimeZone localTimeZone];
                self.notification.fireDate = [NSDate notificationTime];
                [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];

                if (self.hasRecordings) {
                    if (self.audioVC.reminderNotification) {
                        [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.reminderNotification];
                    }
                    if (self.audioVC.notification) {
                        [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.notification];
                    }
                } else {
                    if (self.notification) {
                        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
                    }
                }
            }];
        }];
    }
}

- (void)menuPressed:(id)sender {
    switch (self.circleState) {
        case IntroCircleStateNone: {
            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.introLabel.alpha = 0;
            } completion:^(BOOL finished) {
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
                        }]];

                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }];
            [self addCornerButtonsAnimation];
        }
            break;
        case IntroCircleStateRecord:
        case IntroCircleStatePlay:
            break;
        case IntroCircleStateNotifications: {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            self.circleState = IntroCircleStateStarted;
        }
        case IntroCircleStateStarted: {
            self.recordLabel.alpha = 0;
            self.recordLabel.hidden = NO;
            self.recordLabel.text = @"Hooray! You're ready to talk to your future self! Tap the Square again to start using Tomorrow.";
            [UIView animateWithDuration:.3 delay:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.menuView.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.2 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.menuView.menuButton.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        self.circleState = IntroCircleStateFinished;
                    }];
                }];
            }];
        }
            break;
        case IntroCircleStateFinished: {
            [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.menuView.menuButton.alpha = 0;
                self.recordLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.recordCornerButton.alpha = 0;
                    self.playCornerButton.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.buttonView.alpha = 0;
                    } completion:^(BOOL finished) {
                        if ([[UIScreen mainScreen] bounds].size.width == 320 && [[UIScreen mainScreen] bounds].size.height == 480) {
                            self.titleLabel.text = @"Tomorrow";
                            self.titleLabel.font = [UIFont fontWithName:@"Open Sans" size:30];
                            self.titleLabel.alpha = 0;
                            self.titleLabel.center = self.aboveTitleCenterPoint;
                            self.titleLabel.hidden = NO;
                            self.topLabel.text = @"\n\n\n\n\nbegins";
                            self.topLabel.center = self.middleTopLabel;
                            self.topLabel.textAlignment = NSTextAlignmentCenter;
                            self.topLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
                        } else if ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height > 480) {
                            self.titleLabel.text = @"Tomorrow";
                            self.titleLabel.alpha = 0;
                            self.titleLabel.center = self.centerTitleLabel;
                            self.titleLabel.hidden = NO;
                            self.topLabel.center = self.middleTopLabel;
                            self.topLabel.text = @"\n\n\nbegins";
                            self.topLabel.textAlignment = NSTextAlignmentCenter;
                            self.topLabel.font = [UIFont fontWithName:@"Open Sans" size:22];
                        } else {
                            self.titleLabel.text = @"Tomorrow";
                            self.titleLabel.alpha = 0;
                            self.titleLabel.center = self.centerTitleLabel;
                            self.titleLabel.hidden = NO;
                            self.topLabel.text = @"\n\n\nbegins";
                            self.topLabel.center = self.middleTopLabel;
                            self.topLabel.textAlignment = NSTextAlignmentCenter;
                            self.topLabel.font = [UIFont fontWithName:@"Open Sans" size:24];
                        }
                        self.topLabel.hidden = NO;
                        [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.titleLabel.alpha = 1;
                            if ([[UIScreen mainScreen] bounds].size.width == 320 && [[UIScreen mainScreen] bounds].size.height == 480) {
                                self.titleLabel.center = self.aboveTitleCenterPoint;
                            } else {
                                self.titleLabel.center = self.centerTitleLabel;
                            }
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.topLabel.center = self.middleTopLabel;
                                self.topLabel.alpha = 1;
                            } completion:^(BOOL finished) {
                                self.bottomLabel.alpha = 0;
                                self.bottomLabel.text = @"3";
                                self.bottomLabel.textAlignment = NSTextAlignmentCenter;
                                self.bottomLabel.font = [UIFont fontWithName:@"Open Sans" size:48];
                                self.bottomLabel.center = self.middleBottomLabel;
                                [UIView animateWithDuration:.8 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.bottomLabel.alpha = 1;
                                } completion:^(BOOL finished) {
                                    self.bottomLabel.alpha = 0;
                                    self.bottomLabel.text = @"2";
                                    self.bottomLabel.font = [UIFont fontWithName:@"Open Sans" size:48];
                                    self.bottomLabel.center = self.middleBottomLabel;
                                    [UIView animateWithDuration:.8 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.bottomLabel.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        self.bottomLabel.alpha = 0;
                                        self.bottomLabel.text = @"1";
                                        self.bottomLabel.font = [UIFont fontWithName:@"Open Sans" size:48];
                                        self.bottomLabel.center = self.middleBottomLabel;
                                        [UIView animateWithDuration:.8 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                            self.bottomLabel.alpha = 1;
                                        } completion:^(BOOL finished) {
                                            self.bottomLabel.alpha = 0;
                                            self.topLabel.alpha = 0;
                                            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                                self.menuView.menuButton.alpha = 0;
                                                self.titleLabel.alpha = 0;
                                                [NSTimer scheduledTimerWithTimeInterval:.65 target:self selector:@selector(newView) userInfo:nil repeats:NO];
                                            } completion:^(BOOL finished) {
                                                self.finishedIntro = YES;
                                                [[NSUserDefaults standardUserDefaults] setBool:self.finishedIntro forKey:finishedIntroKey];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                            }];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
        default:
            break;
    }
}

- (void)recordCornerPressed:(id)sender {
    if (self.circleState == IntroCircleStateNone) {
        return;
    }
    if (self.circleState == IntroCircleStateReady) {
        self.centerPlayButtonClone.hidden = YES;
        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.bottomLabel.alpha = .5;
            self.recordCornerButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
            self.recordCornerButtonClone.center = self.middlePointRecordCornerButton;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.bottomLabel.alpha = 0;
                self.recordCornerButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                self.recordCornerButtonClone.center = self.halfwayPointRecorderCornerPoint;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.recordCornerButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                    self.recordCornerButtonClone.center = self.buttonView.center;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.recordCornerButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                    } completion:^(BOOL finished) {
                        self.recordCornerButtonClone.hidden = YES;
                        self.recordCornerButtonClone.transform = CGAffineTransformIdentity;
                        self.buttonView.hidden = NO;
                        self.buttonView.recordButton.alpha = 1;
                        self.buttonView.recordButton.hidden = NO;
                        self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                self.playCornerButton.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveLinear animations:^{
                                    self.buttonView.recordButton.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished) {
                                    self.circleState = IntroCircleStateRecord;
                                    self.recordLabel.hidden = NO;
                                    [UIView animateWithDuration:.2 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.recordLabel.center = self.middleOfRecordLabel;
                                    } completion:^(BOOL finished) {
                                        self.circleState = IntroCircleStateRecord;
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }
}

- (void)cornerButtonPressed:(id)sender {
    if (self.circleState == IntroCircleStateNone) {
        return;
    }
    if (self.circleState == IntroCircleStateGetStarted) {
        return;
    }
    if (self.circleState == IntroCircleStatePlay) {
        self.playCornerButton.enabled = YES;
    }
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (sender == self.recordCornerButton) {
            self.buttonView.playButton.alpha = 0;
            self.circleState = IntroCircleStateRecord;
            self.centerPlayButtonClone.hidden = NO;
        }
        if (sender == self.playCornerButton) {
            self.buttonView.recordButton.alpha = 0;
            self.circleState = IntroCircleStatePlay;
            self.centerRecordButtonClone.hidden = NO;
            self.recordLabel.alpha = 0;
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
                [self recordCornerFinalAnimation];
            }
            if (sender == self.playCornerButton) {
                [self playCornerFinalAnimation];
            }
        }];
    }];
}

#pragma mark - Delegates

- (void)didTryToPlay:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    if (self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateAmbition || self.containerView.state == ButtonStateZero) {
        [self shakingAnimation];
        if (self.circleState == IntroCircleStateRecord) {
            self.recordLabel.text = @"To remove this recording and record again, press the red X button. To save, press the green check button.";

            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.recordAgainButton.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    self.recordLabel.center = self.middleOfRecordLabel;
                    self.recordLabel.alpha = 0;
                    self.recordLabel.hidden = NO;
                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.recordLabel.alpha = 1;
                    } completion:nil];
                }];
            }];
        }
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didTryToPlayWithPlayButton:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.circleState == IntroCircleStateFinished) {
                [self shakingAnimation];
                return;
            }

            if (self.circleState == IntroCircleStateRecord) {
                [self shakingAnimation];
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.recordLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.recordLabel.text = @"Choose a button below to proceed.";
                    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.recordLabel.alpha = 1;
                        self.recordLabel.center = self.middleOfRecordLabel;
                    } completion:^(BOOL finished) {
                    }];
                }];
            }
            if (self.circleState == IntroCircleStatePlay || self.circleState == IntroCircleStateNotifications) {
                self.tdView.hidden = NO;
                self.recordLabel.alpha = 0;
                [self recordPlayBlinkingAnimation];
                [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.menuView.menuButton.alpha = 0;
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3.5, 3.5);
                } completion:^(BOOL finished) {
                    self.menuView.menuButton.hidden = YES;
                    self.tdView.timeLabel.alpha = 1;
                    self.tdView.dateLabel.alpha = 1;
                    self.tdView.timeLabel.text = [[AudioController sharedInstance] currentTime];
                    self.tdView.dateLabel.text = [[AudioController sharedInstance] simpleDateString];

                    NSURL *welcomeURL = [[NSBundle mainBundle] URLForResource:@"welcome" withExtension:@"aiff"];
                    [[AudioController sharedInstance] playAudioFileAtURL:welcomeURL];
                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.recordPlayView.playImageView.layer removeAllAnimations];
            self.recordPlayView.hidden = YES;
            [[AudioController sharedInstance] stopPlayingAudio];
            self.tdView.hidden = YES;
            self.menuView.menuButton.hidden = NO;
            [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                self.menuView.menuButton.alpha = .5;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.13 delay:.1 options:UIViewAnimationOptionCurveLinear animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.menuView.menuButton.alpha = 1;
                } completion:^(BOOL finished) {
                    [[AudioController sharedInstance].babyPopAgainTwoPlayer play];
                    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.15 initialSpringVelocity:.08 options:UIViewAnimationOptionCurveLinear animations:^{
                        button.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {

                        if (self.circleState != IntroCircleStateFinished) {
                            self.recordLabel.alpha = 0;
                            if ([[UIScreen mainScreen] bounds].size.width == 320) {
                                self.recordLabel.text = @"\nYour message will be here tomorrow. Press and hold to hear it again.\nTo get your messages, tap the Square to enable notifications.";
                                self.recordLabel.textAlignment = NSTextAlignmentCenter;
                                self.recordLabel.font = [UIFont fontWithName:@"Open Sans" size:14];
                            } else if ([[UIScreen mainScreen] bounds].size.width == 320 && [UIScreen mainScreen].bounds.size.height > 480) {
                                self.recordLabel.font = [UIFont fontWithName:@"Open Sans" size:16];
                                self.recordLabel.text = @"Your message will be here tomorrow. Press and hold to hear it again.\nTo get your messages, tap the Square to enable notifications.";
                            } else {
                                self.recordLabel.text = @"Your message will be here tomorrow. Press and hold to hear the message again.\nTo get your messages, tap the Square to enable notifications.";
                            }
                        }
                        [UIView animateWithDuration:.3 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.recordLabel.center = self.middleOfRecordLabel;
                            self.recordLabel.alpha = 1;
                        } completion:^(BOOL finished) {
                            if (self.circleState != IntroCircleStateFinished) {
                                self.circleState = IntroCircleStateNotifications;
                            }
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

- (void)didTryToZoom:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    self.tdView.hidden = YES;
    self.recordLabel.hidden = YES;
    if (!self.micOn) {
        [self shakingAnimation];
        self.recordLabel.alpha = 0;
        self.recordLabel.text = @"You must enable your microphone to use the recording feature. Go to Settings > Privacy > Microphone";
        self.recordLabel.hidden = NO;
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 delay:2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.recordLabel.alpha = 0;
            } completion:nil];
        }];
        return;
    }
    if (self.micOn) {
        if (self.containerView.state == ButtonStateNone) {
            switch (sender.state) {
                case UIGestureRecognizerStateBegan:
                {
                    [self recording];
                    [self recordPlayBlinkingAnimation];
                    [UIView animateWithDuration:.2
                                          delay:0
                                        options:UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         self.menuView.menuButton.alpha = 0;
                                         self.menuView.menuButton.hidden = YES;
                                         button.transform = CGAffineTransformScale(button.transform, 3.5, 3.5);
                                         button.alpha = .7;
                                         self.playCornerButton.hidden = YES;
                                     } completion:^(BOOL finished) {

                                     }];
                }
                    break;
                case UIGestureRecognizerStateEnded:
                {
                    [self.recordPlayView.recordImageView.layer removeAllAnimations];
                    self.recordPlayView.hidden = YES;
                    [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                        button.alpha = 1;
                        self.menuView.menuButton.alpha = 1;

                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            button.transform = CGAffineTransformScale(button.transform, .9, .9);

                        } completion:^(BOOL finished) {
                            [self stopRecording];
                            NSURL *popURL = [[NSBundle mainBundle] URLForResource:@"babypop" withExtension:@"caf"];
                            [[AudioController sharedInstance] playAudioFileSoftlyAtURL:popURL];
                            [UIView animateWithDuration:.13 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);

                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.15 initialSpringVelocity:.08 options:UIViewAnimationOptionCurveLinear animations:^{
                                    button.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished) {
                                    button.backgroundColor = [UIColor customGreenColor];
                                    self.recordAgainButton.hidden = NO;
                                    self.recordAgainButton.alpha = 0;
                                    self.recordAgainLabel.hidden = NO;
                                    self.recordAgainLabel.alpha = 0;
                                    [self zeroState:ButtonStateZero];
                                    self.recordCornerButton.hidden = YES;
                                    self.playCornerButton.hidden = YES;

                                    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                        self.containerView.alpha = 1;
                                        self.recordAgainButton.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        [self showBottomButtons];
                                        self.recordLabel.text = @"Press the green check button to confirm the recording or the red X to remove it.";
                                        self.recordLabel.hidden = NO;
                                        self.recordLabel.alpha = 0;
                                        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                            self.recordLabel.alpha = 1;
                                        } completion:^(BOOL finished) {
                                            self.playCornerButton.enabled = YES;
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
    }
}

#pragma mark - Audio Recorder & Player

- (void)recording {
    [[AudioController sharedInstance] recordAudioToDirectory];
}

- (void)stopRecording {
    [[AudioController sharedInstance] stopRecording];
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
        self.buttonView.recordButton.layer.backgroundColor = [UIColor purpleColor].CGColor;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
