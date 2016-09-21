//
//  AppDelegate.swift
//  SwiftyMedusa
//
//  Created by Holger Kremmin on 19.08.16.
//  Copyright © 2016 Holger Kremmin. All rights reserved.
//

import UIKit
import SwiftlySalesforce
import XCGLogger


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewPresentable {

    let logger = XCGLogger.default
    
    /// Salesforce Connected App settings
    let consumerKey = "3MVG9xOCXq4ID1uFuYvTJhxH5YIs0UiyLpItj_4X40YEU4tHkL2Ysrh5uh3C41x0IbBr2M3mAPzFzX4bWUZ2T"
    let redirectURL = URL(string: "sfdc://authorized")!
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        logger.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
        // Configure the Salesforce authentication manager with Connected App settings
        OAuth2Manager.sharedInstance.configureWithConsumerKey(consumerKey, redirectURL: redirectURL)
        OAuth2Manager.sharedInstance.authenticationDelegate = self
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        handleRedirectURL(url)
        return true
    }
}
