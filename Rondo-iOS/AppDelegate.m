//
//  AppDelegate.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AppDelegate.h"
#import <Leanplum/Leanplum.h>
#import <UserNotifications/UserNotifications.h>
#import "DeeplinkViewController.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    
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
    [Leanplum applicationWillTerminate];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Needs to be called if swizzling is disabled in Info.plist otherwise it wont affect SDK if swizzling is enabled.
    [Leanplum didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Needs to be called if swizzling is disabled in Info.plist otherwise it wont affect SDK if swizzling is enabled.
    [Leanplum didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // Needs to be called if swizzling is disabled in Info.plist otherwise it wont affect SDK if swizzling is enabled.
    [Leanplum didFailToRegisterForRemoteNotificationsWithError:error];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url host] isEqualToString:@"deep_link_page"]) {
        DeeplinkViewController *vc = [[DeeplinkViewController alloc] initWithNibName:@"DeeplinkViewController" bundle:[NSBundle mainBundle]];
        UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navController = (UINavigationController *)tabBar.selectedViewController;
        [navController pushViewController:vc animated:NO];
        return YES;
    }
    return NO;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
//    Leanplum willpres
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    [Leanplum didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}

@end
