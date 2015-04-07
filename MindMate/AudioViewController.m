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
#import "PlayCollectionViewController.h"
#import "TimeAndDateView.h"

@interface AudioViewController () <CategoryContainerViewDelegate, ButtonViewDelegate>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) CategoryContainerView *containerView;
@property (nonatomic, strong) PlayCollectionViewController *playVC;
@property (nonatomic, strong) TimeAndDateView *tdView;
@property (nonatomic, strong) Recording *record;

@property (nonatomic, strong) NSMutableArray *mutableRecordings;
@property (nonatomic, strong) UILabel *timeLabel;

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
    self.playVC = [[PlayCollectionViewController alloc] init];
    CGSize size = self.view.superview.frame.size;
    [self.view setCenter:CGPointMake(size.width/2, size.height/2)];

    CGRect circle = CGRectMake(self.view.frame.size.width/(2*4), self.view.frame.size.height/5, self.view.frame.size.width/1.35, self.view.frame.size.width/1.35);
    self.buttonView = [[ButtonView alloc] initWithFrame:circle];
    [UIView animateWithDuration:.3 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonView.recordButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.buttonView.recordButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    //self.buttonView.center = self.view.center;
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];
//    self.buttonView.hidden = YES;
    //self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 70, self.view.frame.size.width/2-10, 50)];
    //[self.view addSubview:self.timeLabel];
//    self.timeLabel.text = @"Time";
//    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.tdView = [[TimeAndDateView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 30, self.view.frame.size.width/2-10, 100)];
    //self.tdView.timeLabel.text = @"TIMEISOFTHEESSECNCE";
    //self.tdView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tdView];

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
    self.recordAgainButton.backgroundColor = [UIColor customGreenColor];
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

- (void)layoutCornerEndPoints {
    CGRect endPointRecordCornerButton = CGRectMake(0 - self.view.frame.size.width/6, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointRecordCornerButton = CGPointMake(endPointRecordCornerButton.origin.x + (endPointRecordCornerButton.size.width/2), endPointRecordCornerButton.origin.y + (endPointRecordCornerButton.size.height/2));

    CGRect endPointPlayCornerButton = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/3, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width/2, self.view.frame.size.width/2);
    self.endPointPlayCornerButton = CGPointMake(endPointPlayCornerButton.origin.x + (endPointPlayCornerButton.size.width/2), endPointPlayCornerButton.origin.y + (endPointPlayCornerButton.size.height/2));
}

- (void)cornerButtons {
    [self layoutCornerEndPoints];

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
    [self addPlayButtonAnimation];
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
    self.confirmButton.alpha = 0;
    self.containerView.alpha = 0;
    if (self.containerView.state != ButtonStateZero || self.containerView.state != ButtonStateNone) {
        [[RecordingController sharedInstance] addGroupID:self.groupIDNumber];
        [[RecordingController sharedInstance] save];

        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
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

//        switch (sender.state) {
//            case UIGestureRecognizerStateBegan:
//            {
//                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    button.backgroundColor = [UIColor customGreenColor];
//                    button.transform = CGAffineTransformScale(button.transform, 0.6, 0.6);
//                } completion:^(BOOL finished) {
//                    [[AudioController sharedInstance] playAudio];
//                }];
//            }
//                break;
//            case UIGestureRecognizerStateEnded:
//                {
//                    //button.transform = CGAffineTransformIdentity;
//                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
//                } completion:^(BOOL finished) {
//                    [[[AudioController sharedInstance] playAudio] stop];
//                    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
//                    } completion:^(BOOL finished) {
//                        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                            button.transform = CGAffineTransformIdentity;
//                            button.backgroundColor = [UIColor customPurpleColor];
//                        } completion:nil];
//                    }];
//                }];
//                }
//                break;
//                
//            default:
//                break;
//        }
    }
}

//- (void)playerItemDidReachEnd:(NSNotification *)notification {
//    NSLog(@"Notification received");
//    Recording *recording = [RecordingController sharedInstance].memos.lastObject;
//    [[RecordingController sharedInstance] removeRecording:recording];
//}

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


//    }
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didTryToPlayWithPlayButton:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.tdView.hidden = NO;
            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3.5, 3.5);
            } completion:^(BOOL finished) {
                NSArray *array = [RecordingController sharedInstance].memos;
                NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
                self.mutableRecordings = [[NSMutableArray alloc] init];
                //Recording *recording = [RecordingController sharedInstance].memos.firstObject;
                for (int i = 0; i < [array count]; i++) {
                    Recording *recording = [RecordingController sharedInstance].memos[i];
                    [self.mutableRecordings addObject:recording.timeCreated];
                    self.tdView.timeLabel.text = recording.timeCreated;
                    self.tdView.dateLabel.text = recording.simpleDate;

                    //AVAsset *asset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:recording.simpleDate]];
                    //AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
                    //[mutableArray addObject:item];
                    [mutableArray addObject:recording.memo];

                    self.record = recording;
////                    for (int i = 0; i < [mutableArray count]; i++) {
//                        [[AudioController sharedInstance] playAudioWithData:recording.memo];
//                    }

                                        //self.tdView.timeLabel.text = recording.timeCreated;
                        //self.tdView.dateLabel.text = recording.simpleDate;
                       //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:kAudioFileFinished object:self];

                    }
                 self.indexForRecording = self.mutableRecordings.count - 2;
                [AudioController sharedInstance].audioFileQueue = mutableArray;
                for (int i = 0; i < [AudioController sharedInstance].audioFileQueue.count; i++) {
                    [AudioController sharedInstance].index = i;

                    [[AudioController sharedInstance] playAudioWithInt:i];
                }

                                   //[[AudioController sharedInstance] stopPlayingAudio];


                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelDidChange:) name:kLabelDidChange object:nil];


//                Looper *looper = [[Looper alloc] initWithFileNameQueue:mutableArray];

//              [[AudioController sharedInstance] initWithFileNameQueue:mutableArray];
                //AVQueuePlayer *playing = [[AVQueuePlayer alloc] init];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[AudioController sharedInstance] playQueueAudio:mutableArray];
//                });

//                    NSData *data = recording.memo;
//                    [[AudioController sharedInstance] playAudioWithData:data];
               // [[AudioController sharedInstance] playQueueAudio:mutableArray];

//                [[NSNotificationCenter defaultCenter] postNotificationName:kAudioFileFinished object:self userInfo:nil];

                 
                //AVQueuePlayer *play = [[AVQueuePlayer alloc] initWithItems:mutableArray];

                               //NSData *data = recording.memo;


            }];
        }
            break;

        case UIGestureRecognizerStateEnded:
        {
            [[AudioController sharedInstance] stopPlayingAudio];


            //[[RecordingController sharedInstance] removeRecording:self.mutableRecordings.lastObject];
            for (int i = 0; i < self.mutableRecordings.count ; i++) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kAudioFileFinished object:self userInfo:nil];
            }

            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, .8, .8);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);

                        } completion:nil];
                    }];
                }];
            }];

//            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.playVC];
//
//            [self.navigationController presentViewController:navigation animated:NO completion:^{

        }
            break;
        default:
            break;
    }
}


- (void)didTryToZoom:(UIButton *)button withGesture:(UIGestureRecognizer *)sender {
    self.tdView.hidden = YES;
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
                                [self stopRecording];
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
                                [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    self.containerView.alpha = 1;
                                    [self.containerView animateLayoutButtons];

                                    self.recordAgainButton.alpha = 1;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.4 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
        self.buttonView.recordButton.layer.backgroundColor = [UIColor customPurpleColor].CGColor;
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
