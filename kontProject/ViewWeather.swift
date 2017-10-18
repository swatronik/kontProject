//
//  ViewWeather.swift
//  kontProject
//
//  Created by Admin on 16.10.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher


class ViewWeather: UIViewController,UIPageViewControllerDelegate{

      @IBOutlet weak var temperature: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityname: UILabel?
    @IBOutlet weak var errorInternet: UILabel!
    @IBOutlet weak var reboot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var realm = try! Realm()
        let results = realm.objects(inform.self)
        temperature!.text=results[results.endIndex-1].temp+" °C"
        cityname!.text=results[results.endIndex-1].city
        if prover(date1:results[results.endIndex-1].date,date2:NSDate()) {errorInternet.text="Error Internet!!!"}
        let url = URL(string: "http://openweathermap.org/img/w/\(results[results.endIndex-1].imageName).png")!
        let key:String = results[results.endIndex-1].imageName
        let resource = ImageResource(downloadURL: url, cacheKey: key)
        imageView.kf.setImage(with: resource)
        
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
}
}
