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
#import "RecordingController.h"
#import "Recording.h"
#import "AudioController.h"
#import "UIColor+Colors.h"

@interface AudioViewController () <CategoryContainerViewDelegate, ButtonViewDelegate>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) CategoryContainerView *containerView;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *recordAgainButton;
@property (nonatomic, strong) UILabel *confirmLabel;
@property (nonatomic, strong) UILabel *recordAgainLabel;
@property (nonatomic, strong) UIButton *invisibleConfirmButton;
@property (nonatomic, strong) UIButton *invisibleRecordAgainButton;
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

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    self.title = @"Record";
    self.groupIDNumber = @0;

    [self cornerButtons];
    [self afterRecordButtons];

    CGSize size = self.view.superview.frame.size;
    [self.view setCenter:CGPointMake(size.width/2, size.height/2)];

    CGRect circle = CGRectMake(self.view.frame.size.width/(2*4), self.view.frame.size.height/5, self.view.frame.size.width/1.35, self.view.frame.size.width/1.35);
    self.buttonView = [[ButtonView alloc] initWithFrame:circle];
    //self.buttonView.center = self.view.center;
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];
//    self.buttonView.hidden = YES;
}

#pragma mark - Buttons on View Controller

- (void)layoutEndPoints {
    CGRect endPointRecordAgainButton = CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height - self.view.frame.size.height/9.5, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointRecordAgainButton = CGPointMake(endPointRecordAgainButton.origin.x + (endPointRecordAgainButton.size.width/2), endPointRecordAgainButton.origin.y + (endPointRecordAgainButton.size.height/2));

    CGRect endPointConfirmButton = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/9.5, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointConfirmButton = CGPointMake(endPointConfirmButton.origin.x + (endPointConfirmButton.size.width/2), endPointConfirmButton.origin.y + (endPointConfirmButton.size.height/2));

}

- (void)afterRecordButtons {
    [self layoutEndPoints];

    self.recordAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    self.recordAgainButton.backgroundColor = [UIColor redColor];
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
    self.confirmButton.backgroundColor = [UIColor customPurpleColor];
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

- (void)cornerButtons {
    CGRect endPointRecordCornerButton = CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointRecordCornerButton = CGPointMake(endPointRecordCornerButton.origin.x + (endPointRecordCornerButton.size.width/2), endPointRecordCornerButton.origin.y + (endPointRecordCornerButton.size.height/2));

    CGRect endPointPlayCornerButton = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointPlayCornerButton = CGPointMake(endPointPlayCornerButton.origin.x + (endPointPlayCornerButton.size.width/2), endPointPlayCornerButton.origin.y + (endPointPlayCornerButton.size.height/2));

    self.recordCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - self.view.frame.size.width/3, self.view.frame.size.height + self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.recordCornerButton];
    self.recordCornerButton.backgroundColor = [UIColor customPurpleColor];
    self.recordCornerButton.hidden = YES;
    self.recordCornerButton.layer.cornerRadius = self.recordCornerButton.frame.size.height/2;
    self.recordCornerButton.layer.masksToBounds = YES;
    self.recordCornerButton.layer.shouldRasterize = YES;
    self.centerRecordButton = self.recordCornerButton.center;
    [self.recordCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.playCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width + self.view.frame.size.width/3, self.view.frame.size.height + self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.playCornerButton];
    self.playCornerButton.backgroundColor = [UIColor customGreenColor];
    self.playCornerButton.layer.cornerRadius = self.playCornerButton.frame.size.height/2;
    self.playCornerButton.layer.masksToBounds = YES;
    self.playCornerButton.layer.shouldRasterize = YES;
    self.centerPlayButton = self.playCornerButton.center;
    [self.playCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addAnimation];
}

- (void)addAnimation {
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
    Recording *recording = [RecordingController sharedInstance].memos.lastObject;
    [[RecordingController sharedInstance] removeRecording:recording];
    [[RecordingController sharedInstance] save];

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
        //self.confirmButton.alpha = 0;
        //self.recordAgainButton.alpha = 0;
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self hideBottomButtons];
        self.containerView.state = ButtonStateNone;
        [self noneState:ButtonStateNone];
    }];
    self.title = @"Record";

}

- (void)confirmPressed:(id)sender {
    if (self.containerView.state != ButtonStateZero || self.containerView.state != ButtonStateNone) {
        [[RecordingController sharedInstance] addGroupID:self.groupIDNumber];
        [[RecordingController sharedInstance] save];

        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
            self.confirmButton.alpha = 0;
            self.containerView.alpha = 0;
        } completion:^(BOOL finished) {
            [self hideBottomButtons];
            self.containerView.state = ButtonStateNone;
            [self noneState:ButtonStateNone];
        }];
    }
    self.title = @"Record";
}

