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

+ (AudioController *)sharedInstance;
//+ (AVQueuePlayer *)queuePlayerWithItems:(NSArray *)items;
- (AVAudioRecorder *)recordAudioToDirectory;
- (AVAudioPlayer *)playAudioWithURLPath:(NSURL *)url;
- (AVAudioPlayer *)playAudioWithData:(NSData *)data;
- (AVAudioPlayer *)stopPlayingAudio;
- (AVAudioRecorder *)stopRecording;
- (NSArray *)documentsPath;
- (NSString *)filePath;
- (NSURL *)urlPath;
- (NSDate *)createdAtDate;
- (NSDate *)fetchDate;
- (NSString *)randomIDNumber;
- (NSString *)simpleDateString;
- (NSString *)groupName;
- (AVAudioPlayer *)playAudio;
- (NSData *)data;
- (void)playAudioFileAtURL:(NSURL *)url;
- (void)playAudioFileSoftlyAtURL:(NSURL *)url;
//- (AVQueuePlayer *)playQueueAudio:(NSArray *)items;
//
//- (id)initWithFileNameQueue:(NSArray *)queue;
- (void)playAudioWithInt:(int)i;

@end
