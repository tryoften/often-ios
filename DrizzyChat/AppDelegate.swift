//
//  AppDelegate.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MMLayershotsDelegate {

    var window: UIWindow?
    var mainController: WalkthroughViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        MMLayershots.sharedInstance().delegate = self
        
        Parse.setApplicationId("L1f21j1lJQuu5xtP17BxdEH1qHWD1VSb6M1otl5G", clientKey: "TQDQM9tDsLSC31qH1zaPvHtNpyfaVcxaUAHe8OiN")
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()
        FBAppEvents.activateApp()

        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)

        mainController = WalkthroughViewController()
        var keyboardVC = KeyboardViewController()
        
        if let window = self.window {
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }
        
        // Whenever a person opens the app, check for a cached session
        if FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded {
            
            // If there's one, just open the session silently, without showing the user the login UI
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: false, completionHandler: {
                (session, state, error) -> Void in
                self.sessionStateChanged(session, state: state, error: error)
            })
        }
        
        for family in UIFont.familyNames() {
            println("\(family)")

            for name in UIFont.fontNamesForFamilyName(family as String) {
                println("  \(name)")
            }
        }
        
        return true
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
    
    func sessionStateChanged(session: FBSession, state: FBSessionState, error:NSError?) {
        // If the session was opened successfully
        if state == FBSessionState.Open {
            println("Session Opened")
        }
        // If the session closed
        else if state == FBSessionState.Closed {
            println("Closed")
        }
    }
    
    // MARK: MMLayershotsDelegate
    
    func shouldCreateLayershotForScreen(screen: UIScreen!) -> MMLayershotsCreatePolicy {
        return .NowPolicy
    }
    
    func didCreateLayershotForScreen(screen: UIScreen!, data: NSData!) {

        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory = paths.first as NSString
        var filePath = documentsDirectory.stringByAppendingPathComponent("layershots.psd")
        data.writeToFile(filePath, atomically: false)
        println("Saving psd to \(filePath)")
    }

}

