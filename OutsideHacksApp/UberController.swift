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
    @IBOutlet weak var distanceLabel: UILabel!
    var length: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        distanceLabel.text = length.description + " meters"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}