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
#import "AudioController.h"

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

- (NSDate *)fetchDate {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];

    NSUInteger count = -1;
    dayComponent.day = count;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    return nextDate;
}

- (NSDate *)beginningOfDay {
    NSDate *date = [self fetchDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];

    [components setHour:6];

    [components setMinute:0];

    [components setSecond:0];

    return [cal dateFromComponents:components];
}

- (NSDate *)endOfDay {
    NSDate *date = [self fetchDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
//    [components setYear:0];
//    [components setMonth:0];
//    [components setDay:1];


    [components setHour:23];

    [components setMinute:59];

    [components setSecond:59];

//    NSUInteger count = 1;
//    components.day = count;


    return [cal dateByAddingComponents:components toDate:[self beginningOfDay] options:0];
}

- (NSPredicate *)predicate {

    //    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    //    NSCalendarComponents *components = [calendar components:(NSYearCalendarUnit |NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, and day for today's date
    //    NSDate *firstDate = [calendar dateFromComponents:components]; // makes a new NSDate keeping only the year, month, and day
//    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"createdAt > %@", [self beginningOfDay]];
//    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"createdAt < %@", [self endOfDay]];
//
//    return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:firstPredicate, secondPredicate, nil]];
    return [NSPredicate predicateWithFormat:@"(showAt > %@) AND (showAt <= %@)",[self beginningOfDay], [self endOfDay]];
}


- (NSArray *)memos {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:recordingEntity];
    //[fetchRequest setPredicate:[self predicate]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"simpleDateString = %@", [[AudioController sharedInstance] simpleDateString]];
//   // NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"simpleDateString" ascending:YES];
//   // NSArray *sortDescriptors = @[dateSort];
//    //NSFetchRequest *fetchDate = [[NSFetchRequest alloc] init];
//   // [fetchRequest setSortDescriptors:sortDescriptors];
//    //[fetchDate setEntity:recordingEntity]; 
//    [fetchRequest setPredicate:predicate];
//    NSLog(@"FETCH: %@", fetchRequest);
        fetchRequest.predicate = [self predicate];
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((simpleDate > %@)]
    return [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSArray *)fetchMemos {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:recordingEntity];
    fetchRequest.predicate = [self predicate];
    return [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:NULL];
}

//- (NSArray *)callByDate {
//    [self memos];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"simpleDateString > %@", [[AudioController sharedInstance] simpleDateString]];
//    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"simpleDateString" ascending:YES];
//    NSArray *sortDescriptors = @[dateSort];
//    NSFetchRequest *fetchDate = [[NSFetchRequest alloc] init];
//    [fetchDate setSortDescriptors:sortDescriptors];
//    [fetchDate setEntity:recordingEntity];
//    [fetchDate setPredicate:predicate];
//    NSLog(@"FETCH: %@", fetchDate);
//    return [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchDate error:NULL];
//}

- (NSArray *)memoNames {
    NSMutableArray *mutableMemoNames = [[NSMutableArray alloc] init];
    for (Recording *recording in self.memos) {
       // NSString *string = recording.createdAt;
       // [mutableMemoNames addObject:nowDate];
        NSDate *fetchDate = recording.showAt;
        [mutableMemoNames addObject:fetchDate];
        NSString *urlPath = recording.urlPath;
        [mutableMemoNames addObject:urlPath];
        NSString *idNumber = recording.idNumber;
        [mutableMemoNames addObject:idNumber];
        NSString *simpleDate = recording.simpleDate;
        [mutableMemoNames addObject:simpleDate];
        

//        NSData *memoFile = recording.memo;
//        [mutableMemoNames addObject:memoFile];
        //User *memoFromUser = recording.fromUser;
       // [mutableMemoNames addObject:memoFromUser];
    }
    return mutableMemoNames;
}

- (void)save {
    [[Stack sharedInstance].managedObjectContext save:NULL];
}

- (void)addRecordingWithURL:(NSString *)urlPath andIDNumber:(NSString *)idNumber andDateCreated:(NSString *)createdAt andFetchDate:(NSDate *)showAt andSimpleDate:(NSString *)simpleDate andGroupName:(NSString *)groupName andTimeCreated:(NSString *)timeCreated andData:(NSData *)data {
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:recordingEntity inManagedObjectContext:[Stack sharedInstance].managedObjectContext];

    recording.urlPath = urlPath;
    recording.idNumber = idNumber;
    recording.createdAt = createdAt;
    recording.showAt = showAt;
    recording.simpleDate = simpleDate;
    recording.groupName = groupName;
    recording.timeCreated = timeCreated;
    recording.memo = data;
    
   // [[QueueManager sharedInstance] addRecording:recording];

    [self save];
     NSLog(@"\n\n\n\n CORE DATA SAVED %@", recording);
}

- (void)addGroupID:(NSNumber *)groupID {
    Recording *recording = [self memos].lastObject;

    recording.groupID = groupID;
    
    [self save];
    NSLog(@"\n\n\nGroup ID: %@", groupID);
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
