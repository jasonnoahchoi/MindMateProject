//
//  AudioController.m
//  MindMate
//
//  Created by Jason Noah Choi on 3/30/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "AudioController.h"
#import "RecordingController.h"
#import "Recording.h"
#import "NSDate+Utils.h"

@interface AudioController ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) Recording *recording;
@property (nonatomic, strong) AVQueuePlayer *queuePlayer;
@property (nonatomic, strong) NSURL *babyPopURL;
@property (nonatomic, strong) NSURL *babyPopAgainURL;
@property (nonatomic, strong) NSURL *menuSoundURL;
@property (nonatomic, strong) NSURL *welcomeURL;

@end

@implementation AudioController

+ (AudioController *)sharedInstance {
    static AudioController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioController alloc] init];
        
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.babyPopURL = [[NSBundle mainBundle] URLForResource:@"babypop" withExtension:@"caf"];
        self.babyPopAgainURL = [[NSBundle mainBundle] URLForResource:@"babypopagain" withExtension:@"caf"];
        self.menuSoundURL = [[NSBundle mainBundle] URLForResource:@"menu" withExtension:@"caf"];

        self.babyPopPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopURL fileTypeHint:@"caf" error:nil];
        [self babyPopPlayerSetup];

        self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopAgainURL fileTypeHint:@"caf" error:nil];
        [self babyPopAgainPlayerSetup];

        self.menuSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.menuSoundURL fileTypeHint:@"caf" error:nil];
        [self menuSoundSetup];
        self.babyPopTwoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopURL fileTypeHint:@"caf" error:nil];
        [self babyPopTwoSetup];
        self.babyPopAgainTwoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopAgainURL fileTypeHint:@"caf" error:nil];
        [self babyPopTwoSetup];
    }
    return self;
}

- (void)babyPopPlayerSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }
     [[AVAudioSession sharedInstance] setActive:YES error:&catError];
    [self.babyPopPlayer prepareToPlay];
}

- (void)babyPopAgainPlayerSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }
    [[AVAudioSession sharedInstance] setActive:YES error:&catError];

    [self.babyPopAgainPlayer prepareToPlay];
}

- (void)menuSoundSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }
    [[AVAudioSession sharedInstance] setActive:YES error:&catError];

    [self.menuSoundPlayer prepareToPlay];

}

- (void)babyPopTwoSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }
    [[AVAudioSession sharedInstance] setActive:YES error:&catError];

    [self.babyPopTwoPlayer prepareToPlay];
}
- (void)babyPopAgainSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }
    [[AVAudioSession sharedInstance] setActive:YES error:&catError];

    [self.babyPopAgainTwoPlayer prepareToPlay];
}


- (AVAudioRecorder *)recordAudioToDirectory {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        self.url = [NSURL fileURLWithPathComponents:[self documentsPath]];
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:[self getRecorderSettings] error:&error];
        [self.recorder prepareToRecord];
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];

        [self.recorder record];
    });

    return self.recorder;
}

- (AVAudioRecorder *)stopRecording {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.recorder stop];

        [self data];

        [[RecordingController sharedInstance] addRecordingWithURL:[self nowString]
                                                      andIDNumber:[self randomIDNumber]
                                                   andDateCreated:[self createdAtDateString]
                                                     andFetchDate:[NSDate createdAtDate]
                                                    andSimpleDate:[self simpleDateString]
                                                     andGroupName:[self groupName]
                                                   andTimeCreated:[self currentTime]];

        [[RecordingController sharedInstance] save];

    });
    return self.recorder;
}

- (void)playAudioFileSoftlyAtURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSError *catError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
        if (catError) {
            NSLog(@"%@", [catError description]);
        }

        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        self.player.numberOfLoops = 0;
        [self.player prepareToPlay];

        self.player.volume = 1.0;
        if (!self.player) {
            NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
        } else {
            [self.player play];
        }
    });
}

- (void)playAudioFileAtURL:(NSURL *)url {
    NSError *error = nil;
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    [self.player prepareToPlay];
    self.player.volume = 1.0;
    if (!self.player) {
        NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
    } else {
        [self.player play];
    }
}

- (AVAudioPlayer *)playAudioWithURLPath:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        [self data];
        NSError *catError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
        if (catError) {
            NSLog(@"%@", [catError description]);
        }
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player.delegate = self;
        self.player.volume = 1.0;

        if (!self.player) {
            NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
        } else {
            [self.player play];
        }
    });
    return self.player;
}

- (AVAudioPlayer *)stopPlayingAudio {
    [self.player stop];
    self.player.delegate = self;
    return self.player;
}

- (void)playAudioWithInt:(int)i {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioFileQueue[i] error:&error];
    self.player.delegate = self;
    self.player.volume = 1.0;
    self.player.numberOfLoops = 0;

    [self.player prepareToPlay];

    if (!self.player) {
        NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLabelDidChange object:nil];
        [self.player play];
    }

    self.index--;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.index <= self.audioFileQueue.count) {
        [self playAudioWithInt:self.index];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAudioFileFinished object:nil];
    NSLog(@"did finish playing %d", flag);

    }
}

- (NSData *)data {
    NSData *dataFile = [NSData dataWithContentsOfURL:self.url];

    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                          NSUserDomainMask, YES) objectAtIndex:0]
     stringByAppendingPathComponent:[self nowString]];

    [dataFile writeToFile:string atomically:YES];

    return dataFile;
}

- (NSString *)nowString {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMdyyyy+HHMMss"];

    NSString *nowString = [formatter stringFromDate:now];

    NSString *destinationString = [NSString stringWithFormat:@"%@.aac", nowString];

    return destinationString;
}

- (NSArray *)documentsPath {
     NSArray *documentsPath = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [self nowString], nil];

    return documentsPath;
}


-(NSDictionary *)getRecorderSettings {
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    [recordSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    return recordSettings;
}

- (NSString *)simpleDateString {
    NSDate *now = [NSDate createdAtDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowString = [formatter stringFromDate:now];
    return nowString;
}

- (NSString *)createdAtDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    NSString *nowString = [formatter stringFromDate:[NSDate createdAtDate]];

    return nowString;
}

- (NSString *)currentTime {
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    myDateFormatter.timeZone = [NSTimeZone localTimeZone];
    [myDateFormatter setDateFormat:@"hh:mm aaa"];

    return [myDateFormatter stringFromDate:[NSDate createdAtDate]];
}


- (NSString *)randomIDNumber {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

- (NSString *)groupName {
    NSString *string = @"Test";
    return string;
}

- (void)setState:(AudioState)state {
    if (_audioState == state) {
        return;
    }
    _audioState = state;

    switch (state) {
        case AudioStateNone:
            break;
        case AudioStateRecording:
            break;
        case AudioStateStoppedRecording:
            break;
        case AudioStatePlaying:
        case AudioStateStoppedPlaying:
            break;
        default:
            break;
    }
}

@end
