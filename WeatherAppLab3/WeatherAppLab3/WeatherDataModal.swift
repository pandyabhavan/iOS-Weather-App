//
//  WeatherDataModal.swift
//  WeatherAppLab3
//
//  Created by Nayan Goel on 12/15/17.
//  Copyright © 2017 NayanGoel. All rights reserved.
//

import Foundation
import Alamofire

class WeatherDataModal {
    
    let apiurl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=4e31d2627a2363ee262996975cdaa62e")!

    typealias JSONStandard = Dictionary<String, AnyObject>
    private var _currenttemp: String?
    private var _maxtemp: String?
    private var _mintemp: String?
    private var _todaysdate: Double?
    private var _weatherstatus: String?
    private var _selectedlocation: String?
    
    
    var formatteddate: String {
        print("in date:String")
        let dateformatterobject = DateFormatter()
        dateformatterobject.timeStyle = .none
        dateformatterobject.dateStyle = .long
        let formatteddate = Date(timeIntervalSince1970: _todaysdate!)
        return (_todaysdate != nil) ? "Today, \(dateformatterobject.string(from: formatteddate))" : "Date Invalid"
    }
    
    var currenttemp: String {
        return _currenttemp ?? "0 °C"
    }
    
    var mintemp: String {
        return _mintemp ?? "0 °C"
    }
    
    var maxtemp: String {
        return _maxtemp ?? "0 °C"
    }
    
    var selectedlocation: String {
        return _selectedlocation ?? "Location Invalid"
    }
    
    var weatherstatus: String {
        return _weatherstatus ?? "Weather Invalid"
    }
    
    
    
    func downloadData(completed: @escaping ()-> ()) {
        
        Alamofire.request(apiurl).responseJSON(completionHandler: {
            response in
            let responseresult = response.result
            print("response recieved")
            print(responseresult)
            print("after result")
            if let resultdict = responseresult.value as? JSONStandard, let main = resultdict["main"] as? JSONStandard, let currenttemp = main["temp"] as? Double,let mintemp = main["temp_min"] as? Double,let maxtemp = main["temp_max"] as? Double, let fetchedweather = resultdict["weather"] as? [JSONStandard], let weatherstatus = fetchedweather[0]["main"] as? String, let cityname = resultdict["name"] as? String, let sys = resultdict["sys"] as? JSONStandard, let selectedcountry = sys["country"] as? String, let dt = resultdict["dt"] as? Double {
                
                self._selectedlocation = "\(cityname), \(selectedcountry)"
                self._mintemp = String(format: "%.0f °C", mintemp - 273.15)
                self._todaysdate = dt
                self._maxtemp = String(format: "%.0f °C", maxtemp - 273.15)
                self._weatherstatus = weatherstatus
                self._currenttemp = String(format: "%.0f °C", currenttemp - 273.15)
                
                
                
                
            }
            
            completed()
        })
    }
    
}
