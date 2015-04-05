//
//  RecordingController.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Recording, Group, User;

static NSString * const recordingEntity = @"Recording";
static NSString * const userEntity = @"User";
static NSString * const groupEntity = @"Group";
static NSString * const queueEntity = @"Queue";

@interface RecordingController : NSObject

@property (nonatomic, strong, readonly) NSArray *memos;
@property (nonatomic, strong, readonly) NSArray *memoNames;

+ (RecordingController *)sharedInstance;

- (void)save;
- (void)addRecordingWithURL:(NSString *)urlPath andIDNumber:(NSString *)idNumber andDateCreated:(NSDate *)createdAt andFetchDate:(NSDate *)showAt andSimpleDate:(NSString *)simpleDate andGroupName:(NSString *)groupName;
- (void)addGroupID:(NSNumber *)groupID;
- (void)addRecordingWithFile:(NSData *)memo;
- (void)addGroupWithName:(NSString *)groupName;
- (void)removeRecording:(Recording *)recording;
- (void)removeGroup:(Group *)group;
- (void)addRecordingToGroup:(Group *)group;
- (void)receiveRecordingFromUser:(User *)user;

@end
