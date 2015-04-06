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
#import "PlayCollectionViewCell.h"

@interface AudioController ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) Recording *recording;


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

- (AVAudioRecorder *)recordAudioToDirectory {
    NSError *error = nil;
    self.url = [self urlPath];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:[self getRecorderSettings] error:&error];
    self.recorder.delegate = self;
    //self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.m4a"]] settings:[self getRecorderSettings] error:&error];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    //  UInt32 doChangeDefault = 1;
    // AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);

//    self.recorder.delegate = self;
    [self.recorder record];
    return self.recorder;
}

- (AVAudioRecorder *)stopRecording {
    [self.recorder stop];
    // [self audioRecorderDidFinishRecording:self.recorder successfully:YES];
    //self.buttonView.playButton.enabled = YES;
    //[self.recordingTimer invalidate];
    // self.recordingTimer = nil;
    NSLog(@"\n\nURL:%@", self.url);
    // [self.microphone stopFetchingAudio];

    NSData *data = [NSData dataWithContentsOfURL:self.url];
    [data writeToFile:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@", [[AudioController sharedInstance] filePath]]] atomically:YES];
    //[data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self filePath]]] atomically:YES];
    //NSLog(@"\n\n\nData File: %@", data);
    // [[RecordingController sharedInstance] addRecordingWithFile:data];
    [[RecordingController sharedInstance] addRecordingWithURL:[[AudioController sharedInstance] filePath]
                                                  andIDNumber:[[AudioController sharedInstance] randomIDNumber]
                                               andDateCreated:[[AudioController sharedInstance] createdAtDate]
                                                 andFetchDate:[[AudioController sharedInstance] fetchDate]
                                                andSimpleDate:[[AudioController sharedInstance] simpleDateString]
                                                 andGroupName:[[AudioController sharedInstance] groupName] andData:[[AudioController sharedInstance] data]];
    //[RecordingController sharedInstance] addGroupWithName:

    //NSLog(@"\n \nControllerRecordingPath: %@", [[AudioController sharedInstance] filePath]);
    [[RecordingController sharedInstance] save];
    NSLog(@"\n\n Date Created: %@, Fetch Date: %@, IDNUMBER: %@", [[AudioController sharedInstance] createdAtDate], [[AudioController sharedInstance] fetchDate], [[AudioController sharedInstance] randomIDNumber]);
    return self.recorder;
}

//- (AVAudioPlayer *)playAudio {
//
//    NSError *error = nil;
//    //self.recording = [RecordingController sharedInstance].memos.lastObject;
//
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&error];
//    //self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.recording.urlPath] error:&error];
//    self.player.delegate = self;
//    self.player.volume = 1.0;
//    self.player.numberOfLoops = 0;
//    [self.player play];
//    return self.player;
//}

- (AVAudioPlayer *)playAudioWithURLPath:(NSData *)data {
    NSError *error = nil;
    //NSURL *urlPath = [NSURL URLWithString:[[AudioController sharedInstance] filePath]];
   // url = urlPath;
    //PlayCollectionViewCell *cell = [[PlayCollectionViewCell alloc] init];

    //NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:cell.index];
    //Recording *recording = [RecordingController sharedInstance].memos[indexPath.item];
    //url = [NSURL URLWithString:recording.urlPath];
    //self.recording = [RecordingController sharedInstance].memos.lastObject;
   // self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    // self.player = [[AVAudioPlayer alloc] initWithURL:url];
    //self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url fileTypeHint:@".m4a" error:&error];
   self.player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:@".m4a" error:&error];
    self.player.delegate = self;
    self.player.volume = 1.0;
    self.player.numberOfLoops = 0;
    [self.player play];

    return self.player;
}

- (NSData *)data {
    NSData *data = [NSData dataWithContentsOfURL:self.url];
    NSString *string = [NSString stringWithFormat:@"%@", [[AudioController sharedInstance] filePath]];
    [data writeToFile:[NSHomeDirectory() stringByAppendingString:string] atomically:YES];
    NSLog(@"\n\n\n DATA: %@", data);

    NSLog(@"\n\n\n STRING: %@", string);
    return data;
}


- (NSURL *)urlPath {
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMdyyyy+HHMMss"];

    NSString *nowString = [formatter stringFromDate:now];

    NSString *destinationString = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", nowString]];

//     NSString *findString = destinationString;
//      findString = [self filePath];
//    NSLog(@"Self filePath: %@", [self filePath]);


   // NSURL *destinationURL = [NSURL fileURLWithPath:destinationString];
    NSURL *destinationURL = [NSURL URLWithString:destinationString];
 //   NSLog(@"\n\n\n !!!!!DESTINATION URL: %@", destinationURL);
    return destinationURL;
}

- (NSString *)filePath {

  //  NSLog(@"\n\n\nSTRING: %@", string);
    return [self.url absoluteString];
}

- (NSString *)documentsPath {
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    //NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    // NSArray *searchPaths = [fileMgr     //
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [searchPaths objectAtIndex:0];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"Create directory error: %@", error);
        }
    }

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

- (NSDate *)createdAtDate {
    NSDate *now = [NSDate date];
    return now;
}

- (NSString *)simpleDateString {
    NSDate *now = [self createdAtDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowString = [formatter stringFromDate:now];
    return nowString;
}

- (NSDate *)fetchDate {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    //NSUInteger count = [[RecordingController sharedInstance].memos count];
    NSUInteger count = 1;
    dayComponent.day = count;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[self createdAtDate] options:0];

    return nextDate;
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
