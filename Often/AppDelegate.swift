//
//  AppDelegate.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Realm
import Fabric
import Crashlytics

private var TestKeyboard: Bool = false

// PKRevealController
var revealController: PKRevealController?
var frontNavigationController: UINavigationController?
var frontViewController: UserProfileViewController?
var leftViewController: SocialAccountSettingsCollectionViewController?
var rightViewController: AppSettingsViewController?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    var venmoService: VenmoService!
    let sessionManager = SessionManager.defaultManager
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics()])
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()
        PFTwitterUtils.initializeWithConsumerKey(TwitterConsumerKey,  consumerSecret:TwitterConsumerSecret)
        FBAppEvents.activateApp()
        Flurry.startSession(FlurryClientKey)
    
        var screen = UIScreen.mainScreen()
        var frame = screen.bounds
        
        window = UIWindow(frame: frame)

        if let window = self.window {
            if TestKeyboard {
                mainController = KeyboardViewController(nibName: nil, bundle: nil)
            } else {
                let userProfileViewModel = UserProfileViewModel(sessionManager: sessionManager)
                let socialAccountViewModel = SocialAccountSettingsViewModel(sessionManager: sessionManager)
                // Front view controller must be navigation controller - will hide the nav bar
                frontViewController = UserProfileViewController(collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(), viewModel: userProfileViewModel)
                frontNavigationController = UINavigationController(rootViewController: frontViewController!)
                frontNavigationController?.setNavigationBarHidden(true, animated: true)
                
                // left view controller: Set Services for keyboard
                // right view controller: App Settings
                leftViewController = SocialAccountSettingsCollectionViewController(collectionViewLayout: SocialAccountSettingsCollectionViewController.provideCollectionViewLayout(), viewModel: socialAccountViewModel)
                rightViewController = AppSettingsViewController()

                
                // instantiate PKRevealController and set as mainController to do revealing
                revealController = PKRevealController(frontViewController: frontNavigationController, leftViewController: leftViewController, rightViewController: rightViewController)
                revealController?.setMinimumWidth(320.0, maximumWidth: 340.0, forViewController: leftViewController)
                
                mainController = revealController
            }
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Registration failed \(error)")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
         venmoService = VenmoService()
        
        if Venmo.sharedInstance().handleOpenURL(url) {
            var urlString: String = url.absoluteString!
            var index = 0
            
            for var i = 0; i < count(urlString); i++ {
                if urlString[i] == "=" {
                    index = i
                }
            }

            var session = Venmo.sharedInstance().session
            session.accessToken
            
            println(session.accessToken)
            
            venmoService.getCurrentUserInformation(session.accessToken)
            
            return true
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

extension String {
    subscript(index:Int) -> Character{
        return self[advance(self.startIndex, index)]
    }
    
    func substringFromIndex(index:Int) -> String {
        return self.substringFromIndex(advance(self.startIndex, index))
    }
}
