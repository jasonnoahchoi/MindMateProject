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

@interface AudioController ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

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
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[self urlPath] settings:[self getRecorderSettings] error:&error];
    //self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.m4a"]] settings:[self getRecorderSettings] error:&error];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //  UInt32 doChangeDefault = 1;
    // AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);

//    self.recorder.delegate = self;
    [self.recorder record];
    return self.recorder;
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


    NSURL *destinationURL = [NSURL fileURLWithPath:destinationString];
 //   NSLog(@"\n\n\n !!!!!DESTINATION URL: %@", destinationURL);
    return destinationURL;
}

- (NSString *)filePath {
    NSString *string = [[self urlPath] absoluteString];
  //  NSLog(@"\n\n\nSTRING: %@", string);
    return string;
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



@end
