//
//  Recording.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/31/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Queue, User;

@interface Recording : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSData * memo;
@property (nonatomic, retain) NSString * memoName;
@property (nonatomic, retain) NSDate * showAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * urlPath;
@property (nonatomic, retain) NSNumber * returned;
@property (nonatomic, retain) NSString * simpleDate;
@property (nonatomic, retain) User *fromUser;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) User *toUser;
@property (nonatomic, retain) Queue *queue;

@end
