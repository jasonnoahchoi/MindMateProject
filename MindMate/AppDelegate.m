//
//  AppDelegate.m
//  MindMate
//
//  Created by Jason Noah Choi on 3/26/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioViewController.h"
#import "UIColor+Colors.h"
#import "IntroViewController.h"
#import "RecordingController.h"
#import "NSDate+Utils.h"

static NSString * const finishedIntroKey = @"finishedIntro";
static NSString * const soundEffectsOnKey = @"soundEffects";

@interface AppDelegate ()

@property (nonatomic, strong) AudioViewController *audioVC;
@property (nonatomic, strong) IntroViewController *introVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundgradient"]];
    self.window.backgroundColor = [UIColor whiteColor];
    //AudioRecorderViewController *viewController = [[AudioRecorderViewController alloc] init];
    self.audioVC = [[AudioViewController alloc] init];
    self.introVC = [[IntroViewController alloc] init];

    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:soundEffectsOnKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:soundEffectsOnKey];
    }

  //  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    BOOL finishedIntro = [[NSUserDefaults standardUserDefaults] boolForKey:finishedIntroKey];
    if (!finishedIntro) {
        self.window.rootViewController = self.introVC;
    }
    if (finishedIntro) {
        self.window.rootViewController = self.audioVC;
    }
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
       // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSInteger numberOfRecordings = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfRecordingsKey];
//    if (numberOfRecordings > [RecordingController sharedInstance].memos.count) {
//
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.alertBody = @"Tomorrow has brought you yesterday's recordings, today.";
//        notification.fireDate = [NSDate notificationTime];
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //BOOL hasRecordings = [[NSUserDefaults standardUserDefaults] boolForKey:hasRecordingsKey];
//    NSInteger numberOfRecordings = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfRecordingsKey];
//    if (numberOfRecordings > [RecordingController sharedInstance].memos.count) {
//
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.alertBody = @"Tomorrow has brought you yesterday's recordings, today.";
//        notification.fireDate = [NSDate notificationTime];
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (notification == self.audioVC.notification) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    } else if (notification == self.introVC.notification) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    // Handle the notificaton when the app is running
    NSLog(@"Recieved Notification %@", notification);

}

@end
