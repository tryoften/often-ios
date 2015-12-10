
//
//  AppDelegate.swift
//  Often
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Project Surf Inc.. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Realm
import OAuthSwift

private var TestKeyboard: Bool = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    let sessionManager = SessionManager.defaultManager
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()
        PFTwitterUtils.initializeWithConsumerKey(TwitterConsumerKey,  consumerSecret:TwitterConsumerSecret)
        FBAppEvents.activateApp()
        Flurry.startSession(FlurryClientKey)
        SPTAuth.defaultInstance().clientID = SpotifyClientID
        SPTAuth.defaultInstance().redirectURL = NSURL(string: OftenCallbackURL)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert,.Badge], categories: []))
    
        let screen = UIScreen.mainScreen()
        let frame = screen.bounds
        
        window = UIWindow(frame: frame)
        window?.backgroundColor = VeryLightGray

        if let window = self.window {
            if TestKeyboard {
                var frame = window.frame
                frame.origin.y = frame.size.height - (KeyboardHeight + 100)
                frame.size.height = KeyboardHeight + 100
                window.frame = frame
                window.clipsToBounds = true
                mainController = MediaLinksKeyboardContainerViewController(extraHeight: 100.0, debug: true)
            } else {
                let signupViewModel = SignupViewModel(sessionManager: sessionManager)
                mainController = SignupViewController(viewModel: signupViewModel)
            }
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Registration failed \(error)", terminator: "")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if url.absoluteString.hasPrefix("tryoften://logindone") {
            sessionManager.soundcloudAccountManager?.handleOpenURL(url)
            return true
        }
        
        if url.absoluteString.hasPrefix("tryoften://" ) {
            if SPTAuth.defaultInstance().canHandleURL(url){
                SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: sessionManager.spotifyAccountManager?.authCallback)
                return true
            }
        }
        
        return false
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
