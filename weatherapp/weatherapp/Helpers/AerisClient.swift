//
//  AerisClient.swift
//  weatherapp
//
//  Created by Edmund Holderbaum on 10/23/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation

final class AerisClient {
    private static let endpoint = "https://api.aerisapi.com/forecasts/newyork,ny?client_id=\(AerisID.accessID)&client_secret=\(AerisID.secretKey)"
    private static let session = URLSession.shared
    
    class func getTodaysForecast(completion: @escaping ([Forecast])->()) {
        guard let endpointURL = URL(string: endpoint) else {return}
        let urlRequest = URLRequest(url: endpointURL)
        let task = session.dataTask(with: urlRequest){ (data, response, error) in
            do {
                guard let data = data else {
                    print ("AerisClient received no data")
                    return
                }
                let sessionData = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = sessionData as? [String:Any],
                    let response = responseDict["response"] as? [[String:Any]],
                    let searchDict = response.first{
                    let forecasts = Forecast.makeFrom(json: searchDict)
                    completion(forecasts)
                } else {
                    print("could not unwrap JSON object")
                }
            } catch {
                print ("AerisClient could not serialize JSON")
            }
        }
        task.resume()
    }
}
