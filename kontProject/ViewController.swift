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

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


class inform: Object {
    @objc dynamic var city = ""
    @objc dynamic var temp = ""
    @objc dynamic var id = 0
    @objc dynamic var imageName = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var error = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var cirleloading: UIActivityIndicatorView!
    var proverkaNull=0
    
    var city:String=""
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        cirleloading.startAnimating()
        let results = realm.objects(inform.self)
        if Connectivity.isConnectedToInternet() {print ("Internet")} else {print("NO Internet")}
        if ((results.first != nil)){
            if((prover(date1: results[results.endIndex-1].date,date2: NSDate())) && Connectivity.isConnectedToInternet()){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        let local=location?.coordinate
        StartWeather(latitude: local!.latitude,longitude: local!.longitude)
            }else { endScreen()}
            
        }else{
        proverkaNull=1
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        let local=location?.coordinate
        StartWeather(latitude: local!.latitude,longitude: local!.longitude)}
    }
    
    func saveError(){
        let realm = try! Realm()
        let results = realm.objects(inform.self)
        let inform1 = inform()
        try! realm.write {
            inform1.city = results[results.endIndex-1].city
            inform1.date = results[results.endIndex-1].date
            inform1.imageName=results[results.endIndex-1].imageName
            inform1.temp = results[results.endIndex-1].temp
            inform1.id=results[results.endIndex-1].id
           inform1.error=true
            realm.add(inform1)
        }
        self.endScreen()
    }

     func endScreen(){
        performSegue(withIdentifier: "ViewWeatherSegue", sender: self)
    }

    func errorScreen(){
        performSegue(withIdentifier: "Warning", sender: self)
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
            if(abs(mm2-mm1)>5){return true}
            else {return false}
        }else{return true}
        
    }
    
    func safe( str1:inout String,str2:inout String){
        str1=str2
    }
    
    func StartWeather(latitude:Double,longitude:Double) {
        let url:String="https://maps.googleapis.com/maps/api/geocode/json?latlng="+String(latitude)+","+String(longitude)+"&key=AIzaSyAPcYRscbExn3cRxo0olCIRWamc6dvV7hU"
        var city:String=""
        var ind:Int=0
        request(url,method:.get).responseJSON{
            respons in
            ind=1;
            let swiftyJsonVar = JSON(respons.result.value!)
            var resData:String = swiftyJsonVar["results",1,"address_components",1,"long_name"].rawString()!
            self.safe(str1: &city,str2: &resData)
            self.GetWeather(city: city)
            }
        if proverkaNull==1{errorScreen()}
        else {saveError()}
    }
    
    func GetWeather(city:String){
            let url:String="https://api.openweathermap.org/data/2.5/weather?q="+city.replacingOccurrences(of: " ", with: "")+"&units=metric&APPID=6f60a2e2eba0ac6d5868f11ba9b8c10b"
            request(url).responseJSON{
                respons2 in
                let swiftyJsonVar2 = JSON(respons2.result.value!)
                let temp = swiftyJsonVar2["main","temp"].rawString()!
                let icon = swiftyJsonVar2["weather",0,"icon"].rawString()!
                let inform1 = inform()
                let realm = try! Realm()
                let results = realm.objects(inform.self)
                try! realm.write {
                    inform1.city = city
                    inform1.date = NSDate()
                    inform1.imageName=icon
                    inform1.temp = temp
                    inform1.id=results.count
                    inform1.error=false
                    realm.add(inform1)
                }
                self.cirleloading.stopAnimating()
                self.endScreen()
            }
        saveError()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

