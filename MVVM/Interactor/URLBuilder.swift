//
//  URLBuilder.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation

enum URLBuilder {
    
    static func getURL(forCountries countriesSymbol:[String]) -> URL? {
        if let firstCountry = countriesSymbol.first{
            var queryUrl = "/?pairs=\(firstCountry)&"
            for (index,country) in countriesSymbol.enumerated() where index != 0 && index != countriesSymbol.count - 1 {
                queryUrl.append("pairs=\(country)&")
            }
            if let country = countriesSymbol.last{
                queryUrl.append("pairs=\(country)")
            }
            let urlStr = Constants.EndPoint + queryUrl
            return URL(string: urlStr)
        }
        return nil
    }
}
