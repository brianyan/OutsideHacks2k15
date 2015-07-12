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
            Button1.setTitle("Clear Pin", forState: UIControlState.Normal)
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
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control == annotationView.rightCalloutAccessoryView{
            performSegueWithIdentifier("Detail", sender: self)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        
        if annotation.isKindOfClass(MKUserLocation.self) {
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        if(pinView == nil){
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            var calloutButton = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            pinView!.rightCalloutAccessoryView = calloutButton
        }
        else{
            pinView!.annotation = annotation
        }
        return pinView!
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if let coordinate = MKView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
            MKView.setRegion(region, animated: true)
        }
    }
    
}

