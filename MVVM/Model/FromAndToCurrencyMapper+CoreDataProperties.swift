//
//  FromAndToCurrencyMapper+CoreDataProperties.swift
//  Revolut
//
//  Created by Philips on 30/09/19.
//  Copyright © 2019 Prabhat. All rights reserved.
//
//

import Foundation
import CoreData


extension FromAndToCurrencyMapper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FromAndToCurrencyMapper> {
        return NSFetchRequest<FromAndToCurrencyMapper>(entityName: "FromAndToCurrencyMapper")
    }

    @NSManaged public var fromAndToCurrencySymbol: String?
    @NSManaged public var fromCurrency: Currency?
    @NSManaged public var toCurrency: Currency?

}
