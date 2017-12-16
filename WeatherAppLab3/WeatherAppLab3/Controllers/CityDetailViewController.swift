//
//  CityDetailViewController.swift
//  WeatherAppLab3
//
//  Created by Nayan Goel on 12/15/17.
//  Copyright © 2017 NayanGoel. All rights reserved.
//

import Foundation
import UIKit

class CityDetailViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var temparature: UILabel!
    @IBOutlet weak var date: UILabel!
    var weatherData = WeatherDataModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherData.downloadData {
            self.renderUI()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderUI(){
        cityName.text = weatherData.location
        weatherDesc.text = weatherData.weather
        temparature.text = "\(weatherData.temp)"
        date.text = weatherData.date
        
    }
    
}
