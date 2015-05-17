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
#import "User.h"
#import "AudioController.h"
#import "NSDate+Utils.h"

@interface RecordingController ()

@property (nonatomic, strong) NSArray *memos;

@end


@implementation RecordingController

+ (RecordingController *)sharedInstance {
    static RecordingController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RecordingController alloc] init];
    });
    return sharedInstance;
}

- (NSPredicate *)predicate {
    return [NSPredicate predicateWithFormat:@"(showAt > %@) AND (showAt <= %@)",[NSDate beginningOfDay], [NSDate endOfDay]];
}

- (NSArray *)memos {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:recordingEntity];
    fetchRequest.predicate = [self predicate];

    return [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSArray *)fetchMemos {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:recordingEntity];
    fetchRequest.predicate = [self predicate];
    return [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:NULL];
}

- (NSArray *)memoNames {
    NSMutableArray *mutableMemoNames = [[NSMutableArray alloc] init];
    for (Recording *recording in self.memos) {
        NSDate *fetchDate = recording.showAt;
        [mutableMemoNames addObject:fetchDate];
        NSString *urlPath = recording.urlPath;
        [mutableMemoNames addObject:urlPath];
        NSString *idNumber = recording.idNumber;
        [mutableMemoNames addObject:idNumber];
        NSString *simpleDate = recording.simpleDate;
        [mutableMemoNames addObject:simpleDate];
    }
    return mutableMemoNames;
}

- (void)save {
    [[Stack sharedInstance].managedObjectContext save:NULL];
}

- (void)addRecordingWithURL:(NSString *)urlPath andIDNumber:(NSString *)idNumber andDateCreated:(NSString *)createdAt andFetchDate:(NSDate *)showAt andSimpleDate:(NSString *)simpleDate andGroupName:(NSString *)groupName andTimeCreated:(NSString *)timeCreated {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];

    recording.urlPath = urlPath;
    recording.idNumber = idNumber;
    recording.createdAt = createdAt;
    recording.showAt = showAt;
    recording.simpleDate = simpleDate;
    recording.groupName = groupName;
    recording.timeCreated = timeCreated;

    [self save];
}

- (void)addGroupID:(NSNumber *)groupID {
    Recording *recording = [self memos].lastObject;

    recording.groupID = groupID;
    
    [self save];
}

- (void)addRecordingWithFile:(NSData *)memo {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    recording.memo = memo;
    [self save];
}

- (void)removeRecording:(Recording *)recording {
    [recording.managedObjectContext deleteObject:recording];
    [self save];
}

- (void)receiveRecordingFromUser:(User *)user {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    [recording setFromUser:user];
    [self save];
}

@end
