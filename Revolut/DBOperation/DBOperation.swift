//
//  DBOperation.swift
//  Revolut
//
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
import CoreData

class DBOperation {
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: Constants.DBName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
   
    init(persistentContainer:NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    init() {}
    
    
    // MARK: - Core Data Saving support
    
    
    func fetchData(forTheEntity entity:String,completion: @escaping (([Any]?)->())) {
        let context = persistentContainer.viewContext
        context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                completion(result)
            } catch {
                completion(nil)
            }
        }
    }
    
    func getNewEntity(forTable name:String) -> NSManagedObject?{
        let context = persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: name, in: context){
            let newEntity = NSManagedObject(entity: entity, insertInto: context)
            return newEntity
        }
        return nil
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
