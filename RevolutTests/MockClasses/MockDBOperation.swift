//
//  MockDBOperation.swift
//  RevolutTests
//
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
import CoreData
@testable import Revolut


class MockDBOperation: DBOperation {
    var fromAndToCurrencySymbol = "fakeFromToSymbol"
    var fromCurrencySymbol = "fakeFromSymbol"
    var fromCountry = "fakeFromCountry"
    var fromFlagImage = "fakeFromFlagImage"
    
    var toCurrencySymbol = "fakeToSymbol"
    var toCountry = "fakeToCountry"
    var toFlagImage = "fakeToFlagImage"
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Revolut")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false //
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override init() {
        super.init()
        super.persistentContainer = mockPersistantContainer
    }
    
    func saveFromToCurrencyMapper(){
        let context = mockPersistantContainer.viewContext
        let fromCurrency = Currency(symbol: fromCurrencySymbol, country: fromCountry, flagImage: fromFlagImage)
        let toCurrency = Currency(symbol: toCurrencySymbol, country: toCountry, flagImage: toFlagImage)
        if let entity = NSEntityDescription.entity(forEntityName: "FromAndToCurrencyMapper", in: context){
            let newEntity = NSManagedObject(entity: entity, insertInto: context)
            newEntity.setValue(fromCurrency, forKey: "fromCurrency")
            newEntity.setValue(toCurrency, forKey: "toCurrency")
            newEntity.setValue(fromAndToCurrencySymbol, forKey: "fromAndToCurrencySymbol")
            do {
                try context.save()
            } catch {
            }
        }
    }
    
    func cleanDB(){
        let context =  mockPersistantContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FromAndToCurrencyMapper")
        deleteFetch.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(deleteFetch)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch{}
    }
    
    override func fetchData(forTheEntity entity: String, completion: @escaping (([Any]?) -> ())) {
        saveFromToCurrencyMapper()
        let context = mockPersistantContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FromAndToCurrencyMapper")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch {
            completion(nil)
        }
    }
    
    override func getNewEntity(forTable name: String) -> NSManagedObject? {
        let context = persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: name, in: context){
            let newEntity = NSManagedObject(entity: entity, insertInto: context)
            return newEntity
        }
        return nil
    }
}
