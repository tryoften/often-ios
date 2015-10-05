//
//  AppDelegate.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Realm
import OAuthSwift

private var TestKeyboard: Bool = false

var leftViewController: SocialAccountSettingsCollectionViewController?
var rightViewController: AppSettingsViewController?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    var venmoAccountManager: VenmoAccountManager!
    var spotifyAccountManager: SpotifyAccountManager! 
    var soundcloudAccountManager: SoundcloudAccountManager!
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

         
        let screen = UIScreen.mainScreen()
        let frame = screen.bounds
        
        window = UIWindow(frame: frame)

        if let window = self.window {
            if TestKeyboard {
                var frame = window.frame
                frame.origin.y = frame.size.height - (KeyboardHeight + 100)
                frame.size.height = KeyboardHeight + 100
                window.frame = frame
                window.clipsToBounds = true
                mainController = KeyboardViewController(debug: true)
            } else {
                venmoAccountManager = VenmoAccountManager()
                spotifyAccountManager = SpotifyAccountManager()
                soundcloudAccountManager = SoundcloudAccountManager()
                
                let userProfileViewModel = UserProfileViewModel(sessionManager: sessionManager)
                let socialAccountViewModel = SocialAccountSettingsViewModel(sessionManager: sessionManager, venmoAccountManager: venmoAccountManager, spotifyAccountManager: spotifyAccountManager, soundcloudAccountManager: soundcloudAccountManager)
                let signupViewModel = SignupViewModel(sessionManager: sessionManager, venmoAccountManager: venmoAccountManager, spotifyAccountManager: spotifyAccountManager, soundcloudAccountManager: soundcloudAccountManager)
                
                if sessionManager.userDefaults.objectForKey("user") != nil {
                    let shouldShowInstallationKeyboardWalkthrough = sessionManager.userDefaults.boolForKey("keyboardInstall")
                    
                    if shouldShowInstallationKeyboardWalkthrough {
                        let frontViewController = UserProfileViewController(collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(), viewModel: userProfileViewModel)
                        let mainViewController = SlideNavigationController(rootViewController: frontViewController)
                        mainViewController.navigationBar.hidden = true
                        mainViewController.enableShadow = false
                        mainViewController.panGestureSideOffset = CGFloat(30)
                        // left view controller: Set Services for keyboard
                        // right view controller: App Settings
                        leftViewController = SocialAccountSettingsCollectionViewController(collectionViewLayout: SocialAccountSettingsCollectionViewController.provideCollectionViewLayout(), viewModel: socialAccountViewModel)
                        rightViewController = AppSettingsViewController()
                        
                        SlideNavigationController.sharedInstance().leftMenu =  leftViewController
                        SlideNavigationController.sharedInstance().rightMenu = rightViewController
                        
                        mainController = mainViewController
                    } else {
                        mainController = KeyboardInstallationWalkthroughViewController(viewModel: signupViewModel)
                    }
                    
                } else {
                    mainController = SignupViewController(viewModel: signupViewModel)
                }
                
            }
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
        
        if ( url.absoluteString.hasPrefix("tryoften://logindone" )){
            soundcloudAccountManager.handleOpenURL(url)
            return true
        }
        if ( url.absoluteString.hasPrefix("tryoften://" )){
            if SPTAuth.defaultInstance().canHandleURL(url){
                SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: spotifyAccountManager.authCallback)
                return true
            }
        } else if Venmo.sharedInstance().handleOpenURL(url) {
            let session = Venmo.sharedInstance().session
            venmoAccountManager.getCurrentCurrentSessionToken(session)
            venmoAccountManager.getVenmoUserInformation(session.accessToken)
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
        return self[self.startIndex.advancedBy(index)]
    }
    
    func substringFromIndex(index:Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
}
