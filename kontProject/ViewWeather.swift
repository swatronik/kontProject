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
        if results[results.endIndex-1].error {errorInternet.text="Error Internet!!!"}
        let url = URL(string: "http://openweathermap.org/img/w/\(results[results.endIndex-1].imageName).png")!
        let key:String = results[results.endIndex-1].imageName
        let resource = ImageResource(downloadURL: url, cacheKey: key)
        imageView.kf.setImage(with: resource)
        
}



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
}
}
