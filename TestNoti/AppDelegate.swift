//
//  AppDelegate.swift
//  TestNoti
//
//  Created by nutdanai on 2/1/2562 BE.
//  Copyright © 2562 nutdanai. All rights reserved.
//

import UIKit
import Firebase

import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

import UserNotificationsUI
import UserNotifications

import FirebaseAuth

import ApiAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (isSuccess, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if isSuccess
                {
                    let acceptAction = UNNotificationAction(identifier: "accept", title: "Accept", options: [])
                    let declineAction = UNTextInputNotificationAction(identifier: "reject", title: "Reject", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "reject reason..")
                    let category = UNNotificationCategory(identifier: "CustomSamplePush", actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
                    UNUserNotificationCenter.current().setNotificationCategories([category])
                    UNUserNotificationCenter.current().delegate = self
                }
                else
                {
                    print("\u{1F6AB} Request denied.")
                }
            })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        RemoteConfig.remoteConfig().configSettings = RemoteConfigSettings(developerModeEnabled: true)
        
        
        
        ApiAI.shared()?.configuration.clientAccessToken = "210a49463c9041b5a4b82f462dcd5915"
        
        application.registerForRemoteNotifications()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        setAppRemoteConfig()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


extension AppDelegate: MessagingDelegate {
    
    // MARK : FCM Push Notification . . .
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase Registration Token \(fcmToken)")
//        Analytics.setUserID("eiei")
//        Auth.auth().
        Analytics.setUserID("1129900119221")
//        Analytics.setUserID("123456")
    }
    
    // Called when Registration is successfull
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase Refresh Token \(fcmToken)")
    }
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground \(notification.request.content.userInfo)")
        
        // Reading message body
        let isShowNotification = notification.request.content.userInfo["isShow"] as? String
        var isShow = false
        if isShowNotification != nil {
            if isShowNotification!.trimmingCharacters(in: .whitespacesAndNewlines) == "1" {
                isShow = true
            }
        }
        if isShow {
            let dict = notification.request.content.userInfo["aps"] as! NSDictionary
            
            var messageBody:String?
            var messageTitle:String = "Alert"
            
            if let alertDict = dict["alert"] as? Dictionary<String, String> {
                messageBody = alertDict["body"]!
                if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
            } else {
                messageBody = dict["alert"] as? String
            }
            print("Message body is \(messageBody!) ")
            print("Message messageTitle is \(messageTitle) ")
            
            completionHandler([.alert,.sound, .badge])
        } else {
            SingletonService.shared.publishSubject.onNext((notification.request.content.userInfo["updateStatus"] as? String) ?? "")
//            SingletonService.shared.setNewStatus(notification.request.content.userInfo["updateStatus"] as? String)
            print("dont show")
            completionHandler([])
        }
        // Let iOS to display message
    }
    
    //    background or close
    //    click
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //        print("Message \(response.notification.request.content.userInfo)")
  
        if response.notification.request.content.userInfo["link"] != nil {
            let dict = response.notification.request.content.userInfo["link"] as! String
                
            print(dict)
        }
        completionHandler()
    }
    
    //    Called When Silent Push Notification Arrives
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}




