//
//  IntroViewController.h
//  MindMate
//
//  Created by Jason Noah Choi on 4/9/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IntroCircleState) {
    IntroCircleStateNone,
    IntroCircleStateGetStarted,
    IntroCircleStateReady,
    IntroCircleStateStarted,
    IntroCircleStateRecord,
    IntroCircleStatePlay,
    IntroCircleStateNotifications,
    IntroCircleStateFinished
};


@interface IntroViewController : UIViewController

@end
