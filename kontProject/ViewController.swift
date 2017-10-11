//
//  ViewController.swift
//  kontProject
//
//  Created by Admin on 08.10.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import Alamofire


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local=locations[0]
        let kor:MKCoordinateSpan=MKCoordinateSpanMake(local.coordinate.latitude, local.coordinate.longitude)
        request("https://maps.googleapis.com/maps/api/geocode/json?latlng="+String(kor.latitudeDelta)+","+String(kor.longitudeDelta)+"&key=AIzaSyAPcYRscbExn3cRxo0olCIRWamc6dvV7hU").responseJSON{
            respons in
            if let result = respons.result.value{//address_components.long_name{
                let JSON=result as! NSDictionary
                print(JSON)
                
                }
            }
        }
            
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

