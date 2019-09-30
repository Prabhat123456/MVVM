//
//  Currency.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation

class Currency: NSObject,NSCoding {
    var symbol: String?
    var country: String?
    var flagImage: String?
    var isDisabled = false
    
    enum Key:String {
        case symbol = "symbol"
        case country = "country"
        case flagImage = "flagImage"
        case isDisabled = "isDisabled"
    }
    
    init(symbol:String,country:String,flagImage:String) {
        self.symbol = symbol
        self.country = country
        self.flagImage = flagImage
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(symbol, forKey: Key.symbol.rawValue)
        aCoder.encode(country, forKey: Key.country.rawValue)
        aCoder.encode(flagImage, forKey: Key.flagImage.rawValue)
        aCoder.encode(isDisabled, forKey: Key.isDisabled.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let symbol = aDecoder.decodeObject(forKey: Key.symbol.rawValue) as? String,
            let country = aDecoder.decodeObject(forKey: Key.country.rawValue) as? String,
            let flagImage = aDecoder.decodeObject(forKey: Key.flagImage.rawValue) as? String
            else {
                return nil
        }
        self.init(symbol: symbol, country: country, flagImage: flagImage)
        self.isDisabled = aDecoder.decodeBool(forKey: Key.isDisabled.rawValue)
    }
}
