//
//  DatabaseController.swift
//  Tweak and Eat
//
//  Created by admin on 24/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import Foundation
import CoreData

// MARK: Public methods

var context: NSManagedObjectContext {
get {
    if #available(iOS 10.0, *) {
        return DatabaseController.persistentContainer.viewContext;
    } else {
        return DatabaseController.managedObjectContext;
    }
  }
}
class DatabaseController {
    
    @available(iOS 10.0, *)
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tweak_and_Eat");
        container.loadPersistentStores { (storeDescription, error) in
            print("CoreData: Inited \(storeDescription)");
            guard error == nil else {
                print("CoreData: Unresolved error \(String(describing: error))");
                return;
            }
        }
        return container;
    }()
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: "Tweak_and_Eat");
        } catch {
            print("CoreData: Unresolved error \(error)");
        }
        return nil;
    }()
    
    static var managedObjectContext: NSManagedObjectContext = {
        let coordinator = DatabaseController.persistentStoreCoordinator;
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType);
        managedObjectContext.persistentStoreCoordinator = coordinator;
        return managedObjectContext;
    }()
    
    class func saveContext(){
        if context.hasChanges {
            do {
                try context.save();
                
            } catch {
                context.rollback();
                
            }
        }
        
    }
   
}

extension NSPersistentStoreCoordinator {
    
    /// NSPersistentStoreCoordinator error types
    public enum CoordinatorError: Error {
        /// .momd file not found
        case modelFileNotFound
        /// NSManagedObjectModel creation fail
        case modelCreationError
        /// Gettings document directory fail
        case storePathNotFound
    }
    
    /// Return NSPersistentStoreCoordinator object
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            throw CoordinatorError.storePathNotFound
        }
        
        do {
            let url = documents.appendingPathComponent("\(name).sqlite")
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
                            NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            throw error
        }
        
        return coordinator
    }
}
