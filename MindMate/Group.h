//
//  Group.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recording;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSSet *recordings;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addRecordingsObject:(Recording *)value;
- (void)removeRecordingsObject:(Recording *)value;
- (void)addRecordings:(NSSet *)values;
- (void)removeRecordings:(NSSet *)values;

@end
