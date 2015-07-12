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
    var firstDistance = false
    
    @IBOutlet weak var MKView: MKMapView!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Distance: UILabel!
    
    
    
    
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
    var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
    @IBAction func DropPin(sender: AnyObject) {
        if droppedPin{
            Button1.setTitle("Drop Pin", forState: UIControlState.Normal)
            firstDistance = false
            Distance.text = "N/A"
            droppedPin = false
            MKView.removeAnnotations(MKView.annotations)
            
        }
        else{
            Button1.setTitle("Clear Pin", forState: UIControlState.Normal)
            droppedPin = true
       
            pointAnnotation.coordinate = MKView.userLocation.location.coordinate
            pointAnnotation.title = "Your car"
            MKView.addAnnotation(pointAnnotation)
            firstDistance = true
            updateDistance()
        }
    }

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if let coordinate = MKView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
            MKView.setRegion(region, animated: true)
            updateDistance()
            
        }
    }
    func updateDistance() {
        if firstDistance {
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

                self.Distance.text = response.routes.first?.distance.description
            }
        }
    }
    
    
    
    
}
//The MKUserLocation class defines a specific type of annotation that identifies the user’s current location.



