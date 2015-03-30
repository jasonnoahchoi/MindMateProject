//
//  RecordingController.m
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "RecordingController.h"
#import "Stack.h"
#import "Recording.h"
#import "Group.h"
#import "User.h"

@interface RecordingController ()

@property (nonatomic, strong) NSArray *memos;

@end

static NSString * const recordingEntity = @"Recording";
static NSString * const userEntity = @"User";
static NSString * const groupEntity = @"Group";

@implementation RecordingController

+ (RecordingController *)sharedInstance {
    static RecordingController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RecordingController alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)memos {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:recordingEntity];
    return [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:NULL];
}

- (NSArray *)memoNames {
    NSMutableArray *mutableMemoNames = [[NSMutableArray alloc] init];
    for (Recording *recording in self.memos) {
        NSString *memoName = recording.memoName;
        [mutableMemoNames addObject:memoName];
        NSData *memoFile = recording.memo;
        [mutableMemoNames addObject:memoFile];
        User *memoFromUser = recording.fromUser;
        [mutableMemoNames addObject:memoFromUser];
    }
    return mutableMemoNames;
}

- (void)save {
    [[Stack sharedInstance].managedObjectContext save:NULL];
}

- (void)addRecordingWithName:(NSString *)memoName {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    recording.memoName = memoName;
    [self save];
}

- (void)addRecordingWithFile:(NSData *)memo {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    recording.memo = memo;
    [self save];
}

- (void)addGroupWithName:(NSString *)groupName {
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:groupEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    group.groupName = groupName;
    [self save];

}

- (void)removeRecording:(Recording *)recording {
    [recording.managedObjectContext deleteObject:recording];
    [self save];
}

- (void)removeGroup:(Group *)group {
    [group.managedObjectContext deleteObject:group];
    [self save];
}

- (void)addRecordingToGroup:(Group *)group {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    [recording setGroup:group];
    [self save];
}

- (void)receiveRecordingFromUser:(User *)user {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    [recording setFromUser:user];
    [self save];
}

@end
