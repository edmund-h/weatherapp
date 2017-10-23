//
//  Forecast.swift
//  weatherapp
//
//  Created by Edmund Holderbaum on 10/23/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation

struct Forecast {
    
    let date: Date
    let maxTempF: Int
    let maxTempC: Int
    let minTempF: Int
    let minTempC: Int
    let icon: String
    
    enum Values: String {
        case date = "dateTimeISO"
        case maxTempF = "maxTempF"
        case maxTempC = "maxTempC"
        case minTempF = "minTempF"
        case minTempC = "minTempC"
        case icon = "icon"
    }
    
    static func makeFrom(json: [String:Any])->[Forecast]{
        var output: [Forecast] = []
        guard let periods = json["periods"] as? [[String:Any]] else {
            print ("error: could not get periods")
            return []
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        periods.forEach({ forecastDict in
            if let dictDateStr = forecastDict[Values.date.rawValue] as? String,
                let dictDate = dateFormatter.date(from: dictDateStr),
                let dictMaxTempF = forecastDict[Values.maxTempF.rawValue] as? Int,
                let dictMaxTempC = forecastDict[Values.maxTempC.rawValue] as? Int,
                let dictMinTempF = forecastDict[Values.minTempF.rawValue] as? Int,
                let dictMinTempC = forecastDict[Values.minTempC.rawValue] as? Int,
                let dictIconStr = forecastDict[Values.icon.rawValue] as? String,
                let dictIcon = dictIconStr.components(separatedBy: ".").first{
                    let myForecast = Forecast(
                        date: dictDate,
                        maxTempF: dictMaxTempF,
                        maxTempC: dictMaxTempC,
                        minTempF: dictMinTempF,
                        minTempC: dictMinTempC,
                        icon: dictIcon)
                    output.append(myForecast)
            }
        })
        return output
    }
}
