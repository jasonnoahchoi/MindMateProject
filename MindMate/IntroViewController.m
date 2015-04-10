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
#import "Recording.h"
#import "AudioController.h"
#import "UIColor+Colors.h"
#import "TimeAndDateView.h"
#import "MenuViewController.h"

@interface IntroViewController () <CategoryContainerViewDelegate, ButtonViewDelegate, MenuViewControllerDelegate>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) CategoryContainerView *containerView;
@property (nonatomic, strong) TimeAndDateView *tdView;
@property (nonatomic, strong) Recording *record;
@property (nonatomic, strong) MenuViewController *menuVC;
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

@property (nonatomic, assign) CGPoint centerRecordButton;
@property (nonatomic, assign) CGPoint centerPlayButton;
@property (nonatomic, assign) CGPoint endPointRecordCornerButton;
@property (nonatomic, assign) CGPoint endPointPlayCornerButton;

@property (nonatomic, assign) NSNumber *groupIDNumber;
@property (nonatomic, assign) NSInteger indexForRecording;
@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, strong) UIButton *menuButton;

@property (nonatomic, strong) UIButton *centerRecordButtonClone;
@property (nonatomic, strong) UIButton *centerPlayButtonClone;
@property (nonatomic, assign) CGPoint hidingPointRecordCornerPoint;
@property (nonatomic, assign) CGPoint hidingPointPlayCornerPoint;
@property (nonatomic, assign) CGPoint middlePointRecordCornerButton;
@property (nonatomic, assign) CGPoint middlePointPlayCornerButton;
@property (nonatomic, assign) CGPoint middlePointOfButton;
@property (nonatomic, assign) CGPoint halfwayPointRecorderCornerPoint;
@property (nonatomic, assign) CGPoint halfwayPointPlayCornerPoint;
@property (nonatomic, assign) CGRect circleRect;
@property (nonatomic, assign) BOOL showedMenuVC;

@property (nonatomic, strong) UIView *comeDownCircle;
@property (nonatomic, strong) UILabel *recordLabel;

@end


@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.circleState = IntroCircleStateRecord;
    //self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    //self.title = @"Record";
    self.groupIDNumber = @0;

    [self cornerButtons];
    [self afterRecordButtons];

    CGSize size = self.view.superview.frame.size;
    [self.view setCenter:CGPointMake(size.width/2, size.height/2)];

    self.circleRect = CGRectMake(self.view.frame.size.width/(2*4), self.view.frame.size.height/5, self.view.frame.size.width/1.35, self.view.frame.size.width/1.35);
    self.buttonView = [[ButtonView alloc] initWithFrame:self.circleRect];
    //self.buttonView.center = self.view.center;
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];
    self.buttonView.hidden = YES;

    [self buttonClones];
    [self initialAnimation];

    self.tdView = [[TimeAndDateView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 30, self.view.frame.size.width/2-10, 100)];

    [self.view addSubview:self.tdView];
    [self layoutMenuButton];
    self.menuVC = [[MenuViewController alloc] init];
    self.menuVC.delegate = self;
    self.recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/10 * 6, self.view.frame.size.width, self.view.frame.size.height/5)];
    [self.view addSubview:self.recordLabel];
    self.recordLabel.hidden = YES;
    self.recordLabel.text = @"Hold down on the circle to record your voice";
    self.recordLabel.numberOfLines = 0;
    self.recordLabel.font = [UIFont systemFontOfSize:24];
    self.recordLabel.textColor = [UIColor customGrayColor];
    self.recordLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];


//    if (self.showedMenuVC) {
//        self.showedMenuVC = NO;
//        [self reanimateCircles];
//}
}

- (void)showRecordLabel {
    self.recordLabel.alpha = 0;
    self.recordLabel.hidden = NO;
    [UIView animateWithDuration:1 delay:1.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recordLabel.alpha = 1;
    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:3 delay:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.recordLabel.text = @"You got this";
//        } completion:nil];
    }];
}

- (void)setCircleState:(IntroCircleState)circleState {
    if (_circleState == circleState) {
        return;
    }
    _circleState = circleState;

        switch (circleState) {
            case IntroCircleStateRecord:
               // [self showRecordLabel];
                break;
            case IntroCircleStatePlay:
            default:
                break;
        }
}

