//
//  Dashboard.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation

class Dashboard: NSObject {
    let fromCurrency:Dictionary<String, String>?
    let toCurrency:Dictionary<String, String>?
    let fromRates  = 1
    var toRates = 0.0
    
    init(fromCurrency: Dictionary<String, String>, toCurrency: Dictionary<String, String>) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
    }
}
