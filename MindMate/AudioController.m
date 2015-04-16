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
//        self.welcomeURL = [[NSBundle mainBundle] URLForResource:@"welcome" withExtension:@"m4a"];
//        self.welcomePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.welcomeURL fileTypeHint:@"m4a" error:nil];
//        [self welcomeSetup];

        self.babyPopPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopURL fileTypeHint:@"caf" error:nil];
        [self babyPopPlayerSetup];

        self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopAgainURL fileTypeHint:@"caf" error:nil];
        [self babyPopAgainPlayerSetup];

        self.menuSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.menuSoundURL fileTypeHint:@"caf" error:nil];
        [self menuSoundSetup];
        self.babyPopTwoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopURL error:nil];
        self.babyPopAgainTwoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.babyPopAgainURL error:nil];
    }
    return self;
}

- (void)babyPopPlayerSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }

    // self.babyPopPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.popURL fileTypeHint:@"caf" error:&catError];

    [self.babyPopPlayer prepareToPlay];
    //    [self.babyPopPlayer play];
}

- (void)babyPopAgainPlayerSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }

    // self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.popURLAgain fileTypeHint:@"caf" error:&catError];

    [self.babyPopAgainPlayer prepareToPlay];
}

- (void)menuSoundSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }

    // self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.popURLAgain fileTypeHint:@"caf" error:&catError];

    [self.menuSoundPlayer prepareToPlay];

}

//- (void)welcomeSetup {
//    NSError *catError = nil;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
//    if (catError) {
//        NSLog(@"%@", [catError description]);
//    }
//
//    // self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.popURLAgain fileTypeHint:@"caf" error:&catError];
//
//    [self.welcomePlayer prepareToPlay];
//}

- (void)babyPopTwoSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }

    // self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.popURLAgain fileTypeHint:@"caf" error:&catError];

    [self.babyPopTwoPlayer prepareToPlay];
}
- (void)babyPopAgainSetup {
    NSError *catError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
    if (catError) {
        NSLog(@"%@", [catError description]);
    }

    // self.babyPopAgainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.popURLAgain fileTypeHint:@"caf" error:&catError];

    [self.babyPopAgainTwoPlayer prepareToPlay];
}


- (AVAudioRecorder *)recordAudioToDirectory {
    NSError *error = nil;
    self.url = [NSURL fileURLWithPathComponents:[self documentsPath]];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:[self getRecorderSettings] error:&error];
    [self.recorder prepareToRecord];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;

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
 //   NSLog(@"\n\nURL:%@", self.url);
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self data];
    //     });

        [[RecordingController sharedInstance] addRecordingWithURL:[self nowString]
                                                      andIDNumber:[self randomIDNumber]
                                                   andDateCreated:[self createdAtDateString]
                                                     andFetchDate:[NSDate createdAtDate]
                                                    andSimpleDate:[self simpleDateString]
                                                     andGroupName:[self groupName]
                                                   andTimeCreated:[self currentTime]];
    //    NSLog(@"TIMESTAMP: %@, \n\n\nFETCH DATE: %@ \n\n\n\n NOTIFICATION TIME%@ \n\n\n\nMIDNIGHT TIME: %@, \n\n\nSIX AM TIME: %@ \n\n\nFETCHDATEFORRECORDING%@ \n\n\nBEGINNING OFDAY: %@,\n\n\n\nEND OF DAY: %@", [self currentTime], [NSDate fetchDate], [NSDate notificationTime], [NSDate midnightTime], [NSDate sixAMTime], [NSDate fetchDateForRecording], [NSDate beginningOfDay], [NSDate endOfDay]);


            [[RecordingController sharedInstance] save];

    //  NSLog(@"\n\n CURRENT TIME: %@ \n\n\n SIMPLE DATE: %@ \n\n\n DATE CREATED: %@ \n\n\n RECORDINGURLFILENAME: %@", [self currentTime], [self simpleDateString], [self createdAtDateString], [self nowString]);

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

        self.player.volume = .5;
        //[self.player play];
        if (!self.player) {
            NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
        } else {
            [self.player play];
        }
    });
}

- (void)playAudioFileAtURL:(NSURL *)url {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError *error = nil;
        NSError *catError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&catError];
        if (catError) {
            NSLog(@"%@", [catError description]);
        }
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //self.player.numberOfLoops = 0;
        [self.player prepareToPlay];
        self.player.volume = 1.0;
        //[self.player play];
        if (!self.player) {
            NSLog(@"!!!! AudioPlayer Did Not Load Properly: %@", [error description]);
        } else {
            [self.player play];
        }

//    });
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

- (void)playAudioWithInt:(int)i {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSError *error = nil;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
   // [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    //self.player = [[AVAudioPlayer alloc] initWithData:self.audioFileQueue[i] error:&error];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelDidChangePerSong:) name:kLabelDidChange object:nil];

    self.index--;
//        });
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

   // [self documentsPath];

    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                          NSUserDomainMask, YES) objectAtIndex:0]
     stringByAppendingPathComponent:[self nowString]];

    [dataFile writeToFile:string atomically:YES];
   // NSLog(@"\n\n\nDOC DIR PATH: %@", [self documentsPath]);
   // NSLog(@"\n\n\n URL PATH %@", [self urlPath]);
  //  NSLog(@"\n\n\n URL PATH ABSOLUTE STRING: %@", string);

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
 //   NSLog(@"CREATEDATDATESTRING: %@", nowString);
    return nowString;
}

- (NSString *)currentTime {
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    myDateFormatter.timeZone = [NSTimeZone localTimeZone];
    [myDateFormatter setDateFormat:@"hh:mm aaa"];
    return [myDateFormatter stringFromDate:[NSDate createdAtDate]];
}


//- (NSDate *)fetchDate {
//    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//    //NSUInteger count = [[RecordingController sharedInstance].memos count];
//    NSUInteger count = 1;
//    dayComponent.day = count;
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[self createdAtDate] options:0];
//
//    return nextDate;
//}

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

@end
