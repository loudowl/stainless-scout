//
//  PersistenceController.swift
//  Stainless Scout
//
//  Manages the Core Data persistent container.
//  Provides shared singleton and in-memory preview instance.
//

import CoreData
import Foundation

final class PersistenceController {
    
    // MARK: - Singleton
    static let shared = PersistenceController()
    
    // MARK: - Preview Instance
    /// In-memory store for SwiftUI Previews
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // Insert sample data for previews
        SDKSeeder.seedIfNeeded(context: context, force: true)
        
        return controller
    }()
    
    // MARK: - Container
    let container: NSPersistentContainer
    
    // MARK: - Init
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "StainlessScout")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Configure for performance
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSMigratePersistentStoresAutomaticallyOption
        )
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSInferMappingModelAutomaticallyOption
        )
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // In production, handle this gracefully
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        
        // Merge policy to handle conflicts
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Save
    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("⚠️ Core Data save error: \(nsError.localizedDescription)")
        }
    }
    
    // MARK: - Background Task
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
}
