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

@property (nonatomic, strong) UIButton *recordCornerButton;
@property (nonatomic, strong) UIButton *playCornerButton;

@property (nonatomic, assign) CGPoint centerRecordButton;
@property (nonatomic, assign) CGPoint centerPlayButton;
@property (nonatomic, assign) NSNumber *groupIDNumber;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    self.title = @"Record";
    self.groupIDNumber = @0;
    //self.buttonView = [[ButtonView alloc] initWithFrame:self.view.frame];

    [self cornerButtons];
    [self afterRecordButtons];

    CGSize size = self.view.superview.frame.size;
    [self.view setCenter:CGPointMake(size.width/2, size.height/2)];

    //self.buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), self.view.frame.size.width/2, self.view.frame.size.width/2)];
    CGRect circle = CGRectMake(self.view.frame.size.width/(2*4), self.view.frame.size.height/5, self.view.frame.size.width/1.35, self.view.frame.size.width/1.35);
    self.buttonView = [[ButtonView alloc] initWithFrame:circle];
    //self.buttonView.center = self.view.center;
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];
//    self.buttonView.hidden = YES;
}

- (void)afterRecordButtons {
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/10 * 9, self.view.frame.size.width - 20, self.view.frame.size.height/10-5)];
    [self.view addSubview:self.confirmButton];
    self.confirmButton.hidden = YES;
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor customPurpleColor];
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchDown];

    self.containerView = [[CategoryContainerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/10 * 7, self.view.frame.size.width, self.view.frame.size.height/5)];
    self.containerView.delegate = self;
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
}

- (void)cornerButtons {
    self.recordCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.recordCornerButton];
    self.recordCornerButton.backgroundColor = [UIColor customPurpleColor];
    self.recordCornerButton.hidden = YES;
    self.recordCornerButton.layer.cornerRadius = self.recordCornerButton.frame.size.height/2;
    self.recordCornerButton.layer.masksToBounds = YES;
    self.recordCornerButton.layer.shouldRasterize = YES;
    self.centerRecordButton = self.recordCornerButton.center;
    [self.recordCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.playCornerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:self.playCornerButton];
    self.playCornerButton.backgroundColor = [UIColor customGreenColor];
    self.playCornerButton.layer.cornerRadius = self.playCornerButton.frame.size.height/2;
    self.playCornerButton.layer.masksToBounds = YES;
    self.playCornerButton.layer.shouldRasterize = YES;
    self.centerPlayButton = self.playCornerButton.center;
    [self.playCornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmPressed:(id)sender {
    [[RecordingController sharedInstance] addGroupID:self.groupIDNumber];
    [[RecordingController sharedInstance] save];

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
        self.confirmButton.alpha = 0;
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        self.confirmButton.hidden = YES;
        self.containerView.hidden = YES;
        self.containerView.alpha = 1;
        self.confirmButton.alpha = 1;
        self.containerView.state = ButtonStateNone;
        [self noneState:ButtonStateNone];
    }];
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
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.playCornerButton.hidden = NO;
                    self.playCornerButton.alpha = 1;
                    self.recordCornerButton.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.recordCornerButton.hidden = NO;
                    self.recordCornerButton.alpha = 1;
                    self.playCornerButton.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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

- (void)didTryToShake:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    if (self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateAmbition || self.containerView.state == ButtonStateZero) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.07];
        [animation setRepeatCount:2];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([self.buttonView.recordButton center].x + 20, [self.buttonView.recordButton center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([self.buttonView.recordButton center].x - 20, [self.buttonView.recordButton center].y)]];
        [[self.buttonView.recordButton layer] addAnimation:animation forKey:@"position"];
        NSLog(@"Shaking");
    }
}

- (void)didTryToZoom:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    if (self.containerView.state == ButtonStateNone) {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self recording];
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
//                                self.buttonView.recordCompleteLabel.hidden = NO;
//                                [NSTimer scheduledTimerWithTimeInterval:.65
//                                                                 target:self
//                                                               selector:@selector(hideLabel)
//                                                               userInfo:nil
//                                                                repeats:NO];

                                button.transform = CGAffineTransformIdentity;

                            } completion:^(BOOL finished) {
                                self.containerView.hidden = NO;
                                button.backgroundColor = [UIColor customPurpleColor];
                                //[self.containerView setState:ButtonStateZero];
                                [self zeroState:ButtonStateZero];
                                NSLog(@"Zoomed");
                                self.confirmButton.hidden = NO;
                                self.recordCornerButton.hidden = YES;
                                self.playCornerButton.hidden = YES;
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

- (void)recording {
    [[AudioController sharedInstance] recordAudioToDirectory];
    NSLog(@"----------RECORDING STARTED-------------- %@", [[AudioController sharedInstance] recordAudioToDirectory]);
//    }
}

- (void)stopRecording {
    [[AudioController sharedInstance] stopRecording];
}

#pragma mark - Audio Recorder & Player

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

#pragma mark - States Typedef

- (void)noneState:(ButtonState)state {
    state = ButtonStateNone;
    self.playCornerButton.alpha = 0;
    self.groupIDNumber = @0;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
        self.playCornerButton.hidden = NO;
        self.playCornerButton.alpha = 1;
    }];
}

- (void)focusState:(ButtonState)state {
    state = ButtonStateFocus;
    self.groupIDNumber = @1;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customGreenColor].CGColor;
    }];
}

- (void)courageState:(ButtonState)state {
    state = ButtonStateCourage;
    self.groupIDNumber = @2;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor redColor].CGColor;
    }];
}

- (void)ambitionState:(ButtonState)state {
    state = ButtonStateAmbition;
    self.groupIDNumber = @3;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
    }];
}
- (void)imaginationState:(ButtonState)state {
    state = ButtonStateImagination;
    self.groupIDNumber = @4;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor purpleColor].CGColor;
    }];
}
- (void)funState:(ButtonState)state {
    state = ButtonStateFun;
    self.groupIDNumber = @5;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor cyanColor].CGColor;
    }];
}
- (void)presenceState:(ButtonState)state {
    state = ButtonStatePresence;
    self.groupIDNumber = @6;
    [UIView animateWithDuration:.3 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor yellowColor].CGColor;
    }];
}

- (void)zeroState:(ButtonState)state {
    state = ButtonStateZero;
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
