//
//  CoreDataStack.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: Properties
    private let dataModelName = "ContactsTestApp"
    
    private lazy var appDocumentsDirectory: URL = {
        return Utils.appDocumentsDirectory
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: dataModelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:
            self.managedObjectModel)
        
        let fileModelComponent = "\(dataModelName).sqlite"
        let url = self.appDocumentsDirectory.appendingPathComponent(fileModelComponent)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: options)
        } catch {
            pl("Unable to add Persistent Store error \(error), \(String(describing: error._userInfo))")
        }
        return coordinator
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return privateManagedObjectContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return mainManagedObjectContext
    }()
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mainContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.mainContext)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(bgContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.backgroundContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Notification observers
    
    @objc func mainContextChanged(notification: Notification) {
        backgroundContext.perform { [weak self] in
            self?.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    @objc func bgContextChanged(notification: Notification) {
        mainContext.perform{ [weak self] in
            self?.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    
    // MARK: Public funcs
    
    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

