

import Foundation
import CoreData

final class PersistaintController {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HabitEntities")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var dailyPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DailyProgressEntity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
