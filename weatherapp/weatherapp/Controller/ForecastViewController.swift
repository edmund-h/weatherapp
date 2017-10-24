//
//  ViewController.swift
//  weatherapp
//
//  Created by Edmund Holderbaum on 10/23/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import UIKit

class ForecastViewController: UITableViewController {

    var forecasts: [Forecast] = [] {
        didSet {
            DispatchQueue.main.async {
                if let savedMode = UserDefaults.standard.string(forKey: "unitMode"){
                    self.unitMode = UnitMode(rawValue:savedMode)
                }
                self.tableView.reloadData()
            }
        }
    }
    var unitMode: UnitMode? = nil
    
    let dateFormatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter.dateFormat = "MMMM dd"
        
        AerisClient.getTodaysForecast(completion: { forecasts in
            print("got \(forecasts.count) forecasts!")
            forecasts.forEach({ myForecast in
                print("\(myForecast.date.description): \(myForecast.minTempF)-\(myForecast.maxTempF)")
            })
            self.forecasts = forecasts
        })
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastTableViewCell
        let myForecast = forecasts[indexPath.row]
        if let myImg = UIImage(named: myForecast.icon) {
            cell.icon.image = myImg
        }
        cell.dateLabel.text = dateFormatter.string(from: myForecast.date)
        let tempText = makeTempStrings(from: myForecast)
        cell.highLabel.text = tempText.0
        cell.lowLabel.text = tempText.1
        return cell
    }
    
    func makeTempStrings(from forecast: Forecast)->(String, String) {
        var high: String
        var low: String
        if unitMode == .celsius {
            high = "High: \(forecast.maxTempC)"
            low = "Low: \(forecast.minTempC)"
        } else {
            high = "High: \(forecast.maxTempF)"
            low = "Low: \(forecast.minTempF)"
        }
        return (high, low)
    }
}

