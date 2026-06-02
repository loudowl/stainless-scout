//
//  AppDelegate.swift
//  Stainless Scout
//
//  Handles UNUserNotificationCenter delegate methods and
//  application lifecycle events.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Set notification center delegate
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Clear badge when app comes to foreground
        UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// Show notifications even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    /// Handle notification taps
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let sdkId = userInfo["sdkId"] as? String {
            // Post notification to navigate to specific SDK
            NotificationCenter.default.post(
                name: .navigateToSDK,
                object: nil,
                userInfo: ["sdkId": sdkId]
            )
        }
        
        completionHandler()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let navigateToSDK = Notification.Name("com.stainlessscout.navigateToSDK")
    static let sdkFavorited = Notification.Name("com.stainlessscout.sdkFavorited")
    static let premiumUnlocked = Notification.Name("com.stainlessscout.premiumUnlocked")
}
