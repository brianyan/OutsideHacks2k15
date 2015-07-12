//
//  UberController.swift
//  OutsideHacksApp
//
//  Created by Neil Tu on 7/11/15.
//  Copyright (c) 2015 icebrg. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import OAuth2


class UberController: UIViewController{
    
    var oauth2 = OAuth2CodeGrant(settings:[
        "client_id": "Q6Clz-da6gMYJ68LQ-kYW10R48CJs0fV",
        "client_secret": "mtospXdKp0dyiD4h4fztNKTSInsfpGgfdvf0Qdrf",
        "authorize_uri": "https://login.uber.com/oauth/authorize",
        "token_uri": "wUN_PI-fsGxaAHUHlyvQtBvcOKq2g0SnTa6pk-h6",
        "redirect_uris": ["OutsideHacksApp://oauth/callback"],
        "keychain": false
        ])
    @IBOutlet weak var distanceLabel: UILabel!
    var length: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println(length)
        distanceLabel.text = Double(round(length * 0.000621371 * 1000)/1000).description + " miles"
    }
    
    @IBAction func UberRequest(sender: AnyObject) {
        var pickupLocation = MKView.userLocation.location.coordinate
        var uber = Uber(pickupLocation: pickupLocation)
        uber.deepLink()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}