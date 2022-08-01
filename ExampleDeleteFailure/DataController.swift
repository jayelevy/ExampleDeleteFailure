//
//  DataController.swift
//  CoreDataState
//
//  Created by Jay Levy on 7/21/22.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()
    
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        for i in 1...4 {
            let category = Category(context: viewContext)
            category.name = "Category \(i)"
        }
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        print("****>> dataController object:   \(object)")
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
}
