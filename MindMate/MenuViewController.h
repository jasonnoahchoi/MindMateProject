//
//  MenuViewController.h
//  MindMate
//
//  Created by Jason Noah Choi on 4/8/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>

- (void)reanimateCircles;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;

@end
