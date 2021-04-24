//
//  CoreDataStack.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import CoreData
import Foundation

enum LogicOperator: String {
    case and = "AND"
    case or = "OR"
}

protocol CoreDataStackProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
    func delete (object: NSManagedObject)
    func delete(forEntityName entityName: String)
}

final class CoreDataStack: CoreDataStackProtocol {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleMarket")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func delete (object: NSManagedObject) {
        context.delete(object)
    }

    func delete(forEntityName entityName: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
