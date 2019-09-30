//
//  ExchangeRate.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation

class ExchangeRate: NSObject {
    var rates: Double?
    var fromAndToCurrencySymbol: String?
    
    init(fromAndToCurrencySymbol:String, rates:Double) {
        self.fromAndToCurrencySymbol = fromAndToCurrencySymbol
        self.rates = rates
    }
}
