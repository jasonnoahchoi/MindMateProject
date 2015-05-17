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
#import "SupportViewController.h"
#import "NSDate+Utils.h"
#import "NSArray+RecordPlayStrings.h"
#import "Harpy.h"

static NSString * const finishedIntroKey = @"finishedIntro";
static NSString * const soundEffectsOnKey = @"soundEffects";
static NSString * const launchCountKey = @"launchCount";
static NSString * const remindLaterKey = @"remind";
static NSString * const clickedRateKey = @"rate";

@interface AppDelegate ()

@property (nonatomic, strong) AudioViewController *audioVC;
@property (nonatomic, strong) IntroViewController *introVC;
@property (nonatomic, assign) NSInteger launchCount;
@property (nonatomic, assign) BOOL clickedRate;

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

    self.clickedRate = [[NSUserDefaults standardUserDefaults] boolForKey:clickedRateKey];

    self.launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:launchCountKey];

    [self trackLaunches];

  //  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    BOOL finishedIntro = [[NSUserDefaults standardUserDefaults] boolForKey:finishedIntroKey];
    if (!finishedIntro) {
        self.window.rootViewController = self.introVC;
    }
    if (finishedIntro) {
        self.window.rootViewController = self.audioVC;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(rateApp) userInfo:nil repeats:NO];

    [self.window makeKeyAndVisible];

    [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(presentHarpy) userInfo:nil repeats:NO];

    return YES;
}

- (void)presentHarpy {
    [[Harpy sharedInstance] setAppID:@"984969197"];
    [[Harpy sharedInstance] setPresentingViewController:self.audioVC];
    [[Harpy sharedInstance] setAppName:@"Tomorrow"];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeForce];
    [[Harpy sharedInstance] checkVersion];
}

- (void)rateApp {
    if (self.launchCount == 3) {
        UIAlertController *rateAppAlertController = [UIAlertController alertControllerWithTitle:@"Rate Tomorrow" message:@"If you enjoy using Tomorrow, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!" preferredStyle:UIAlertControllerStyleAlert];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Rate It Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:clickedRateKey];
            NSLog(@"rate app");
            NSString *appID = @"984969197";
            NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID]];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }]];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Not a Fan" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            SupportViewController *rateAppVC = [[SupportViewController alloc] init];
            //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rateAppVC];
            [self.window.rootViewController presentViewController:rateAppVC animated:YES completion:nil];
        }]];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Remind Me Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:remindLaterKey];
        }]];

        [self.window.rootViewController presentViewController:rateAppAlertController animated:YES completion:nil];
    }

    BOOL remind = [[NSUserDefaults standardUserDefaults] boolForKey:remindLaterKey];
    if (self.launchCount == 8 && remind) {
        UIAlertController *rateAppAlertController = [UIAlertController alertControllerWithTitle:@"Rate Tomorrow" message:@"If you enjoy using Tomorrow, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!" preferredStyle:UIAlertControllerStyleAlert];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Rate It Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"rate app");
            NSString *appName = @"984969197";
            NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appName]];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }]];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"Not a Fan" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            SupportViewController *rateAppVC = [[SupportViewController alloc] init];
            // UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rateAppVC];
            [self.window.rootViewController presentViewController:rateAppVC animated:YES completion:nil];
        }]];
        [rateAppAlertController addAction:[UIAlertAction actionWithTitle:@"No, thanks" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self.window.rootViewController presentViewController:rateAppAlertController animated:YES completion:nil];
    }

}

