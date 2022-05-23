//
//  CoreDataStack.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import CoreData

class CoreDataStack{
    
    static let shared = CoreDataStack()
    
    let persistentConatiner : NSPersistentContainer
    
    var context : NSManagedObjectContext{
        get{
            persistentConatiner.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return persistentConatiner.viewContext
        }
    }
    
    private init(){
        persistentConatiner = NSPersistentContainer(name: "MovieDB")
        persistentConatiner.loadPersistentStores{ (description, error) in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
    }
    
    func saveContext(){
        let context = self.context
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    
}