- (void)initialAnimation {
    self.comeDownCircle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/(2*4), 0 -self.view.frame.size.height/2, self.view.frame.size.width/1.35, self.view.frame.size.width/1.35)];
    [self.view addSubview:self.comeDownCircle];

    self.comeDownCircle.layer.cornerRadius = self.comeDownCircle.frame.size.width/2;
    self.comeDownCircle.backgroundColor = [UIColor customGreenColor];
    self.comeDownCircle.layer.masksToBounds = YES;
    self.comeDownCircle.layer.shouldRasterize = YES;
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.comeDownCircle.center = self.buttonView.center;
    } completion:^(BOOL finished) {
        self.buttonView.hidden = NO;
        self.comeDownCircle.hidden = YES;
        [UIView animateWithDuration:.3 delay:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self showRecordLabel];
            [self addPlayButtonAnimation];
            self.menuButton.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.buttonView.recordButton.transform = CGAffineTransformIdentity;

                } completion:nil];
            }];
        }];
    }];

}

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

#pragma mark - Buttons on View Controller

- (void)layoutEndPoints {
    CGRect endPointRecordAgainButton = CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height - self.view.frame.size.height/9.5, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointRecordAgainButton = CGPointMake(endPointRecordAgainButton.origin.x + (endPointRecordAgainButton.size.width/2), endPointRecordAgainButton.origin.y + (endPointRecordAgainButton.size.height/2));

    CGRect endPointConfirmButton = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/9.5, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointConfirmButton = CGPointMake(endPointConfirmButton.origin.x + (endPointConfirmButton.size.width/2), endPointConfirmButton.origin.y + (endPointConfirmButton.size.height/2));

}

- (void)layoutMenuButton {
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (self.view.frame.size.width/6), self.view.frame.size.height/18, self.view.frame.size.width/8, self.view.frame.size.width/7.8)];
    self.menuButton.backgroundColor = [UIColor customPurpleColor];
    self.menuButton.layer.masksToBounds = YES;
    self.menuButton.layer.cornerRadius = 5;
    [self.view addSubview:self.menuButton];
    self.menuButton.alpha = 0;
    //self.menuButton.hidden = YES;
    [self.menuButton addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)afterRecordButtons {
    [self layoutEndPoints];

    self.recordAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    self.recordAgainButton.backgroundColor = [UIColor customBlueColor];
    self.recordAgainButton.layer.cornerRadius = self.recordAgainButton.frame.size.width/2;
    self.recordAgainButton.layer.shouldRasterize = YES;
    self.recordAgainButton.hidden = YES;
    [self.view addSubview:self.recordAgainButton];
    self.centerRecordAgainButton = self.recordAgainButton.center;

    self.recordAgainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height - self.view.frame.size.height/11, self.view.frame.size.width/4, self.view.frame.size.height/11)];
    self.recordAgainLabel.text = @"Do Over";
    self.recordAgainLabel.textColor = [UIColor whiteColor];
    self.recordAgainLabel.textAlignment = NSTextAlignmentCenter;
    self.recordAgainLabel.hidden = YES;
    [self.view addSubview:self.recordAgainLabel];
    [self.recordAgainButton addTarget:self action:@selector(recordAgainPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.confirmButton];
    self.confirmButton.hidden = YES;
    self.confirmButton.backgroundColor = [UIColor customGreenColor];
    self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.width/2;
    self.confirmButton.layer.shouldRasterize = YES;
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchDown];
    self.centerConfirmButton = self.confirmButton.center;

    self.confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.view.frame.size.width/4 - 5, self.view.frame.size.height - self.view.frame.size.height/11, self.view.frame.size.width/4, self.view.frame.size.height/11)];
    self.confirmLabel.text = @"Confirm";
    self.confirmLabel.textColor = [UIColor whiteColor];
    self.confirmLabel.hidden = YES;
    self.confirmLabel.textAlignment = NSTextAlignmentCenter;
    //self.confirmLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.confirmLabel];

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

#pragma mark - Getters

- (void)recordAgainPressed:(id)sender {
    self.confirmLabel.alpha = 0;
    self.recordAgainLabel.alpha = 0;
    Recording *recording = [RecordingController sharedInstance].memos.lastObject;
    [[RecordingController sharedInstance] removeRecording:recording];
    [[RecordingController sharedInstance] save];

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        //self.confirmButton.alpha = 0;
        //self.recordAgainButton.alpha = 0;
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self hideBottomButtons];
        self.containerView.state = ButtonStateNone;
        [self noneState:ButtonStateNone];
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
            self.containerView.state = ButtonStateNone;
            [self noneState:ButtonStateNone];
            self.counter++;
        }];
    }
}

