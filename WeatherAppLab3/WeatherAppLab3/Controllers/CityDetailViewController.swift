//
//  CityDetailViewController.swift
//  WeatherAppLab3
//
//  Created by Nayan Goel on 12/15/17.
//  Copyright © 2017 NayanGoel. All rights reserved.
//
import Foundation
import UIKit

class CityDetailViewController: UIViewController{
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var mintemparature: UILabel!
    @IBOutlet weak var maxtemparature: UILabel!
    @IBOutlet weak var temparature: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!

    @IBOutlet weak var tableView: UITableView!
    var weatherData = WeatherDataModal()
    var items = ["1","2"]
    
    override func viewDidLoad() {
       super.viewDidLoad()
        print("djfakldjfaljfal")
        print(weatherData.currentCity)
        weatherData.downloadData(city: weatherData.currentCity, completed:{
           self.renderUI()
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderUI(){
        self.cityName.text = "\(self.weatherData.selectedlocation)"
        self.weatherDesc.text = self.weatherData.weatherstatus
        self.temparature.text = "\(self.weatherData.currenttemp)"
        self.mintemparature.text = "\(self.weatherData.mintemp)"
        self.maxtemparature.text = "\(self.weatherData.maxtemp)"
        self.date.text = self.weatherData.formatteddate
        
        var y = 220
        for i in WeatherDataModal.todaysweatherarr{
            let label = UILabel(frame: CGRect(x: 30, y: 0, width: self.ScrollView.frame.width, height: 80))
            y = y + 80
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            var fullNameArr = i.time.components(separatedBy: " ")
            label.center = CGPoint(x: 180, y: y)
            label.font = label.font.withSize(14)
            label.text = "   Time: "+fullNameArr[1]+"\n   Status: "+i.status+"\n   Temprature: "+i.temp
            self.ScrollView.addSubview(label)
        }
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: self.ScrollView.frame.width, height: 25))
        y = 220 + (WeatherDataModal.todaysweatherarr.count*80)+80
        label.center = CGPoint(x: 180, y: y)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "  Weekly Weather Data"
        print("weekly")
        self.ScrollView.addSubview(label)
        
        y = y+100
        for i in WeatherDataModal.otherdaysweatherarr{
            label = UILabel(frame: CGRect(x: 0, y: 0, width: self.ScrollView.frame.width-20, height: 150))
            label.center = CGPoint(x: 180, y: y)
            label.text = "  Time :"+String(i.time)+"\n  Temp: "+i.temp+"\n  Status: "+i.status+"\tMin Temp: "+i.mintemp+"\tMax Temp: "+i.maxtemp
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = label.font.withSize(14)
            self.ScrollView.addSubview(label)
            y = y + 150
            
        }
        self.ScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(y-100))
        
    }
    
}
