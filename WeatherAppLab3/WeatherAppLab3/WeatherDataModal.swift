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
    
    public static var todaysweatherarr = [todaysweather]()
    public static var otherdaysweatherarr = [otherdaysweather]()
    
    var apiurl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=4e31d2627a2363ee262996975cdaa62e")!
    
    let forcasturl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=Delhi&appid=4e31d2627a2363ee262996975cdaa62e")!

    typealias JSONStandard = Dictionary<String, AnyObject>
    private var _currenttemp: String?
    private var _maxtemp: String?
    private var _mintemp: String?
    private var _todaysdate: Double?
    private var _weatherstatus: String?
    private var _selectedlocation: String?
    private var datetocompare: Date?
    
    typealias JSONStandardforcast = Dictionary<String, AnyObject>
    private var _currenttempforcast: String?
    private var _maxtempforcast: String?
    private var _mintempforcast: String?
    private var _todaysdateforcast: String?
    private var _weatherstatusforcast: String?
    private var _selectedlocationforcast: String?
    
    private static var _currentCity: String?
    
    var currentCity: String {
        return WeatherDataModal._currentCity ?? "Santa Clara"
    }
    public func setCurrentCity(city: String ) -> Void {
        WeatherDataModal._currentCity = city
    }
    
    
    
    var formatteddate: String {
        print("in date:String")
        let dateformatterobject = DateFormatter()
        dateformatterobject.timeStyle = .none
        dateformatterobject.dateStyle = .long
        let formatteddate = Date(timeIntervalSince1970: _todaysdate!)
        print("printing date")
        print(_todaysdate ?? "no date")
        print(formatteddate)
        datetocompare = formatteddate
        print("done printing date")
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
    
    
    
    var currenttempforcast: String {
        return _currenttempforcast ?? "0 °C"
    }
    
    var mintempforcast: String {
        return _mintempforcast ?? "0 °C"
    }
    
    var maxtempforcast: String {
        return _maxtempforcast ?? "0 °C"
    }
    
    var selectedlocationforcast: String {
        return _selectedlocation ?? "Location Invalid"
    }
    
    var weatherstatusforcast: String {
        return _weatherstatusforcast ?? "Weather Invalid"
    }
    
    
    
    
    func dateConverter(date:Double) -> Date {
        let dateformatterobject1 = DateFormatter()
        dateformatterobject1.timeStyle = .none
        dateformatterobject1.dateStyle = .long
        let formatteddate1 = Date(timeIntervalSince1970: date)
        return formatteddate1
    }
    
    func converteddatestring(date:Double) -> String {
        print("in date:String")
        let dateformatterobject = DateFormatter()
        dateformatterobject.timeStyle = .none
        dateformatterobject.dateStyle = .medium
        let formatteddate = Date(timeIntervalSince1970: date)
        print("printing date")
        print(date)
        print(formatteddate)
        print("done printing date")
        return "\(dateformatterobject.string(from: formatteddate))"
    }
    
    func downloadData(city:String, completed: @escaping ()-> ()) {
        apiurl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q="+city+"&appid=4e31d2627a2363ee262996975cdaa62e")!
        
        Alamofire.request(apiurl).responseJSON(completionHandler: {
            response in
            let responseresult = response.result
            print("response recieved 1")
            print(responseresult)
            print("after result 1")
            if let resultdict = responseresult.value as? JSONStandard, let main = resultdict["main"] as? JSONStandard, let currenttemp = main["temp"] as? Double,let mintemp = main["temp_min"] as? Double,let maxtemp = main["temp_max"] as? Double, let fetchedweather = resultdict["weather"] as? [JSONStandard], let weatherstatus = fetchedweather[0]["main"] as? String, let cityname = resultdict["name"] as? String, let sys = resultdict["sys"] as? JSONStandard, let selectedcountry = sys["country"] as? String, let dt = resultdict["dt"] as? Double {
                print("in if //////////////////////////")
                self._selectedlocation = "\(cityname), \(selectedcountry)"
                self._mintemp = String(format: "%.0f °C", mintemp - 273.15)
                self._todaysdate = dt
                self._maxtemp = String(format: "%.0f °C", maxtemp - 273.15)
                self._weatherstatus = weatherstatus
                self._currenttemp = String(format: "%.0f °C", currenttemp - 273.15)
                
                
                
                Alamofire.request(self.forcasturl).responseJSON(completionHandler: {
                    response in
                    let responseresult = response.result
                    print("response recieved 2")
                    print(responseresult)
                    print("after result 2")
                    
                    let resultdict1 = responseresult.value as? JSONStandard
                    if let resultlist1 = resultdict1!["list"] as? [JSONStandard]{
                        
                        var i = 0
                        while i <= resultlist1.count {
                            
                            let main1 = resultlist1[i]["main"] as? JSONStandard
                            let currenttemp1 = main1!["temp"] as? Double
                            let fetchedweather1 = resultlist1[i]["weather"] as? [JSONStandard]
                            let weatherstatus1 = fetchedweather1![0]["main"] as? String
                            let cityobj1 = resultdict1!["city"] as? JSONStandard
                            let cityname1 = cityobj1!["name"] as? String
                            let selectedcountry1 = cityobj1!["country"] as? String
                            let dt1 = resultlist1[i]["dt"] as? Double
                            let stringfirstdate = resultlist1[0]["dt_txt"] as? String
                            let stringdt1 = resultlist1[i]["dt_txt"] as? String
                            let mintemp1 = main1!["temp_min"] as? Double
                            let maxtemp1 = main1!["temp_max"] as? Double
                            
                            let index1 = stringfirstdate?.index((stringfirstdate?.startIndex)!, offsetBy: 8)
                            let index2 = stringfirstdate?.index((stringfirstdate?.startIndex)!, offsetBy: 9)
                            var todayday = ""
                            todayday.append(stringfirstdate![index1!])
                            todayday.append(stringfirstdate![index2!])
                            let inttodayday = Int(todayday)
                          let index3 = stringdt1?.index((stringdt1?.startIndex)!, offsetBy: 8)
                            let index4 = stringdt1?.index((stringdt1?.startIndex)!, offsetBy: 9)
                            var otherday = ""
                            otherday.append(stringdt1![index3!])
                            otherday.append(stringdt1![index4!])
                            let intotherday = Int(otherday)
                            let actualdate = self.dateConverter(date: dt1!)
                            let dummydate = self.dateConverter(date: 1513731366)
                            
                            let stringactualdate = self.converteddatestring(date: dt1!)
                            if inttodayday==intotherday{
                        WeatherDataModal.todaysweatherarr.append(todaysweather(status:weatherstatus1!, temp: String(describing: currenttemp1), time: stringdt1!))
                                
                            }
                            else{
                                i = i + 8;       WeatherDataModal.otherdaysweatherarr.append(otherdaysweather(status:weatherstatus1!, temp: String(describing: currenttemp1), time: stringdt1!, mintemp: String(describing: currenttemp1), maxtemp: String(describing: currenttemp1)))
                            }
                            print("out of if")
                            i = i + 1
                        }
                    }
                    

                    print("done printing")
                    
                   
                    
                    
                    if let resultdict1 = responseresult.value as? JSONStandard,let resultlist1 = resultdict1["list"] as? [JSONStandard], let main1 = resultlist1[0]["main"] as? JSONStandard, let currenttemp1 = main1["temp"] as? Double,let mintemp1 = main1["temp_min"] as? Double,let maxtemp1 = main1["temp_max"] as? Double, let fetchedweather1 = resultlist1[0]["weather"] as? [JSONStandard], let weatherstatus1 = fetchedweather1[0]["main"] as? String, let cityobj1 = resultdict1["city"] as? JSONStandard, let cityname1 = cityobj1["name"] as? String, let selectedcountry1 = cityobj1["country"] as? String, let dt = resultlist1[0]["dt"] as? Double {
                        
                        print("in if...................")
                        self._selectedlocationforcast = "\(cityname1), \(selectedcountry1)"
                        self._mintempforcast = String(format: "%.0f °C", mintemp1 - 273.15)
                        self._maxtempforcast = String(format: "%.0f °C", maxtemp1 - 273.15)
                        self._weatherstatusforcast = weatherstatus1
                        print("weather status= ")
                        print(weatherstatus1)
                        self._currenttempforcast = String(format: "%.0f °C", currenttemp1 - 273.15)
                    }
                    
                    
                    
                    completed()
                })
                
                
                
                
                
            }
            
        })
        
        
        
       
        
        
        
    }
    
}
