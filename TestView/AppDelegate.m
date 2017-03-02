//
//  AppDelegate.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/9/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

NSString *const kBadgeNumber = @"badgeCount";
NSString *const kCoreModelName = @"Model";

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[[NSUserDefaults standardUserDefaults] objectForKey:kBadgeNumber] intValue]];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
             if( !error ) {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
                 NSLog( @"Push registration success." );
             } else {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
    }];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:kCoreModelName];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        [self setBadgePlus:1];
    }
}

-(void)setBadgePlus:(NSInteger)inc {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kBadgeNumber] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kBadgeNumber];
    }
    
    NSNumber *cBadge = [[NSUserDefaults standardUserDefaults] objectForKey:kBadgeNumber];
    cBadge = [NSNumber numberWithInt:[cBadge intValue] + inc];
    [[NSUserDefaults standardUserDefaults] setObject:cBadge forKey:kBadgeNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    localNotif.alertBody = nil;
    localNotif.applicationIconBadgeNumber = [cBadge intValue];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[cBadge intValue]];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    if (notification.request.trigger != nil) {
        [self setBadgePlus:1];
    }
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushNotificationTapedNotificationName object:self ];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
