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

static NSString * const kAudioFileFinished = @"AudioFileFinished";
static NSString *const kLabelDidChange = @"LabelDidChange";

@interface AudioController : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic) AudioState audioState;
@property (nonatomic, strong) NSArray *audioFileQueue;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) AVAudioPlayer *babyPopPlayer;
@property (nonatomic, strong) AVAudioPlayer *babyPopAgainPlayer;
@property (nonatomic, strong) AVAudioPlayer *menuSoundPlayer;
@property (nonatomic, strong) AVAudioPlayer *welcomePlayer;
@property (nonatomic, strong) AVAudioPlayer *babyPopTwoPlayer;
@property (nonatomic, strong) AVAudioPlayer *babyPopAgainTwoPlayer;

+ (AudioController *)sharedInstance;
- (instancetype)init;
//+ (AVQueuePlayer *)queuePlayerWithItems:(NSArray *)items;
- (AVAudioRecorder *)recordAudioToDirectory;
- (AVAudioPlayer *)playAudioWithURLPath:(NSURL *)url;
- (AVAudioPlayer *)stopPlayingAudio;
- (AVAudioRecorder *)stopRecording;
- (NSArray *)documentsPath;
- (NSString *)randomIDNumber;
- (NSString *)simpleDateString;
- (NSString *)currentTime;
- (NSString *)groupName;
- (NSData *)data;
- (void)playAudioFileAtURL:(NSURL *)url;
- (void)playAudioFileSoftlyAtURL:(NSURL *)url;
//- (AVQueuePlayer *)playQueueAudio:(NSArray *)items;
- (void)playAudioWithInt:(int)i;

@end
