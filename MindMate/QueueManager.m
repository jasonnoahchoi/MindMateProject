//
//  QueueManager.m
//  MindMate
//
//  Created by Jason Noah Choi on 3/31/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//
//
//#import "QueueManager.h"
//#import "Queue.h"
//#import "Recording.h"
//#import "RecordingController.h"
//#import "Stack.h"
//
//@interface QueueManager ()
//
//
//
//@end
//
//@implementation QueueManager
//+ (QueueManager *)sharedInstance {
//    static QueueManager *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[QueueManager alloc] init];
//     //   sharedInstance.queue =
//    });
//    
//    return sharedInstance;
//}
//
////- (NSArray *)queueArray {
////    NSMutableArray *array = [[NSMutableArray alloc] init];
////    return array;
////}
////
////- (Queue *)addToQueue:(Recording *)recording {
////
////    Queue *queue = [[self addRecording:recording] firstObject];
////    return queue;
////}
//
////- (NSArray *)addRecording {
////    [self addRecording:recordingEntity];
////}
//
//- (void)removeRecording:(Recording *)recording {
//    NSOrderedSet *set = self.queue.recordings;
//    NSMutableOrderedSet *mutableSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:set];
//    if (recording.returned) {
//        [mutableSet removeObject:recording];
//    } else {
//        return;
//    }
//}
//
////- (NSArray *)queueArray {
////    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[RecordingController sharedInstance].memos];
////    return array;
////}
//
////- (Queue *)queue {
////    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:queueEntity];
////    NSArray *array = [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest
////                                                                                error:nil];
////
////    if ([array firstObject]) {
////        return [array firstObject];
////    } else {
////       // Queue *queue = [NSEntityDescription insertNewObjectForEntityForName:queueEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
////        [[Stack sharedInstance].managedObjectContext save:NULL];
////        return queue;
////    }
////}
//
//- (void)addRecording:(Recording *)recording {
//    recording.queue = self.queue;
//}
//    
////    NSArray *array = [RecordingController sharedInstance].memos;
////    Queue *queue = [[RecordingController sharedInstance].memos firstObject];
////    if (recording.returned) {
////        return;
////    }
////    
////    NSArray *array = [[NSArray alloc] init];
////    array = [self.queue.recordings array];
////    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
////
////    [mutableArray addObject:recording];
////    [[RecordingController sharedInstance] save];
//    //  NSMutableOrderedSet *set = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.queue.recordings];
//  //  [set addObject:recording];
// //   [set copy];
//  //  self.queue.recordings = [set copy];
//
//@end
