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
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // 1. ---> MOTION KIT FOR EASY ACCESS TO ACCELEROMETER DATA
    let motionKit = MotionKit() //only one instance should run at a time!!!
    let locationManager = CLLocationManager() // GPS data
    
    // location manager delegate will store data here
    var long: Double = 0.0
    var lat:Double = 0.0
    
    

        
    //just for demonstration
    var user: String = "" {
        didSet {
            print("User = \(user)")
        }
    }
    
    
    // ------------ Outlet connections
    @IBOutlet weak var accLabel: UILabel! //for demo only, display acc data
    @IBOutlet weak var listenButton: RoundPushButtonView!
    @IBOutlet weak var logoutButton: UIButton!


    var accY : Double = 0.0
    var accZ : Double = 0.0
    var accX : Double = 0.0 { //update the label
        didSet {
            OperationQueue.main.addOperation(){ //ensure that updates on UI from main thread only...
                self.accLabel.text = "x = \(self.accX.sf4) y = \(self.accY.sf4) z = \(self.accZ.sf4)"
            }

            
        }
    }
    
    // ------------ Class members
    var active = false
    
    
    
    // ------------ standard methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup location manager
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // get the accelerometer data
        
        
        
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // 2. --> SEE THE POWER OF SWIFT - JUST CODE THE COMPLETION HANDLER AND ALL ASYNC STUFF IS SOLVED!!!
        
        motionKit.getAccelerometerValues(0.1){
            (x, y, z) in
            //Interval is in seconds. And now you have got the x, y and z values here
            //self.accLabel.text = "x = \(x) y = \(y) z = \(z)"
            
            //we don't want to update the UI from background task
            self.accX = x
            self.accY = y
            self.accZ = z
            //check for accident...
            if ( (x > 1.5) || (y > 1.5) || (z > 1.5)) {
                print("x = \(x) y = \(y) z = \(z) lat = \(self.lat) long = \(self.long)")
                self.accidentHappened(x, y: y, z: z)
            }
        }
        
        self.logIn()
        
        // ######################################################################################################
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------ delegate for location service
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        long = location.coordinate.longitude
        print("long = \(long)")
        lat = location.coordinate.latitude
        
    }
    
    // !!!!!!  accident !!!!!
    
    
    
    func accidentHappened(_ x: Double, y:Double, z:Double) {
        
        //check if we are actice
        if (active) {
            //toogle active state to avoid that to many cases are created
            active = !active
            OperationQueue.main.addOperation(){
                self.listenButton.activity = !self.listenButton.activity
            }
            //create a case
            createCase(x,y: y,z: z, long: lat, lat: long)
            
            
        }
        
    }

    // MARK ACTION ------------ Actions
    
    @IBAction func listenButtonPressed(_ sender: AnyObject) {
        print("pressed")
        //viewCase()
        //createCase()
        //toogle state
        active = !active
        listenButton.activity = !listenButton.activity
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        
        if let app = UIApplication.shared.delegate as? LoginViewPresentable {
            print("logout...")
            app.logOut().then {
                () -> () in
                //TaskStore.sharedInstance.clear()
                //self.tableView.reloadData()
                return
            }
        }
    }
    
    
    // -------- Salesforce Integration ------
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // 3. --> SEE HOW EASY THE LOGIN PROCEDURE CAN BE ...
    // --> SEE PROMISEKIT AND CHAINING IN ACTION --> NEVER WORRY ABOUT ALL THE ASYNC STUFF, JUST CODE YOUR SEQUENCE
    
    //perform the OAuth2 dance...
    func logIn() -> Promise<String> {
        
        return Promise<String> {
            
            (fulfill, reject) -> () in
            
            if (user != "") {
                fulfill(user)
            } else {
                firstly {
                    SalesforceAPI.identity.request()
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
                        //print ("user = \(self.user)")
                        fulfill(self.user)
                        
                    }.catch { error in
                        print("ups")
                    }
            }
        }
    } //end func
    
    
    // ######################################################################################################
    
    
    
    
    
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // 4. AND FINALLY CREATE A CASE -  THATS ALL YOU NEED TO DO !!!
    
    // create the case...this is a very simple demonstration here
    func createCase(_ x: Double, y:Double, z:Double, long: Double, lat:Double) {
        
        let fields = ["Name": "All Eggs are broken", "hkr__Acc_X__c" : "\(x)", "hkr__Acc_Y__c": "\(y)", "hkr__Acc_Z__c" : "\(z)", "CurrencyIsoCode":"EUR", "hkr__Geo__Latitude__s" : "\(long)", "hkr__Geo__Longitude__s":"\(lat)" ]
        SalesforceAPI.createRecord(type: "hkr__DF_Case__c", fields: fields as [String : AnyObject]).request()
            .then {
                (result) -> () in
                // Update the local model
                print("result = \(result)")
            }.always {
                // Update the UI
                print("active state = \(self.active)")
            }.catch { error in
                print("ups \(error)")
        }
        print("case created")
    } //end func

    
    // ######################################################################################################
}



// just a test function
func viewCase() {
    let fields = ["Name", "hkr__Acc_X__c", "hkr__Acc_Y__c", "hkr__Acc_Z__c", "CurrencyIsoCode", "hkr__Geo__Latitude__s", "hkr__Geo__Longitude__s" ]
    
    SalesforceAPI.readRecord(type: "hkr__DF_Case__c", id: "a08o000000y6eT3AAI", fields: fields).request()
        .then {
            (json) -> () in
            print("json = \(json)")
        }.catch { error in
            print("ups \(error)")
    }
    
}


//extension for number formatting
// get Float or Double with 2 significant figure precision
var numberFormatter = NumberFormatter()
extension Float {
    var sf4:String {
        get {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.maximumSignificantDigits = 4
            return numberFormatter.string(from: NSNumber(value: self))!
        }
    }
}
extension Double {
    var sf4:String {
        get {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.maximumSignificantDigits = 4
            return numberFormatter.string(from: NSNumber(value: self))!
        }
    }
}
