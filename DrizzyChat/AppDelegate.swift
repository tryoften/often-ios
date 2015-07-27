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

private var TestKeyboard: Bool = true

let appClientID = "2784"
let appSecret = "M9KM33YyReByzfn9dV9rnLK6pLTepB46"
var accessToken = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainController: UIViewController!
    var venmoService: VenmoService!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics()])
        
        venmoService = VenmoService()
    
        Venmo.startWithAppId(appClientID, secret: appSecret, name: "Smurf")
        
//        Venmo.sharedInstance().requestPermissions(["make_payments", "access_profile", "access_friends"]) { (success, error) -> Void in
//            if success {
//                println("Permissions Success!")
//            } else {
//                println("Permissions Fail")
//            }
//        }
//        
//        if Venmo.isVenmoAppInstalled() {
//            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API
//        } else {
//            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.AppSwitch
//        }
    
        var screen = UIScreen.mainScreen()
        var frame = screen.bounds
        
        window = UIWindow(frame: frame)

        if let window = self.window {
            if TestKeyboard {
//                var frame = window.frame
//                frame.origin.y = frame.size.height / 2
//                frame.size.height = frame.size.height / 2
//                window.frame = frame
//                window.clipsToBounds = true
                mainController = KeyboardViewController(debug: true)
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
        
        if Venmo.sharedInstance().handleOpenURL(url) {
            var urlString: String = url.absoluteString!
            var index = 0
            
            for var i = 0; i < count(urlString); i++ {
                if urlString[i] == "=" {
                    index = i
                }
            }
            
            accessToken = urlString.substringFromIndex(index + 1)
        
            var session = Venmo.sharedInstance().session
            session.accessToken
            
            println(session.accessToken)
            
            venmoService.getCurrentUserInformation(session.accessToken)
            // venmoService.getCurrentUserListOfFriend(<#accessToken: String#>, id: <#String#>)
            
            return true
        }
        
        return false
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().postNotificationName("database:persist", object: self)
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
