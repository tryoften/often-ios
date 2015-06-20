//
//  AppDelegate.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Realm

private var TestKeyboard: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    var sessionManager: SessionManager!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        sessionManager = SessionManager.defaultManager

        ParseCrashReporting.enable()
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()
        FBAppEvents.activateApp()
        
        Flurry.startSession(FlurryClientKey)
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName)!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)

        var screen = UIScreen.mainScreen()
        var frame = screen.bounds
        
        window = UIWindow(frame: frame)
        
        var userNotificationTypes = UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound
        var settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        if sessionManager.isUserLoggedIn() {
            mainController = TabBarController(sessionManager: sessionManager)
        } else {
            mainController = UINavigationController(rootViewController: SignUpLoginWalkthroughViewController(sessionManager:sessionManager))
        }
        
        
        if let window = self.window {
            if TestKeyboard {
                var frame = window.frame
                frame.origin.y = frame.size.height - KeyboardHeight
                frame.size.height = KeyboardHeight
                window.frame = frame
                window.clipsToBounds = true
                mainController = KeyboardViewController(nibName: nil, bundle: nil)
                if let inputView = mainController.inputView {
                    inputView.frame = frame
                }
            }
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }
        
        for family in UIFont.familyNames() {
            println("\(family)")

            for name in UIFont.fontNamesForFamilyName(family as! String) {
                println("  \(name)")
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.addUniqueObject("Lyrics", forKey: "channels")
        currentInstallation.saveInBackgroundWithBlock({ saved in
            
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Registration failed \(error)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

