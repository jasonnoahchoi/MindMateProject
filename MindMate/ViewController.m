//
//  ViewController.m
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "ViewController.h"
#import "ButtonView.h"
#import "CategoryContainerView.h"
#import "RecordingController.h"
#import "Recording.h"
#import "AudioController.h"

@interface ViewController () <CategoryContainerViewDelegate, ButtonViewDelegate>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) CategoryContainerView *containerView;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //self.buttonView = [[ButtonView alloc] initWithFrame:self.view.frame];


    self.containerView = [[CategoryContainerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/4 * 3, self.view.frame.size.width, self.view.frame.size.height/4)];
    self.containerView.delegate = self;
    //self.categoryContainerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.containerView];

    self.buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, CGRectGetMidY(self.view.bounds) - 200, 300, 300)];
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];

//    if ((self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateAmbition) && self.containerView.state != ButtonStateNone) {
// //   //    [self buttonView:self.buttonView didTryToZoom:self.buttonView.recordButton];
//    } else if (self.containerView.state == ButtonStateNone) {
// //  //     [self buttonView:self.buttonView didTryToShake:self.buttonView.recordButton];

}
- (void)recordButtonReleasedWithGesture:(UIGestureRecognizerState)state {
//- (void)recordButtonReleased:(ButtonView *)view withButton:(UIButton *)sender {
//    if (state == UIGestureRecognizerStateEnded) {
//        switch (self.containerView.state) {
//            case ButtonStateNone:
//                //[self buttonView:self.buttonView didTryToShake:self.buttonView.recordButton];
//                break;
//            case ButtonStateFocus:
//            case ButtonStateCourage:
//            case ButtonStateImagination:
//            case ButtonStatePresence:
//            case ButtonStateFun:
//            case ButtonStateAmbition:
//            {
                //[self.recorder stop];
    if (state == UIGestureRecognizerStateEnded) {
        [self audioRecorderDidFinishRecording:self.recorder successfully:YES];
        //self.buttonView.playButton.enabled = YES;
        //[self.recordingTimer invalidate];
        // self.recordingTimer = nil;
        NSLog(@"\n\nURL:%@", self.recorder.url);
        // [self.microphone stopFetchingAudio];

        NSData *data = [NSData dataWithContentsOfURL:self.recorder.url];
        [data writeToFile:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@", [[AudioController sharedInstance] filePath]]] atomically:YES];
        //[data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self filePath]]] atomically:YES];
        //NSLog(@"\n\n\nData File: %@", data);
        // [[RecordingController sharedInstance] addRecordingWithFile:data];
        [[RecordingController sharedInstance] addRecordingWithURL:[[AudioController sharedInstance] filePath]
                                                      andIDNumber:[[AudioController sharedInstance] randomIDNumber]
                                                   andDateCreated:[[AudioController sharedInstance] createdAtDate]
                                                     andFetchDate:[[AudioController sharedInstance] fetchDate]
                                                    andSimpleDate:[[AudioController sharedInstance] simpleDateString]
                                                     andGroupName:[[AudioController sharedInstance] groupName]];
        //[RecordingController sharedInstance] addGroupWithName:

        //NSLog(@"\n \nControllerRecordingPath: %@", [[AudioController sharedInstance] filePath]);
        [[RecordingController sharedInstance] save];
        NSLog(@"\n\n Date Created: %@, Fetch Date: %@, IDNUMBER: %@", [[AudioController sharedInstance] createdAtDate], [[AudioController sharedInstance] fetchDate], [[AudioController sharedInstance] randomIDNumber]);
    }
}
//                return;
//                break;
//            }
//            default:
//                break;
//        }
//}


            //[[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:data attributes:nil];

            //            } else {
            //                // start
            //                self.buttonView.playButton.enabled = NO;
            //
            //                self.recorder = [[AudioController sharedInstance] recordAudioToDirectory];
            //
            //                self.recorder.delegate = self;
            //        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
            //        [self.recordingTimer fire];
            // [self.microphone startFetchingAudio];

            // [self initializeViewController];
            //  [self drawBufferPlot];


            //[self buttonView:view didTryToShake:self.buttonView.recordButton];

- (void)recordButtonPressedWithGesture:(UIGestureRecognizerState)state {
//- (void)recordButtonPressed:(ButtonView *)view withButton:(UIButton *)sender {
//    switch (self.containerView.state) {
//        case ButtonStateNone:
//            //[self buttonView:self.buttonView didTryToShake:self.buttonView.recordButton];
//            break;
//        case ButtonStateFocus:
//        case ButtonStateCourage:
//        case ButtonStateImagination:
//        case ButtonStatePresence:
//        case ButtonStateFun:
//        case ButtonStateAmbition:
    if (state == UIGestureRecognizerStateBegan) {
        self.buttonView.playButton.enabled = NO;
        self.recorder.delegate = self;
        self.recorder = [[AudioController sharedInstance] recordAudioToDirectory];
        NSLog(@"----------RECORDING STARTED-------------- %@", [[AudioController sharedInstance] recordAudioToDirectory]);
    }
}

//    if (self.containerView.state == ButtonStateLaunch) {
//        [self.containerView setState:ButtonStateNone];
//    }


//    if (self.containerView.state == ButtonStateNone) {
//        [self buttonView:view didTryToShake:sender];
//        NSLog(@"Shake");
//    }
//    if (self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateAmbition) {
//        [self buttonView:view didTryToZoom:sender];
//        NSLog(@"Zoom");
//    }

- (void)buttonView:(ButtonView *)view didTryToShake:(UIButton *)button {
    if (self.containerView.state == ButtonStateNone) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.1];
        [animation setRepeatCount:3];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([self.buttonView.recordButton center].x + 20, [self.buttonView.recordButton center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([self.buttonView.recordButton center].x - 20, [self.buttonView.recordButton center].y)]];
        [[self.buttonView.recordButton layer] addAnimation:animation forKey:@"position"];
        NSLog(@"Shaking");
    }
}

