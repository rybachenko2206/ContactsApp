//
//  CoreDataStack.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import CoreData
import UIKit

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
        let nCenter = NotificationCenter.default
        nCenter.addObserver(self,
                            selector: #selector(mainContextChanged(notification:)),
                            name: .NSManagedObjectContextDidSave,
                            object: self.mainContext)
        
        nCenter.addObserver(self,
                            selector: #selector(bgContextChanged(notification:)),
                            name: .NSManagedObjectContextDidSave,
                            object: self.backgroundContext)
        
        nCenter.addObserver(self,
                            selector: #selector(appWillClose(_:)),
                            name: UIApplication.didEnterBackgroundNotification,
                            object: nil)
        
        nCenter.addObserver(self,
                            selector: #selector(appWillClose(_:)),
                            name: UIApplication.willTerminateNotification,
                            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Public funcs
    func saveContext(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        context.perform {
            do {
                try context.save()
            } catch let nsError as NSError {
                pl("Unable to Save Changes in backgroundContext")
                pl("\(nsError), \(nsError.localizedDescription)")
            }
        }
    }
    
    // MARK: Notification observers
    @objc private func mainContextChanged(notification: Notification) {
        backgroundContext.perform { [weak self] in
            self?.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    @objc private func bgContextChanged(notification: Notification) {
        mainContext.perform{ [weak self] in
            self?.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    @objc private func appWillClose(_ notification: Notification) {
        saveContext(context: mainContext)
        saveContext(context: backgroundContext)
    }
    
}

