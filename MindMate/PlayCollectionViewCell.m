//
//  PlayCollectionViewCell.m
//  MindMate
//
//  Created by Jason Noah Choi on 4/5/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "PlayCollectionViewCell.h"
#import "Recording.h"
#import "RecordingController.h"
#import "PlayCollectionViewDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "AudioController.h"

@implementation PlayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/(2*4), frame.size.height/5, frame.size.width/1.35, frame.size.width/1.35)];
        [self addSubview:self.playButton];
        self.playButton.backgroundColor = [UIColor grayColor];
        self.playButton.layer.cornerRadius = self.playButton.frame.size.width/2;
        self.playButton.layer.shouldRasterize = YES;
        [self.playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //self.index
        //PlayCollectionViewDataSource *dataSource = [[PlayCollectionViewDataSource alloc] init];
        //self.backgroundColor = [UIColor blueColor];
        Recording *recording = [RecordingController sharedInstance].memos[self.index];
        if ([recording.groupID isEqual:@1]) {
            self.backgroundColor = [UIColor blueColor];
        }
        if ([recording.groupID isEqual:@2]) {
            self.backgroundColor = [UIColor greenColor];
        }
        if ([recording.groupID isEqual:@3]) {
            self.backgroundColor = [UIColor redColor];
        }
        if ([recording.groupID isEqual:@4]) {
            self.backgroundColor = [UIColor cyanColor];
        }
        if ([recording.groupID isEqual:@5]) {
            self.backgroundColor = [UIColor orangeColor];
        }
        if ([recording.groupID isEqual:@6]) {
            self.backgroundColor = [UIColor yellowColor];
        }
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, self.frame.size.height - 140, 90, 50)];
        [self addSubview:self.timeLabel];
        self.timeLabel.backgroundColor = [UIColor redColor];

        self.groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, self.frame.size.height - 100, 90, 50)];
        [self addSubview:self.groupNameLabel];
        self.groupNameLabel.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)playButtonPressed:(id)sender {
    self.recording = [RecordingController sharedInstance].memos[self.index];
    NSURL *url = [NSURL URLWithString:self.recording.urlPath];
    //[AudioController sharedInstance].url
    [[AudioController sharedInstance] playAudioWithURLPath:[AudioController sharedInstance].url];
}

@end
