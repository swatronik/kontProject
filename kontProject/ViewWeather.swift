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

class ViewWeather: UIViewController{

      @IBOutlet weak var temperature: UILabel?
      @IBOutlet weak var cityname: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        var realm = try! Realm()
        let results = realm.objects(inform.self)
        temperature!.text=results[results.endIndex-1].temp
        cityname!.text=results[results.endIndex-1].city
}



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
}
}
