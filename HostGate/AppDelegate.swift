//
//  AppDelegate.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

extension AppDelegate:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
        
    }
}

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    var defaults:UserDefaults!
    var navController : UINavigationController?
    var storyboard = UIStoryboard()
    var navigationController:UINavigationController?
    let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
    var Role:Int!
    var usrests:String!
    var Language: String!
    var checkController = String()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        
        DGLocalization.sharedInstance.startLocalization()
        Language = ""
//        defaults.set("en", forKey: "Language")
        defaults = UserDefaults.standard
        checkController = defaults.value(forKey: "checkController") as? String ?? ""
        if defaults.object(forKey: "Language") != nil {
            Language = defaults.object(forKey: "Language") as Any as? String
        }
        
        print(Language!)
        if Language == "" || Language == "en"
        {
            let english = Locale().initWithLanguageCode(languageCode: "en", countryCode: "gb", name: "United Kingdom")
            DGLocalization.sharedInstance.setLanguage(withCode:english)
            let defaults = UserDefaults.standard
            defaults.set("en", forKey: "Language")
//            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            
        }else {
            let Arabi = Locale().initWithLanguageCode(languageCode: "ar", countryCode: "KW", name: "kuwait")
            DGLocalization.sharedInstance.setLanguage(withCode:Arabi)
        }
        
        
        Role = defaults.integer(forKey: "ROLE")
        usrests = defaults.value(forKey: "User_Status") as? String
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Array")
        defaults.removeObject(forKey: "CodeHttp")
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        defaults = UserDefaults.standard
        let LoginLogOutStatus = defaults.string(forKey: "Logoutstatus") as NSString?
        if LoginLogOutStatus == "1" {
            
            if self.usrests == "1" {
                window = UIWindow(frame:UIScreen.main.bounds)
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigate = storyboard.instantiateViewController(withIdentifier: "Tabbar")
                navController = UINavigationController(rootViewController: navigate)
                window?.rootViewController = navController
                navigate.navigationController?.navigationBar.isHidden = true
                window?.makeKeyAndVisible()
            }else  if self.usrests == "2" &&  self.Role == 1{
            window = UIWindow(frame:UIScreen.main.bounds)
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigate = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
//                navigate.selectedIndex = 2
//                if  navigate.selectedIndex < navigate.viewControllers!.count {
//                    var viewControllers = navigate.viewControllers
//                    viewControllers?.remove(at:  navigate.selectedIndex)
//                    navigate.viewControllers = viewControllers
//                }
//                navigate.selectedIndex = 0
            navController = UINavigationController(rootViewController: navigate)
            window?.rootViewController = navController
            navigate.navigationController?.navigationBar.isHidden = true
            window?.makeKeyAndVisible()
            }   else if self.usrests == "2" && self.Role == 2 {
                window = UIWindow(frame:UIScreen.main.bounds)
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigate = storyboard.instantiateViewController(withIdentifier: "FinDashboardViewController") as! FinDashboardViewController
                navController = UINavigationController(rootViewController: navigate)
                window?.rootViewController = navController
                navigate.navigationController?.navigationBar.isHidden = true
                window?.makeKeyAndVisible()
            } else if self.usrests == "2" && self.Role == 3  {
                window = UIWindow(frame:UIScreen.main.bounds)
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigate = storyboard.instantiateViewController(withIdentifier: "Tabbar")
                navController = UINavigationController(rootViewController: navigate)
                window?.rootViewController = navController
                navigate.navigationController?.navigationBar.isHidden = true
                window?.makeKeyAndVisible()
            }else if self.usrests == "3" {
                window = UIWindow(frame:UIScreen.main.bounds)
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigate = storyboard.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                navController = UINavigationController(rootViewController: navigate)
                window?.rootViewController = navController
                navigate.navigationController?.navigationBar.isHidden = true
                window?.makeKeyAndVisible()
            }else if self.usrests == "4" {
                window = UIWindow(frame:UIScreen.main.bounds)
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigate = storyboard.instantiateViewController(withIdentifier: "GateHomeViewController") as! GateHomeViewController
                navController = UINavigationController(rootViewController: navigate)
                window?.rootViewController = navController
                navigate.navigationController?.navigationBar.isHidden = true
                window?.makeKeyAndVisible()
            }
        }
        else {
            if checkController == "" || checkController == ""{
            window = UIWindow(frame:UIScreen.main.bounds)
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigate = storyboard.instantiateViewController(withIdentifier: "StartLanguageSelectVC") as! StartLanguageSelectVC
            navController = UINavigationController(rootViewController: navigate)
            window?.rootViewController = navController
            navigate.navigationController?.navigationBar.isHidden = true
            window?.makeKeyAndVisible()
            }else{
                 window = UIWindow(frame:UIScreen.main.bounds)
                 storyboard = UIStoryboard(name: "Main", bundle: nil)
                 let navigate = storyboard.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
                 navController = UINavigationController(rootViewController: navigate)
                 window?.rootViewController = navController
                 navigate.navigationController?.navigationBar.isHidden = true
                 window?.makeKeyAndVisible()
            }
        }
        
        
        // Override point for customization after application launch.
        return true
    }
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
            Messaging.messaging().apnsToken = deviceToken
            Messaging.messaging().isAutoInitEnabled = true
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let deafults = UserDefaults.standard
        deafults.set(fcmToken, forKey: "Devicetoken")
        deafults.synchronize()
        print("Firebase registration token: \(fcmToken)")
    }
    
    func  application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
           print("test")
           
       }
    
    //MARK:- Click on notification click
        
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            let userInfo = userInfo as! [String: Any]
            print(userInfo)
    //        var count:Int!
    //        count = userInfo["badge"] as? Int
    //        application.applicationIconBadgeNumber = count
            //let type = DataManager.getVal(userInfo["type"]) as! String
            
        }
        private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {
            //Handle the notification
            completionHandler(
                [UNNotificationPresentationOptions.alert,
                 UNNotificationPresentationOptions.sound,
                 UNNotificationPresentationOptions.badge])
            
        }
        
        //MARK:- Function will call when application in active state
        func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])
            let userInfo = notification.request.content.userInfo as! [String: Any]
            print(userInfo)
        
            //let type = DataManager.getVal(userInfo["type"]) as! String
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

