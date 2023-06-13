//
//  AppDelegate.swift
//  LPFeatures
//
//  Created by Milos Jakovljevic on 13/12/2019.
//  Copyright © 2023 Leanplum. All rights reserved.
//

import UIKit
import UserNotifications
import CleverTapSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    public let context = AppContext()
    
    public var cleverTapInstance: CleverTap?
    
    var notificationOptions: UNNotificationPresentationOptions = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        application.applicationIconBadgeNumber = 0

        cleverTapInstance = context.start(with: context.app)
        guard let cleverTapInstance = cleverTapInstance else { return true }
        
        cleverTapInstance.enableDeviceNetworkInfoReporting(true)
        cleverTapInstance.setPushNotificationDelegate(self)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(notificationOptions)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension UIApplication {
    var appDelegate: AppDelegate {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        
        assertionFailure("Failed to get AppDelegate")
        
        return AppDelegate()
    }
}

extension AppDelegate: CleverTapPushNotificationDelegate {
    public func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        let extras = customExtras ?? [:]
        Log.print("Push Notification Tapped with Custom Extras: \(extras)")
    }
}
