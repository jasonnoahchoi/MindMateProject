//
//  AudioController.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/30/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface AudioController : NSObject

+ (AudioController *)sharedInstance;
- (AVAudioRecorder *)recordAudioToDirectory;
- (NSString *)filePath;
- (NSURL *)urlPath;
- (NSDate *)createdAtDate;
- (NSDate *)fetchDate;
- (NSString *)randomIDNumber;

@end
