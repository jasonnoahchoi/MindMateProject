//
//  AudioController.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/30/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

typedef enum : NSUInteger {
    AudioStateNone,
    AudioStateRecording,
    AudioStateStoppedRecording,
    AudioStatePlaying,
    AudioStateStoppedPlaying,
} AudioState;

@interface AudioController : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic) AudioState audioState;

+ (AudioController *)sharedInstance;
- (AVAudioRecorder *)recordAudioToDirectory;
- (AVAudioRecorder *)stopRecording;
- (NSString *)filePath;
- (NSURL *)urlPath;
- (NSDate *)createdAtDate;
- (NSDate *)fetchDate;
- (NSString *)randomIDNumber;
- (NSString *)simpleDateString;
- (NSString *)groupName;

@end
