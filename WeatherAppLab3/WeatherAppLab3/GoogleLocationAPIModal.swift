//
//  GoogleLocationAPIModal.swift
//  WeatherAppLab3
//
//  Created by admin on 12/18/17.
//  Copyright © 2017 NayanGoel. All rights reserved.
//

import Foundation
import Alamofire

class GoogleLocationAPIModal {

    typealias JSONStandard = Dictionary<String, AnyObject>
    var cities = [String]()
    
    func downloadData( searchText: inout String,completed: @escaping ()-> ()) {
        cities = [String]()
        searchText = searchText.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let apiurl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="+searchText+"&types=(cities)&key=AIzaSyDomo3DBvhJ-twCGME4mjqN7QxoIQY-x-w"
        
        Alamofire.request(apiurl).responseJSON(completionHandler: {
            response in
            let responseresult = response.result
       let resultdict = responseresult.value as? JSONStandard
            
            let main = resultdict!["predictions"] as? [JSONStandard]
            for city in main!
            {
                self.cities.append(city["description"] as! String)
            }
            completed()
        })
    }
}
