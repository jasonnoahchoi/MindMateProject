//
//  Recording.h
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recording : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSData * memo;
@property (nonatomic, retain) NSString * memoName;
@property (nonatomic, retain) NSDate * showAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSManagedObject *fromUser;
@property (nonatomic, retain) NSManagedObject *group;
@property (nonatomic, retain) NSManagedObject *toUser;

@end
