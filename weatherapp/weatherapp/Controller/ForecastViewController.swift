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
                self.tableView.reloadData()
            }
        }
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.highLabel.text = "High: \(myForecast.maxTempF)"
        cell.lowLabel.text = "Low: \(myForecast.minTempF)"
        return cell
    }
}