- (void)buttonView:(ButtonView *)view didTryToZoom:(UIButton *)button {
    if (self.containerView.state == ButtonStateFocus || self.containerView.state == ButtonStateCourage || self.containerView.state == ButtonStateImagination || self.containerView.state == ButtonStateFun || self.containerView.state == ButtonStatePresence || self.containerView.state == ButtonStateAmbition) {
        switch (view.longPressGesture.state) {
            case UIGestureRecognizerStateBegan:
            {
                [UIView animateWithDuration:.5f
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.containerView.hidden = YES;
                                     self.buttonView.recordButton.transform = CGAffineTransformScale(self.buttonView.recordButton.transform, 3, 3);
                                     self.buttonView.recordButton.alpha = .7;
                                 } completion:nil];
                break;
            }
            case UIGestureRecognizerStateEnded:
            {
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
                    self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, .7, .7);
                    self.buttonView.recordButton.alpha = 1;

                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.buttonView.recordButton.transform = CGAffineTransformScale(self.buttonView.recordButton.transform, .9, .9);

                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);

                            //self.buttonView.recordingComplete = YES;

                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                self.buttonView.recordCompleteLabel.hidden = NO;
                                [NSTimer scheduledTimerWithTimeInterval:.65
                                                                 target:self
                                                               selector:@selector(hideLabel)
                                                               userInfo:nil
                                                                repeats:NO];

                                self.buttonView.recordButton.transform = CGAffineTransformIdentity;

                            } completion:^(BOOL finished) {
                                self.containerView.hidden = NO;

                                [self.containerView setState:ButtonStateNone];
                                [self noneState:ButtonStateNone];
                                self.buttonView.recordButton.backgroundColor = [UIColor blueColor];
                                NSLog(@"Zoomed");
                            }];
                        }];
                    }];
                }];
                break;
            }
            default:
                break;
        }
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [recorder stop];
    NSLog(@"\n\n\n\n\n\n FinishedRecording %d", flag);
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

- (void)playTap:(id)sender
{
    //    [SimpleAudioPlayer playFile:_recorder.url.description];
    NSError *error = nil;

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&error];
    self.player.volume = 1.0f;
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    [self.player play];
    NSLog(@"duration: %f", self.player.duration);
    //    [self.microphone startFetchingAudio];
    //    if (!self.player) {
    //        [self.microphone stopFetchingAudio];
    //    }
}

#pragma mark - States Typedef

- (void)noneState:(ButtonState)state {
    state = ButtonStateNone;
}

- (void)focusState:(ButtonState)state {
    state = ButtonStateFocus;
    [UIView animateWithDuration:.6 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    }];
}

- (void)courageState:(ButtonState)state {
    state = ButtonStateCourage;
    [UIView animateWithDuration:.6 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor redColor].CGColor;
    }];
}

- (void)ambitionState:(ButtonState)state {
    state = ButtonStateAmbition;
    [UIView animateWithDuration:.6 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
    }];
}
- (void)imaginationState:(ButtonState)state {
    state = ButtonStateImagination;
    [UIView animateWithDuration:.6 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor purpleColor].CGColor;
    }];
}
- (void)funState:(ButtonState)state {
    state = ButtonStateFun;
    [UIView animateWithDuration:.6 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor cyanColor].CGColor;
    }];
}
- (void)presenceState:(ButtonState)state {
    state = ButtonStatePresence;
    [UIView animateWithDuration:.6 animations:^{
        self.buttonView.recordButton.layer.backgroundColor = [UIColor yellowColor].CGColor;
    }];
}

- (void)hideLabel {
    self.buttonView.recordCompleteLabel.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
