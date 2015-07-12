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
    var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
    var Distance = 0.0
    var centeredFirst = false
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
        if(MKView.userLocation.location == nil){
            return
        }
        if droppedPin{
            Button1.setTitle("Drop Pin", forState: UIControlState.Normal)
            droppedPin = false
            MKView.removeAnnotations(MKView.annotations)
            Distance = 0.0
        }
        else{
            Button1.setTitle("Clear Pin", forState: UIControlState.Normal)
            droppedPin = true
            pointAnnotation.coordinate = MKView.userLocation.location.coordinate
            pointAnnotation.title = "Your Car"
            MKView.addAnnotation(pointAnnotation)
        }
    }
    
    func updateDistance() {
        if droppedPin{
            var request = MKDirectionsRequest()
            var source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(MKView.userLocation.location.coordinate.latitude, MKView.userLocation.location.coordinate.longitude), addressDictionary: nil))
            var destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(pointAnnotation.coordinate.latitude, pointAnnotation.coordinate.longitude), addressDictionary: nil))
            
            // source and destination are the relevant MKMapItems
            request.setSource(source)
            request.setDestination(destination)
            
            // Specify the transportation type
            request.transportType = MKDirectionsTransportType.Automobile;
            
            // If you're open to getting more than one route,
            // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
            request.requestsAlternateRoutes = false
            
            var directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler{(response, error) -> Void in

                self.Distance = response.routes.first!.distance
            }
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
        if let coordinate = MKView.userLocation.location?.coordinate{
            if !centeredFirst{
                let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
                MKView.setRegion(region, animated: true)
                centeredFirst = true
            }
            updateDistance()
        }
    }
    @IBAction func centerOnPin(sender: AnyObject) {
        if(droppedPin){
        var pin = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 500, 500)
        MKView.setRegion(pin, animated:true)
        }
    }
    
    @IBAction func centerOnUser(sender: AnyObject) {
        var userLoc = MKCoordinateRegionMakeWithDistance(MKView.userLocation.location.coordinate, 500, 500)
        MKView.setRegion(userLoc, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Detail"){
            var uvc: UberController = segue.destinationViewController as! UberController
            println(Distance)
            uvc.length = Distance
        }
    }
}