- (void)cornerButtonPressed:(id)sender {
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (sender == self.recordCornerButton) {
            self.buttonView.playButton.alpha = 0;
        }
        if (sender == self.playCornerButton) {

            self.buttonView.recordButton.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (sender == self.recordCornerButton) {
                self.buttonView.playButton.alpha = 0;
                self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                self.recordCornerButton.center = CGPointMake(self.buttonView.center.x, self.buttonView.center.y);
                self.recordCornerButton.alpha = 1;
            }
            if (sender == self.playCornerButton) {
                self.buttonView.recordButton.alpha = 0;
                self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                self.playCornerButton.center = CGPointMake(self.buttonView.center.x, self.buttonView.center.y);
                self.playCornerButton.alpha = 1;
            }
        } completion:^(BOOL finished) {
            if (sender == self.recordCornerButton) {
                self.playCornerButton.alpha = 0;
                self.title = @"Record";
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.playCornerButton.hidden = NO;
                    self.playCornerButton.alpha = 1;
                    self.playCornerButton.center = self.endPointPlayCornerButton;
                    self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.playCornerButton.transform = CGAffineTransformIdentity;
                        self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                    } completion:^(BOOL finished) {
                        self.recordCornerButton.hidden = YES;
                        self.recordCornerButton.transform = CGAffineTransformIdentity;
                        self.buttonView.hidden = NO;
                        self.buttonView.recordButton.hidden = NO;
                        self.buttonView.playButton.alpha = 1;
                        self.buttonView.playButton.hidden = YES;
                        self.recordCornerButton.center = self.centerRecordButton;
                    }];
                }];
            }
            if (sender == self.playCornerButton) {
                self.title = @"Play";
                self.recordCornerButton.alpha = 0;
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.recordCornerButton.hidden = NO;
                    self.recordCornerButton.alpha = 1;
                    self.recordCornerButton.center = self.endPointRecordCornerButton;
                    self.recordCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.recordCornerButton.transform = CGAffineTransformIdentity;
                        self.playCornerButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                    } completion:^(BOOL finished) {
                        self.playCornerButton.hidden = YES;
                        self.playCornerButton.transform = CGAffineTransformIdentity;
                        self.buttonView.hidden = NO;
                        self.buttonView.playButton.hidden = NO;
                        self.buttonView.recordButton.alpha = 1;
                        self.buttonView.recordButton.hidden = YES;
                        self.playCornerButton.center = self.centerPlayButton;

                    }];
                }];
            }
        }];
    }];
}

#pragma mark - Delegates

