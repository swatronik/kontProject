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
import RealmSwift
import ObjectMapper

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    var city:String=""
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        let local=location?.coordinate
        //dateFormatter()
        StartWeather(latitude: local!.latitude,longitude: local!.longitude)
    }
    
    func dateFormatter(){
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        var dateString = dateFormatter.string(from: date as Date)
        print(dateString)
        dateFormatter.dateFormat = "hh mm"
        dateString = dateFormatter.string(from: date as Date)
        print(dateString)
        //Custom Date Format Sample 2 28-Feb-2016 11:41:51
    }
    
    func safe( str1:inout String,str2:inout String){
        str1=str2
    }
    
    func StartWeather(latitude:Double,longitude:Double) {
        let url:String="https://maps.googleapis.com/maps/api/geocode/json?latlng="+String(latitude)+","+String(longitude)+"&key=AIzaSyAPcYRscbExn3cRxo0olCIRWamc6dvV7hU"
        var city:String=""
        request(url,method:.get).responseJSON{
            respons in
            let swiftyJsonVar = JSON(respons.result.value!)
            var resData:String = swiftyJsonVar["results",1,"address_components",1,"long_name"].rawString()!
            self.safe(str1: &city,str2: &resData)
            self.GetWeather(city: city)
        }

    }
    
    func GetWeather(city:String){
        if city==""{print("error")}
        else{
            let url:String="https://api.openweathermap.org/data/2.5/weather?q="+city.replacingOccurrences(of: " ", with: "")+"&units=metric&APPID=6f60a2e2eba0ac6d5868f11ba9b8c10b"
            request(url).responseJSON{
                respons2 in
                let swiftyJsonVar2 = JSON(respons2.result.value)
                let temp = swiftyJsonVar2["main","temp"]
                print(temp)
                let icon = swiftyJsonVar2["weather",0,"icon"]
                print (icon)
            
            }
        }
    }
    
   /*
     http://openweathermap.org/img/w/10d.png
     
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

    }*/

            
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

