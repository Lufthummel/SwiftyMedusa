//
//  ViewController.swift
//  SwiftyMedusa
//
//  Created by Holger Kremmin on 19.08.16.
//  Copyright © 2016 Holger Kremmin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // ------------ Outlet connections
    @IBOutlet weak var listButton: RoundPushButtonView!
    
    // ------------ Class members
    var active = false
    
    // ------------ standard methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // ------------ Actions
    @IBAction func listenButtonPressed(_ sender: AnyObject) {
        print("pressed")
    }
}

