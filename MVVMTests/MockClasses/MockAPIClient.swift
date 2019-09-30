//
//  MockAPIClient.swift
//  RevolutTests
//
//  Created by Philips on 25/09/19.
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
@testable import Revolut

class MockAPIClient: ApiClientProtocol {
    var countryCurrencyModel : Currency!
    var key:String = ""
    func fetchCurrencyListWithCountryName(completion: @escaping (Bool, [Currency], Error?) -> Void) {
        completion(true,[countryCurrencyModel],nil)
    }
    
    func fetchExchangeRates(forCountries countries: [String], completion: @escaping (Bool, [ExchangeRate], Error?) -> Void) {
        let exchangeRate = ExchangeRate(fromAndToCurrencySymbol: key, rates: 1.234)
        completion(true,[exchangeRate],nil)
    }
}
