////
////  AudioRecorderViewController.h
////  AudioWithWave
////
////  Created by Jason Noah Choi on 3/28/15.
////  Copyright (c) 2015 Jason Choi. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
//// Import EZAudio header
////#import "EZAudio.h"
//
//@class AudioRecorderViewController;
//
//typedef void(^AudioNoteRecorderFinishBlock)(BOOL wasRecordingTaken, NSURL *recordingURL);
//
//
//@protocol AudioNoteRecorderDelegate <NSObject>
//
//- (void)audioNoteRecorderDidCancel:(AudioRecorderViewController *)audioNoteRecorder;
//- (void)audioNoteRecorderDidTapDone:(AudioRecorderViewController *)audioNoteRecorder withRecordedURL:(NSURL *)recordedURL;
//
//@end
//
//
//@interface AudioRecorderViewController : UIViewController <EZMicrophoneDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
//
//#pragma mark - Components
///**
// The OpenGL based audio plot
// */
//@property (nonatomic, strong) EZAudioPlotGL *audioPlot;
///**
// The microphone component
// */
//@property (nonatomic,strong) EZMicrophone *microphone;
//
//@property (nonatomic, weak) id<AudioNoteRecorderDelegate> delegate;
//
//@property (nonatomic, copy) AudioNoteRecorderFinishBlock finishedBlock;
//
////- (id) initWithMasterViewController:(UIViewController *) masterViewController;
//
//+ (instancetype)showRecorderWithMasterViewController:(UIViewController *)masterViewController withDelegate:(id<AudioNoteRecorderDelegate>)delegate;
//+ (instancetype)showRecorderMasterViewController:(UIViewController *)masterViewController withFinishedBlock:(AudioNoteRecorderFinishBlock)finishedBlock;
//
//
//@end