#pragma mark - Launch Tracker
- (void)trackLaunches {
//    NSInteger launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:launchCountKey];

    if (self.launchCount) {
        self.launchCount++;
    } else {
        self.launchCount = 1;
    }

    NSLog(@"%ld", (long) self.launchCount);

    [[NSUserDefaults standardUserDefaults] setInteger:self.launchCount forKey:launchCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([[self.audioVC.longTimeNotification.userInfo valueForKey:@"reminding"] isEqualToString:@"Been a while"]) {
        [[UIApplication sharedApplication]cancelLocalNotification:self.audioVC.longTimeNotification];
        NSLog(@"No more Long Time");
    }
    if ([[self.audioVC.reallyLongTimeNotification.userInfo valueForKey:@"remindingAgain"] isEqualToString:@"Really long while"]) {
        [[UIApplication sharedApplication]cancelLocalNotification:self.audioVC.reallyLongTimeNotification];
        NSLog(@"No more Really Long Time");
    }

    if (self.audioVC.hasRecordings) {
        if ([[self.audioVC.longTimeNotification.userInfo valueForKey:@"reminding"] isEqualToString:@"Been a while"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.longTimeNotification];
        }
        if ([[self.audioVC.reallyLongTimeNotification.userInfo valueForKey:@"remindingAgain"] isEqualToString:@"Really long while"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.reallyLongTimeNotification];
        }
        return;
    } else {
        self.audioVC.longTimeNotification = [[UILocalNotification alloc] init];
        NSUInteger randomIndexRecord = arc4random() % [[NSArray arrayOfRecordYourselfMessages] count];
        self.audioVC.longTimeNotification.alertBody = [NSArray arrayOfRecordYourselfMessages][randomIndexRecord];
        self.audioVC.longTimeNotification.timeZone = [NSTimeZone localTimeZone];
        self.audioVC.longTimeNotification.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Been a while"] forKey:@"reminding"];
        self.audioVC.longTimeNotification.fireDate = [NSDate beenLongTimeNotification];
        self.audioVC.longTimeNotification.applicationIconBadgeNumber = 1;
        self.audioVC.longTimeNotification.soundName = @"babypopagain.caf";
        [[UIApplication sharedApplication] scheduleLocalNotification:self.audioVC.longTimeNotification];

        self.audioVC.reallyLongTimeNotification = [[UILocalNotification alloc] init];
        self.audioVC.reallyLongTimeNotification.alertBody = [NSArray arrayOfRecordYourselfMessages][randomIndexRecord];
        self.audioVC.reallyLongTimeNotification.timeZone = [NSTimeZone localTimeZone];
        self.audioVC.reallyLongTimeNotification.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Really long while"] forKey:@"remindingAgain"];
        self.audioVC.reallyLongTimeNotification.fireDate = [NSDate reallyLongTimeNotification];
        self.audioVC.reallyLongTimeNotification.applicationIconBadgeNumber = 1;
        self.audioVC.reallyLongTimeNotification.soundName = @"babypopagain.caf";
        if (!self.audioVC.notification) {
            [[UIApplication sharedApplication] scheduleLocalNotification:self.audioVC.reallyLongTimeNotification];
        }
    }

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
     [[Harpy sharedInstance] checkVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Harpy sharedInstance] checkVersionDaily];
    [[Harpy sharedInstance] checkVersionWeekly];
    if ([[self.audioVC.longTimeNotification.userInfo valueForKey:@"reminding"] isEqualToString:@"Been a while"] || [[self.audioVC.reallyLongTimeNotification.userInfo valueForKey:@"remindingAgain"] isEqualToString:@"Really long while"]) {
          [[UIApplication sharedApplication]cancelLocalNotification:self.audioVC.longTimeNotification];
        self.audioVC.longTimeNotification = nil;
        [[UIApplication sharedApplication]cancelLocalNotification:self.audioVC.reallyLongTimeNotification];
        self.audioVC.reallyLongTimeNotification = nil;
    }

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
        if (notification == self.audioVC.reminderNotification) {
            [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.reminderNotification];
        }
        if (notification == self.introVC.notification) {
             [[UIApplication sharedApplication] cancelLocalNotification:self.introVC.notification];
        }
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    } else if (notification == self.audioVC.reminderNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    } else if (notification == self.introVC.notification) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        if (notification == self.audioVC.reminderNotification) {
            [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.reminderNotification];
        }
        if (notification == self.audioVC.notification) {
            [[UIApplication sharedApplication] cancelLocalNotification:self.audioVC.notification];
        }
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Handle the notificaton when the app is running
    NSLog(@"Recieved Notification %@", notification);

}

@end
