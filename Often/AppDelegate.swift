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
import Nuke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.sharedSDK().debug = true
        Twitter.sharedInstance().startWithConsumerKey(TwitterConsumerKey, consumerSecret: TwitterConsumerSecret)
        Fabric.with([Crashlytics(), Twitter.sharedInstance()])
        FIROptions.defaultOptions().deepLinkURLScheme = "com.tryoften.often.master"
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Flurry.startSession(FlurryClientKey)
        ImageManager.shared.setupImageManager()

        application.applicationIconBadgeNumber = 0
        
        let screen = UIScreen.mainScreen()
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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                                         name: kFIRInstanceIDTokenRefreshNotification, object: nil)

        if let URL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL {
            delay(1) {
                UIApplication.sharedApplication().openURL(URL)
            }
        }

        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation?.setDeviceTokenFromData(deviceToken)
        installation?.channels = ["global"]
        installation?.saveInBackground()
    }
    

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
         PFPush.handlePush(userInfo)
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Registration failed \(error)", terminator: "")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let urlString = url.absoluteString
        if urlString.hasPrefix("fb") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        else if urlString.containsString("pack/") {
            guard let id = url.lastPathComponent else {
                return false
            }

            NSNotificationCenter.defaultCenter().postNotificationName("didClickPackLink", object: nil, userInfo: ["packid" : id])
        }

        else if urlString.containsString("user/") {
            guard let id = url.lastPathComponent else {
                return false
            }

            NSNotificationCenter.defaultCenter().postNotificationName("displayUserProfile", object: nil, userInfo: ["userId" : id])
        }

        return false
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let packid = userInfo["p"] as? String {
            delay(1) {
                NSNotificationCenter.defaultCenter().postNotificationName("didClickPackLink", object: nil, userInfo: ["packid" : packid])
            }
            
            completionHandler(.NewData)
        } else {
            completionHandler(.Failed)
        }

    }

    func tokenRefreshNotificaiton(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()

        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }

    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }


    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let handled = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
        }

        return handled!
    }
}
