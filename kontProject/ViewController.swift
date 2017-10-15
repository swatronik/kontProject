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

class inform: Object {
    @objc dynamic var city = ""
    @objc dynamic var temp = ""
    @objc dynamic var id = 0
    @objc dynamic var imageName = ""
    @objc dynamic var date = NSDate()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var realm = try! Realm()
    var city:String=""
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let results = self.realm.objects(inform.self)
        if ((results.first != nil)){
            if((prover(date1: results[results.endIndex-1].date,date2: NSDate()))){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        let local=location?.coordinate
        StartWeather(latitude: local!.latitude,longitude: local!.longitude)
            }else{print("5 minut!!")}
            
        }else{ locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        let local=location?.coordinate
        StartWeather(latitude: local!.latitude,longitude: local!.longitude)}
    }
    
    func prover(date1:NSDate,date2:NSDate)->Bool{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        var dateString1 = dateFormatter1.string(from: date1 as Date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = .short
        var dateString2 = dateFormatter2.string(from: date2 as Date)
        
        if(dateString1 == dateString2){
            dateFormatter1.dateFormat = "hh"
            dateString1 = dateFormatter1.string(from: date1 as Date)
            var mm1:Int=Int(dateString1)!*60
            dateFormatter1.dateFormat = "mm"
            dateString1 = dateFormatter1.string(from: date1 as Date)
            mm1=mm1+Int(dateString1)!
            dateFormatter2.dateFormat = "hh"
            dateString2 = dateFormatter2.string(from: date2 as Date)
            var mm2:Int=Int(dateString2)!*60
            dateFormatter2.dateFormat = "mm"
            dateString2 = dateFormatter2.string(from: date2 as Date)
            mm2=mm2+Int(dateString2)!
            if(mm2-mm1>5){return true}
            else {return false}
        }else{return true}
        
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
                let temp = swiftyJsonVar2["main","temp"].rawString()!
                print(temp)
                let icon = swiftyJsonVar2["weather",0,"icon"].rawString()!
                print (icon)
                var inform1 = inform()
                print("sucsess")
                let results = self.realm.objects(inform.self)
                try! self.realm.write {
                    inform1.city = self.city
                    inform1.date = NSDate()
                    inform1.imageName=icon
                    inform1.temp = temp
                    inform1.id=results.count
                    self.realm.add(inform1)
                }
            print("sucsess")
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

