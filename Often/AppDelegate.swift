//
//  AppDelegate.swift
//  Often
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Project Surf Inc. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.sharedSDK().debug = true
        Twitter.sharedInstance().start(withConsumerKey: TwitterConsumerKey, consumerSecret: TwitterConsumerSecret)
        Fabric.with([Crashlytics(), Twitter.sharedInstance()])
        FIROptions.default().deepLinkURLScheme = AppIdentifier
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptions(inBackground: launchOptions, block: nil)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Flurry.startSession(FlurryClientKey)
        application.applicationIconBadgeNumber = 0

        let screen = UIScreen.main()
        let frame = screen.bounds

        window = UIWindow(frame: frame)
        window?.backgroundColor = VeryLightGray

        if let window = self.window {
        #if KEYBOARD_DEBUG
            var frame = window.frame
            frame.origin.y = frame.size.height - (KeyboardHeight + 100)
            frame.size.height = KeyboardHeight + 100
            window.frame = frame
            window.clipsToBounds = true
            mainController = MediaItemsKeyboardContainerViewController(extraHeight: 64.0)
        #else
            let sessionManager = SessionManager.defaultManager
            let loginViewModel = LoginViewModel(sessionManager: sessionManager)
            mainController = LoginViewController(viewModel: loginViewModel)
        #endif
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }

        NotificationCenter.default().addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                                         name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)

        if let URL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? URL {
            delay(1) {
                UIApplication.shared().openURL(URL)
            }
        }

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation.setDeviceTokenFrom(deviceToken)
        installation.channels = ["global"]
        installation.saveInBackground()
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
         PFPush.handle(userInfo)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Registration failed \(error)", terminator: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let urlString = url.absoluteString!
        
        if urlString.hasPrefix("fb") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        if urlString.contains("pack/") {
            guard let id = url.lastPathComponent else {
                return false
            }

            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "didClickPackLink"), object: nil, userInfo: ["packid" : id])
        }

        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        connectToFcm()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        if let packid = userInfo["p"] as? String {
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "didClickPackLink"), object: nil, userInfo: ["packid" : packid])
            
            completionHandler(.newData)
        } else {
            completionHandler(.failed)
        }

    }

    func tokenRefreshNotificaiton(_ notification: Foundation.Notification) {
        let refreshedToken = FIRInstanceID.instanceID().token()

        print(refreshedToken)
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }

    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }


    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let handled = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
        }

        return handled!
    }
}
