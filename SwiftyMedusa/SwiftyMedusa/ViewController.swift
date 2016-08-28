//
//  ViewController.swift
//  SwiftyMedusa
//
//  Created by Holger Kremmin on 19.08.16.
//  Copyright © 2016 Holger Kremmin. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import SwiftlySalesforce
import SafariServices
import PromiseKit


class ViewController: UIViewController {
    
    var user: String = "" /*{
        didSet {
            print("User = \(user)")
        }
    }
    */
    
    // ------------ Outlet connections
    @IBOutlet weak var listenButton: RoundPushButtonView!
    @IBOutlet weak var logoutButton: UIButton!

    
    // ------------ Class members
    var active = false
    
    
    
    // ------------ standard methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
       
        let motionKit = MotionKit()
        motionKit.getAccelerometerValues(0.1){
            (x, y, z) in
            //Interval is in seconds. And now you have got the x, y and z values here
            //print("x = \(x) y = \(y) z = \(z)")
        }
        
        self.logIn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // ------------ Actions
    
    @IBAction func listenButtonPressed(sender: AnyObject) {
        print("pressed")
        viewCase()
        createCase()
        listenButton.activity = !listenButton.activity
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
        if let app = UIApplication.sharedApplication().delegate as? LoginViewPresentable {
            print("logout...")
            app.logOut().then {
                () -> () in
                //TaskStore.sharedInstance.clear()
                //self.tableView.reloadData()
                return
            }
        }
    }
    
    
    // -------- Salesforce ------
    
    //perform the OAuth2 dance...
    func logIn() -> Promise<String> {
        
        return Promise<String> {
            
            (fulfill, reject) -> () in
            
            if (user != "") {
                fulfill(user)
            } else {
                firstly {
                    SalesforceAPI.Identity.request()
                    }.then {
                        // Get user ID
                        (identityInfo) -> String in
                        guard let userID = identityInfo["user_id"] as? String else {
                            throw NSError(domain: "TaskForce", code: -100, userInfo: nil)
                        }
                        return userID
                    }.then {
                        // Query tasks owned by user
                        (userID) ->  () in
                        self.user = userID
                        print ("user = \(self.user)")
                        fulfill(self.user)
                        
                    }.error { error in
                        print("ups")
                    }
            }
        }
    } //end func
    
    func viewCase() {
        let fields = ["Name", "hkr__Acc_X__c", "hkr__Acc_Y__c", "hkr__Acc_Z__c", "CurrencyIsoCode", "hkr__Geo__Latitude__s", "hkr__Geo__Longitude__s" ]
        
            SalesforceAPI.ReadRecord(type: "hkr__DF_Case__c", id: "a08o000000y6eT3AAI", fields: fields).request()
                .then {
                    (json) -> () in
                    print("json = \(json)")
                }.error { error in
                    print("ups \(error)")
                }

    }
    
    func createCase() {
        
        let fields = ["Name": "Eggs broken", "hkr__Acc_X__c" : "1.00", "hkr__Acc_Y__c": "0.00", "hkr__Acc_Z__c" : "0.5", "CurrencyIsoCode":"EUR", "hkr__Geo__Latitude__s" : "0", "hkr__Geo__Longitude__s":"0" ]
        SalesforceAPI.CreateRecord(type: "hkr__DF_Case__c", fields: fields).request()
            .then {
                (result) -> () in
                // Update the local model
                print("result = \(result)")
            }.always {
                // Update the UI
            }.error { error in
                print("ups \(error)")
        }
        print("case created")
    } //end func

}