- (void)menuPressed:(id)sender {
    switch (self.circleState) {
        case (IntroCircleStateRecord):
        {
            self.buttonView.hidden = YES;
            self.centerRecordButtonClone.hidden = NO;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.menuButton.alpha = 0;
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
                                    self.menuButton.hidden = YES;
                                    //self.buttonView.hidden = NO;
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
            break;
        case (IntroCircleStatePlay):
        {
            self.buttonView.hidden = YES;
            self.centerPlayButtonClone.hidden = NO;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.menuButton.alpha = 0;
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
                                    // self.centerRecordButtonClone.transform = CGAffineTransformIdentity;
                                    // self.centerRecordButtonClone.center = self.buttonView.center;
                                    self.menuButton.hidden = YES;
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

- (void)reanimateCircles {
    switch (self.circleState) {
        case (IntroCircleStateRecord):
        {
            self.centerRecordButtonClone.center = self.endPointRecordCornerButton;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

                self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.menuButton.alpha = 0;
                    self.menuButton.hidden = NO;
                    self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.menuButton.alpha = 1;
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
                                    self.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                                    self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.menuButton.transform = CGAffineTransformIdentity;
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
                                    //self.buttonView.hidden = NO;
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }
            break;
        case (IntroCircleStatePlay):
        {
            self.centerPlayButtonClone.hidden = NO;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.centerPlayButtonClone.center = self.endPointPlayCornerButton;
                self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.menuButton.alpha = 0;
                    self.menuButton.hidden = NO;
                    self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.menuButton.alpha = 1;
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
                                    self.menuButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                                    self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.menuButton.transform = CGAffineTransformIdentity;
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

- (void)cornerButtonPressed:(id)sender {
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
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
                //self.playCornerButton.alpha = 0;
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.recordCornerButton.center = self.halfwayPointRecorderCornerPoint;
                    self.centerPlayButtonClone.center = self.middlePointPlayCornerButton;
                    self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                        self.recordCornerButton.center = self.buttonView.center;
                        self.centerPlayButtonClone.center = self.endPointPlayCornerButton;
                        self.centerPlayButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                    } completion:^(BOOL finished) {
                        self.playCornerButton.center = self.endPointPlayCornerButton;
                        self.playCornerButton.alpha = 1;
                        self.centerPlayButtonClone.hidden = YES;
                        self.playCornerButton.hidden = NO;
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            // self.playCornerButton.transform = CGAffineTransformIdentity;
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
                            //self.buttonView.recordButton.center = self.buttonView.center;
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
                                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
            if (sender == self.playCornerButton) {
                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.playCornerButton.center = self.halfwayPointPlayCornerPoint;
                    self.centerRecordButtonClone.center = self.middlePointRecordCornerButton;
                    self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                        self.playCornerButton.center = self.buttonView.center;
                        self.centerRecordButtonClone.center = self.endPointRecordCornerButton;
                        self.centerRecordButtonClone.transform = CGAffineTransformScale(CGAffineTransformIdentity, .667, .667);
                    } completion:^(BOOL finished) {
                        self.recordCornerButton.center = self.endPointRecordCornerButton;
                        self.recordCornerButton.alpha = 1;
                        self.centerRecordButtonClone.hidden = YES;
                        self.recordCornerButton.hidden = NO;
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
                                    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.buttonView.playButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                                        self.recordCornerButton.transform = CGAffineTransformIdentity;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:.2 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
        NSLog(@"Shaking");
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.recordAgainButton.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];

    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog(@"Notification received");
    //    self.record = [RecordingController sharedInstance].memos.lastObject;
    //    [[RecordingController sharedInstance] removeRecording:self.record];
    //self.counter--;
}

- (void)labelDidChange:(NSNotification *)notification {
    //self.indexForRecording = self.mutableRecordings.count - 1;

    //    if ([[notification name] isEqualToString:kLabelDidChange]){
    //    NSLog(@"Label");
    //    for (int i = 0; i < self.mutableRecordings.count; i++) {
    //NSLog(@"Notification Label Called: %d", i++);



    //int i = [AudioController sharedInstance].index;
    //for (int i = [AudioController sharedInstance].index; i < self.mutableRecordings.count; i++) {
    if (self.indexForRecording <= (self.mutableRecordings.count)) {
        self.tdView.timeLabel.text =  self.mutableRecordings[self.indexForRecording];

        self.tdView.dateLabel.text = self.record.simpleDate;
    } else {
        return;
    }
    self.indexForRecording--;

    NSLog(@"Called Label did change");
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didTryToPlayWithPlayButton:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    //    if ([RecordingController sharedInstance].memos) {
    //        [self predicate];
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
                NSLog(@"Shaking");

                [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
                            } completion:nil];
                        }];

                    }];
                }];
            }
            if ([RecordingController sharedInstance].memos.count > 0) {
                self.tdView.hidden = NO;

                [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.menuButton.alpha = 0;
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3.5, 3.5);
                } completion:^(BOOL finished) {
                    self.menuButton.hidden = YES;
                    NSArray *array = [RecordingController sharedInstance].memos;
                    //NSArray *array = [RecordingController sharedInstance].fetchMemos;
                    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
                    self.mutableRecordings = [[NSMutableArray alloc] init];
                    //Recording *recording = [RecordingController sharedInstance].memos.firstObject;
                    for (int i = 0; i < [array count]; i++) {
                        Recording *recording = [RecordingController sharedInstance].memos[i];
                        // Recording *recording = [RecordingController sharedInstance].fetchMemos[i];
                        [self.mutableRecordings addObject:recording.timeCreated];
                        self.tdView.timeLabel.text = recording.timeCreated;
                        self.tdView.dateLabel.text = recording.simpleDate;

                        //AVAsset *asset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:recording.simpleDate]];
                        //AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
                        //[mutableArray addObject:item];
                        NSArray *documentsPath = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], recording.urlPath, nil];
                        NSURL *urlPath = [NSURL fileURLWithPathComponents:documentsPath];

                        [mutableArray addObject:urlPath];

                        self.record = recording;
                    }
                    self.indexForRecording = self.mutableRecordings.count - 2;
                    [AudioController sharedInstance].audioFileQueue = mutableArray;
                    for (int i = 0; i < [AudioController sharedInstance].audioFileQueue.count; i++) {
                        [AudioController sharedInstance].index = i;

                        [[AudioController sharedInstance] playAudioWithInt:i];
                    }

                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelDidChange:) name:kLabelDidChange object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:kAudioFileFinished object:nil];

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
            [[AudioController sharedInstance] stopPlayingAudio];
            self.tdView.hidden = YES;
            self.menuButton.hidden = NO;

            //            for (int i = 0; i < self.mutableRecordings.count ; i++) {
            //               // [[NSNotificationCenter defaultCenter] postNotificationName:kAudioFileFinished object:self userInfo:nil];
            //            }


            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                self.menuButton.alpha = .5;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.menuButton.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.05 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);

                        } completion:nil];
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
    if (self.containerView.state == ButtonStateNone) {
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
            {
                [self recording];
                self.navigationController.navigationBar.backgroundColor = [UIColor customDarkPurpleColor];
                [UIView animateWithDuration:.3
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.menuButton.alpha = 0;
                                     button.transform = CGAffineTransformScale(button.transform, 3.5, 3.5);
                                     button.alpha = .7;
                                     self.playCornerButton.hidden = YES;
                                 } completion:nil];
                // self.buttonView.playButton.enabled = NO;
                //self.on = YES;

            } break;
            case UIGestureRecognizerStateEnded:
            {
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                    button.alpha = 1;
                    self.menuButton.alpha = 1;

                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        button.transform = CGAffineTransformScale(button.transform, .9, .9);

                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);

                            //self.buttonView.recordingComplete = YES;

                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                button.transform = CGAffineTransformIdentity;

                            } completion:^(BOOL finished) {
                                self.containerView.alpha = 0;
                                self.containerView.hidden = YES;
                                self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
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
                                    [self.containerView animateLayoutButtons];
                                    self.recordAgainButton.alpha = 1;
                                } completion:^(BOOL finished) {
                                    [self stopRecording];
                                    [UIView animateWithDuration:.4 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.recordAgainButton.center = self.endPointRecordAgainButton;
                                        self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
                                        self.recordAgainLabel.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                            self.recordAgainButton.transform = CGAffineTransformIdentity;
                                            [self showBottomButtons];
                                        } completion:nil];
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

#pragma mark - Audio Recorder & Player

- (void)recording {
    [[AudioController sharedInstance] recordAudioToDirectory];
    NSLog(@"----------RECORDING STARTED-------------- %@", [[AudioController sharedInstance] recordAudioToDirectory]);
    //    }
}

- (void)stopRecording {
    [[AudioController sharedInstance] stopRecording];
}

- (void)hideBottomButtons {
    self.confirmLabel.hidden = YES;
    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
    self.recordAgainButton.alpha = 0.7;
    self.recordAgainButton.hidden = NO;
    self.recordAgainLabel.hidden = NO;
    self.confirmButton.alpha = 0.7;
    self.confirmButton.hidden = NO;
    self.confirmLabel.hidden = NO;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.confirmButton.center = self.endPointConfirmButton;
        self.confirmButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.confirmButton.transform = CGAffineTransformIdentity;
        } completion:nil];

    }];
}

- (void)setAlphaOfBottomButtons {
    self.confirmButton.alpha = 1;
    self.recordAgainButton.alpha = 1;
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
