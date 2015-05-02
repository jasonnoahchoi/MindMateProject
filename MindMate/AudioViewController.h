//
//  ViewController.h
//  ButtonStuff
//
//  Created by Jason Noah Choi on 4/1/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    CircleStateNone,
    CircleStateLoad,
    CircleStateRecord,
    CircleStatePlay
} CircleState;

@interface AudioViewController : UIViewController

@property (nonatomic, strong) UILocalNotification *reminderNotification;
@property (nonatomic, strong) UILocalNotification *notification;

@end

