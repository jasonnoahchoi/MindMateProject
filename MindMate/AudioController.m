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
@property (nonatomic, strong) AVQueuePlayer *queuePlayer;



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
    [self data];

//    NSData *data = [NSData dataWithContentsOfURL:self.url];
//    [data writeToFile:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@", [[AudioController sharedInstance] filePath]]] atomically:YES];
    //[data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self filePath]]] atomically:YES];
    //NSLog(@"\n\n\nData File: %@", data);
    // [[RecordingController sharedInstance] addRecordingWithFile:data];
    [[RecordingController sharedInstance] addRecordingWithURL:[[self fileURL] absoluteString]
                                                  andIDNumber:[self randomIDNumber]
                                               andDateCreated:[self createdAtDateString]
                                                 andFetchDate:[self fetchDate]
                                                andSimpleDate:[self simpleDateString]
                                                 andGroupName:[self groupName]
                                               andTimeCreated:[self currentTime]
                                                      andData:[self data]];
    //[RecordingController sharedInstance] addGroupWithName:
    NSLog(@"\n\n CURRENT TIME: %@ \n\n\n SIMPLE DATE: %@ \n\n\n DATE CREATED: %@ \n\n\n RECORDINGURL: %@", [self currentTime], [self simpleDateString], [self createdAtDateString], [[self fileURL] absoluteString]);

    //NSLog(@"\n \nControllerRecordingPath: %@", [[AudioController sharedInstance] filePath]);
    [[RecordingController sharedInstance] save];
//    NSLog(@"\n\n Date Created: %@, Fetch Date: %@, IDNUMBER: %@", [[AudioController sharedInstance] createdAtDate], [[AudioController sharedInstance] fetchDate], [[AudioController sharedInstance] randomIDNumber]);
    return self.recorder;
}


////- (AVAudioPlayer *)playAudio {
////
////    NSError *error = nil;
////    //self.recording = [RecordingController sharedInstance].memos.lastObject;
////
////    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&error];
////    //self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.recording.urlPath] error:&error];
////    self.player.delegate = self;
////    self.player.volume = 1.0;
////    self.player.numberOfLoops = 0;
////    [self.player play];
////    return self.player;
////}
//
//- (AVQueuePlayer *)playQueueAudio:(NSArray *)items {
//
//    self.queuePlayer = [[AVQueuePlayer alloc] initWithItems:items];
//
//
////
////    if (!self.player) {
////        NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
////    } else {
////        [self.player play];
////    }
//
//    return self.queuePlayer;
//}
//
//
//+ (AVQueuePlayer *)queuePlayerWithItems:(NSArray *)items {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:items.lastObject];
//    return [AVQueuePlayer queuePlayerWithItems:items];
//}
//
//
//- (void)playerItemDidReachEnd:(NSNotification *)notification {
//    NSLog(@"It reached the end");
//}
//
//
//
//- (AVAudioPlayer *)playAudioWithURLPath:(NSURL *)url {
//    NSError *error;
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    self.player.delegate = self;
//    self.player.volume = 1.0;
//
//    
//    if (!self.player) {
//        NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
//    } else {
//        [self.player play];
//    }
//    return self.player;
//}
//
//- (AVAudioPlayer *)playAudioWithData:(NSData *)data {
//    NSError *error = nil;
//
//    self.player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:@".m4a" error:&error];
//    self.player.delegate = self;
//    self.player.volume = 1.0;
//    self.player.numberOfLoops = 0;
//
//    if (!self.player) {
//        NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
//    } else {
//        [self.player play];
//    }
//
//    return self.player;
//}

- (AVAudioPlayer *)stopPlayingAudio {
    [self.player stop];
    self.player.delegate = self;
    return self.player;
}

//- (id)initWithFileNameQueue:(NSArray *)queue {
//    if ((self = [super init])) {
//        self.audioFileQueue = queue;
//        self.index = 0;
//        [self playAudioWithInt:self.index];
//    }
//    return self;
//}
//


- (void)playAudioWithInt:(int)i {
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithData:self.audioFileQueue[i] error:&error];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelDidChangePerSong:) name:kLabelDidChange object:nil];

    self.index--;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.index <= self.audioFileQueue.count) {
        [self playAudioWithInt:self.index];
       // [[NSNotificationCenter defaultCenter] postNotificationName:kAudioFileFinished object:self];

        
    } else {
      //  [[RecordingController sharedInstance] removeRecording:self.recording];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAudioFileFinished object:self];
    NSLog(@"did finish playing %d", flag);

    }
}

//- (void)playerItemDidReachEnd:(NSNotification *)notification {
//    [[RecordingController sharedInstance] removeRecording:self.recording];
//}


- (NSData *)data {
    NSData *dataFile = [NSData dataWithContentsOfURL:self.url];
//    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@%@.m4a", docDirPath, [[AudioController sharedInstance] filePath]];
    [self documentsPath];
    [self filePathFromDocDir];

    [dataFile writeToFile:[self filePathFromDocDir] atomically:YES];
    NSLog(@"\n\n\nDOC DIR PATH: %@", [self documentsPath]);
    //[dataFile writeToFile:[NSHomeDirectory() stringByAppendingString:string] atomically:YES];
    NSLog(@"\n\n\n DATA: %@", dataFile);

    NSLog(@"\n\n\n STRING: %@", [self filePathFromDocDir]);
    return dataFile;
}

- (NSURL *)fileURL {
    return [NSURL fileURLWithPath:[self filePathFromDocDir]];
}

//- (NSString *)docDirPath {
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//}

- (NSString *)filePathFromDocDir {
    return [NSString stringWithFormat:@"%@", [self nowString]];
}

- (NSString *)nowString {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMdyyyy+HHMMss"];

    NSString *nowString = [formatter stringFromDate:now];

    NSString *destinationString = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", nowString]];

    return destinationString;
}


- (NSURL *)urlPath {


//     NSString *findString = destinationString;
//      findString = [self filePath];
//    NSLog(@"Self filePath: %@", [self filePath]);

    NSURL *destinationURL = [NSURL fileURLWithPath:[self nowString]];
    //NSURL *destinationURL = [NSURL URLWithString:destinationString];
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
            NSLog(@"Create directory error: %@", [error description]);
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

- (NSString *)createdAtDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    NSString *nowString = [formatter stringFromDate:[self createdAtDate]];
    return nowString;
}

- (NSString *)currentTime {
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"hh:mm aaa Z"];
    return [myDateFormatter stringFromDate:[NSDate date]];
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
