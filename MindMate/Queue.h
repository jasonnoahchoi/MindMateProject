//
//  Queue.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/31/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recording;

@interface Queue : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *recordings;

@end

@interface Queue (CoreDataGeneratedAccessors)

- (void)insertObject:(Recording *)value inRecordingsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecordingsAtIndex:(NSUInteger)idx;
- (void)insertRecordings:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecordingsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecordingsAtIndex:(NSUInteger)idx withObject:(Recording *)value;
- (void)replaceRecordingsAtIndexes:(NSIndexSet *)indexes withRecordings:(NSArray *)values;
- (void)addRecordingsObject:(Recording *)value;
- (void)removeRecordingsObject:(Recording *)value;
- (void)addRecordings:(NSOrderedSet *)values;
- (void)removeRecordings:(NSOrderedSet *)values;
@end
