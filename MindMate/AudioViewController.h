//
//  ViewController.h
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

