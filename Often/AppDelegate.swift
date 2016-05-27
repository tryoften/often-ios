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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.sharedSDK().debug = true
        Twitter.sharedInstance().startWithConsumerKey(TwitterConsumerKey, consumerSecret: TwitterConsumerSecret)
        Fabric.with([Crashlytics(), Twitter.sharedInstance()])
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Flurry.startSession(FlurryClientKey)

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

        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        installation.saveInBackground()
        print(deviceToken)
    }
    

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
         PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Registration failed \(error)", terminator: "")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.absoluteString.hasPrefix("fb") {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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

    // [START receive_message]
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"])")

        // Print full message.
        print("%@", userInfo)
    }

    func tokenRefreshNotificaiton(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")

        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }

    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }


}
