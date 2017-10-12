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
import SwiftyJSON

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    static var longitudeG:CLLocationDegrees!
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
        let url:String="https://maps.googleapis.com/maps/api/geocode/json?latlng="+String(kor.latitudeDelta)+","+String(kor.longitudeDelta)+"&key=AIzaSyAPcYRscbExn3cRxo0olCIRWamc6dvV7hU"
        request(url).responseJSON{
            respons in
            let swiftyJsonVar = JSON(respons.result.value!)
            let resData = swiftyJsonVar["results",1,"address_components",1,"long_name"].rawString()
         //   let url2:String="api.openweathermap.org/data/2.5/weather?q="+resData!+"&units=metric&APPID=6f60a2e2eba0ac6d5868f11ba9b8c10b"
         //   request(url2).responseJSON{
         //      respons2 in
         //       let swiftyJsonVar2 = JSON(respons2.result.value!)
           //     let resData2 = swiftyJsonVar2["main"]
          //     print(swiftyJsonVar2)
          //  }
        }

    }

            
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

