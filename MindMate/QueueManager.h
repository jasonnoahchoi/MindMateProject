//
//  QueueManager.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/31/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Recording;
@class Queue;

@interface QueueManager : NSObject

@property (nonatomic, strong) Queue *queue;

+ (QueueManager *)sharedInstance;
//- (NSArray *)addRecording;
- (NSArray *)queueArray;
- (void)addRecording:(Recording *)recording;

@end
