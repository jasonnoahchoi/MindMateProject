//
//  User.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/31/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recording;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *recordingsGiven;
@property (nonatomic, retain) NSSet *recordingsReceived;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRecordingsGivenObject:(Recording *)value;
- (void)removeRecordingsGivenObject:(Recording *)value;
- (void)addRecordingsGiven:(NSSet *)values;
- (void)removeRecordingsGiven:(NSSet *)values;

- (void)addRecordingsReceivedObject:(Recording *)value;
- (void)removeRecordingsReceivedObject:(Recording *)value;
- (void)addRecordingsReceived:(NSSet *)values;
- (void)removeRecordingsReceived:(NSSet *)values;

@end