- (void)didTryToPlay:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    if (self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateAmbition || self.containerView.state == ButtonStateZero) {
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
            {
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    button.backgroundColor = [UIColor customGreenColor];
                    button.transform = CGAffineTransformScale(button.transform, 0.6, 0.6);
                } completion:^(BOOL finished) {
                    [[AudioController sharedInstance] playAudio];
                }];
            }
                break;
            case UIGestureRecognizerStateEnded:
                {
                    //button.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                } completion:^(BOOL finished) {
                    [[[AudioController sharedInstance] playAudio] stop];
                    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            button.transform = CGAffineTransformIdentity;
                            button.backgroundColor = [UIColor customPurpleColor];
                        } completion:^(BOOL finished) {



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



- (void)didTryToZoom:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
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
                                     button.transform = CGAffineTransformScale(button.transform, 3.5, 3.5);
                                     button.alpha = .7;
                                     self.playCornerButton.hidden = YES;
                                 } completion:nil];
                // self.buttonView.playButton.enabled = NO;
                //self.on = YES;

            } break;
            case UIGestureRecognizerStateEnded:
            {
                [self stopRecording];
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                    button.alpha = 1;

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
                                self.containerView.hidden = NO;
                                self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
                                button.backgroundColor = [UIColor customPurpleColor];
                                self.recordAgainButton.hidden = NO;
                                self.recordAgainButton.alpha = 0;
                                self.recordAgainLabel.hidden = NO;
                                self.recordAgainLabel.alpha = 0;
                                [self zeroState:ButtonStateZero];
                                self.title = @"Choose a State";
                                NSLog(@"Zoomed");
                                self.recordCornerButton.hidden = YES;
                                self.playCornerButton.hidden = YES;
                                [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    self.containerView.alpha = 1;
                                    self.recordAgainButton.alpha = 1;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                        self.recordAgainButton.center = self.endPointRecordAgainButton;
                                        self.recordAgainButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.05);
                                        self.recordAgainLabel.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                            self.recordAgainButton.transform = CGAffineTransformIdentity;
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


//- (void)recordTap:(UIButton *)sender {
//    if (sender.selected) {
//        // stop
//        [self.recorder stop];
//        self.buttonView.playButton.enabled = YES;
//        //[self.recordingTimer invalidate];
//       // self.recordingTimer = nil;
//        NSLog(@"%@", self.recorder.url);
//        // [self.microphone stopFetchingAudio];
//
//        NSData *data = [NSData dataWithContentsOfURL:self.recorder.url];
//        [data writeToFile:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@", [[AudioController sharedInstance] filePath]]] atomically:YES];
//        //[data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self filePath]]] atomically:YES];
//        NSLog(@"Data File: %@", data);
//        // [[RecordingController sharedInstance] addRecordingWithFile:data];
//        [[RecordingController sharedInstance] addRecordingWithURL:[[AudioController sharedInstance] filePath]
//                                                      andIDNumber:[[AudioController sharedInstance] randomIDNumber]
//                                                   andDateCreated:[[AudioController sharedInstance] createdAtDate]
//                                                     andFetchDate:[[AudioController sharedInstance] fetchDate]
//                                                    andSimpleDate:[[AudioController sharedInstance] simpleDateString]
//                                                     andGroupName:[[AudioController sharedInstance] groupName]];
//        //[RecordingController sharedInstance] addGroupWithName:
//
//        NSLog(@"ControllerRecordingPath: %@", [[AudioController sharedInstance] filePath]);
//        [[RecordingController sharedInstance] save];
//        NSLog(@"Date Created: %@, Fetch Date: %@, IDNUMBER: %@", [[AudioController sharedInstance] createdAtDate], [[AudioController sharedInstance] fetchDate], [[AudioController sharedInstance] randomIDNumber]);
//
//        //[[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:data attributes:nil];
//
//    } else {
//        // start
//        self.buttonView.playButton.enabled = NO;
//
//        self.recorder = [[AudioController sharedInstance] recordAudioToDirectory];
//
//        self.recorder.delegate = self;
////        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
////        [self.recordingTimer fire];
//        // [self.microphone startFetchingAudio];
//
//        // [self initializeViewController];
//        //  [self drawBufferPlot];
//
//    }
//    sender.selected = !sender.selected;
//}

//- (void)playTap:(id)sender
//{
//    //    [SimpleAudioPlayer playFile:_recorder.url.description];
//    self.player.delegate = self;
//
//    NSLog(@"duration: %f", self.player.duration);
//}

- (void)hideBottomButtons {
    self.confirmLabel.hidden = YES;
    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recordAgainButton.center = self.centerRecordAgainButton;
        self.recordAgainLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.recordAgainButton.hidden = YES;
        self.recordAgainLabel.hidden = YES;
        self.recordAgainLabel.alpha = 1;
    }];
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.confirmButton.center = self.centerConfirmButton;
        self.recordAgainLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.confirmButton.hidden = YES;
        self.recordAgainLabel.alpha = 1;
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
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
        self.playCornerButton.hidden = NO;
        self.playCornerButton.alpha = 1;
        [self addAnimation];
    }];
}

- (void)focusState:(ButtonState)state {
    state = ButtonStateFocus;
    [self showBottomButtons];
    self.groupIDNumber = @1;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
        [self setAlphaOfBottomButtons];
    }];
}

- (void)courageState:(ButtonState)state {
    state = ButtonStateCourage;
    [self showBottomButtons];
    self.groupIDNumber = @2;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor redColor].CGColor;
        [self setAlphaOfBottomButtons];
    }];
}

- (void)ambitionState:(ButtonState)state {
    state = ButtonStateAmbition;
    [self showBottomButtons];
    self.groupIDNumber = @3;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
        [self setAlphaOfBottomButtons];
    }];
}
- (void)imaginationState:(ButtonState)state {
    state = ButtonStateImagination;
    [self showBottomButtons];
    self.groupIDNumber = @4;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor purpleColor].CGColor;
        [self setAlphaOfBottomButtons];
    }];
}
- (void)funState:(ButtonState)state {
    state = ButtonStateFun;
    [self showBottomButtons];
    self.groupIDNumber = @5;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor cyanColor].CGColor;
        [self setAlphaOfBottomButtons];
    }];
}
- (void)presenceState:(ButtonState)state {
    state = ButtonStatePresence;
    [self showBottomButtons];
    self.groupIDNumber = @6;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor yellowColor].CGColor;
        [self setAlphaOfBottomButtons];
    }];
}

- (void)zeroState:(ButtonState)state {
    state = ButtonStateZero;
    [self.containerView setState:ButtonStateZero];
    //self.confirmButton.hidden = NO;
    self.groupIDNumber = @0;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
    }];
    
}

//- (void)hideLabel {
//    self.buttonView.recordCompleteLabel.hidden = YES;
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
