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


class UberController: UIViewController{
    

    var pickupLocation: CLLocationCoordinate2D!
    var pinLocation: CLLocationCoordinate2D!
    @IBOutlet weak var distanceLabel: UILabel!
    var length: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println(length)
        distanceLabel.text = Double(round(length * 0.000621371 * 1000)/1000).description + " miles"
    }
    
    @IBAction func UberRequest(sender: AnyObject) {
        var uber = Uber(pickupLocation: pickupLocation)
        uber.dropoffLocation = pinLocation
        uber.pickupLocation = pickupLocation
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