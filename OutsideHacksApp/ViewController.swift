//
//  ViewController.swift
//  OutsideHacksApp
//
//  Created by Neil Tu on 7/11/15.
//  Copyright (c) 2015 icebrg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    var droppedPin = false
    @IBOutlet weak var MKView: MKMapView!
    @IBOutlet weak var Button1: UIButton!
    
    let locationManager = CLLocationManager()
    var currentLocation = Location()
    var uberProductID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MKView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        MKView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    @IBAction func DropPin(sender: AnyObject) {
        if droppedPin{
            Button1.setTitle("Drop Pin", forState: UIControlState.Normal)
            droppedPin = false
            MKView.removeAnnotations(MKView.annotations)
        }
        else{
            Button1.setTitle("Clear Pin", forState: UIControlState.Normal)
            droppedPin = true
            var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = MKView.userLocation.location.coordinate
            pointAnnotation.title = "Your car"
            MKView.addAnnotation(pointAnnotation)
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if let coordinate = MKView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
            MKView.setRegion(region, animated: true)
        }
    }
    
    //Get user's current location
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:[AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        currentLocation.latitude = Float(locValue.latitude)
        currentLocation.longitude = Float(locValue.longitude)
    }
    
    func getUberProducts() {
        
        println("Current latitude = \(currentLocation.latitude)")
        println("Current longitude = \(currentLocation.longitude)")
        
        // Get Product IDs from Uber based on current location
        let uberServerToken = "wUN_PI-fsGxaAHUHlyvQtBvcOKq2g0SnTa6pk-h6"
        let urlPath = "https://api.uber.com/v1/products?latitude=\(currentLocation.latitude)&longitude=\(currentLocation.longitude)"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: url!)
        request.setValue("Token \(uberServerToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if (error != nil) {
                println(error)
            }
            else {
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                self.uberProductID = jsonResult["products"]?[0]["product_id"] as! NSString as String
            }
        })
        task.resume()
    }
}

