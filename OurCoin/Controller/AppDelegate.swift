  
//  AppDelegate.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/23/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import LinkKit
import Firebase
import FBSDKLoginKit
import coinbase_official

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //plaid configuration
        setupPlaidWithCustomConfiguration()
        //firebase configuration
        FirebaseApp.configure()
        //fb configuration
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (url.scheme == "com.Spencer.OurCoin.coinbase-oauth"){
            CoinbaseOAuth.finishAuthentication(for: url, clientId: "f67977ea795aea61d532175fbb96964b193111ba89ec3e1ff95554b2ef588b04", clientSecret: "2c446eeae51f9fdfce85193e4cbd2bd6b16d3706d8be0692565fc791663ba4cc", completion: { (result : AnyObject?, error: NSError?) -> Void in
                if error != nil {
                    // Could not authenticate.
                } else {
                    // Tokens successfully obtained!
                    
                    if let result = result as? [String : AnyObject] {
                        if let accessToken = result["access_token"] as? String {
                            let apiClient = Coinbase(oAuthAccessToken: accessToken)
                        }
                    }
                    // Note that you should also store 'expire_in' and refresh the token using CoinbaseOAuth.getOAuthTokensForRefreshToken() when it expires
                    
                }
                } as! CoinbaseCompletionBlock)
            return true
        }
        else {
            return false
        }
    }
    
    func setupPlaidLinkWithSharedConfiguration(){
        PLKPlaidLink.setup { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }
    }
    
    // With custom configuration
    func setupPlaidWithCustomConfiguration() {
        let linkConfiguration = PLKConfiguration(key: "8ea673842707bcd8f600508a10e315", env: .sandbox, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        PLKPlaidLink.setup(with: linkConfiguration) { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }
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
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

