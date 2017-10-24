//
//  SettingsViewController.swift
//  weatherapp
//
//  Created by Edmund Holderbaum on 10/23/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var unitModeSelector: UISegmentedControl!
    var unitMode: UnitMode? = nil {
        didSet {
            if let unitMode = unitMode{
                UserDefaults.standard.set(unitMode.rawValue, forKey: "unitMode")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedMode = UserDefaults.standard.string(forKey: "unitMode") {
            self.unitMode = UnitMode.init(rawValue: savedMode)
        }
    }
    
    @IBAction func changeUnitMode() {
        switch self.unitModeSelector.selectedSegmentIndex {
        case 0:
            self.unitMode = .farenheit
        case 1:
            self.unitMode = .celsius
        default:
            break
        }
    }
}

enum UnitMode: String {
    case farenheit = "f"
    case celsius = "c"
}
