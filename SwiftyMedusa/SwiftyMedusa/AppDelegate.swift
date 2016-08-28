//
//  AppDelegate.swift
//  SwiftyMedusa
//
//  Created by Holger Kremmin on 19.08.16.
//  Copyright © 2016 Holger Kremmin. All rights reserved.
//

import UIKit
import SwiftlySalesforce


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewPresentable {
    
    /// Salesforce Connected App settings
    let consumerKey = "3MVG9xOCXq4ID1uFuYvTJhxH5YIs0UiyLpItj_4X40YEU4tHkL2Ysrh5uh3C41x0IbBr2M3mAPzFzX4bWUZ2T"
    let redirectURL = NSURL(string: "sfdc://authorized")!
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Configure the Salesforce authentication manager with Connected App settings
        OAuth2Manager.sharedInstance.configureWithConsumerKey(consumerKey, redirectURL: redirectURL)
        OAuth2Manager.sharedInstance.authenticationDelegate = self
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        handleRedirectURL(url)
        return true
    }
}