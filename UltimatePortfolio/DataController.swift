//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import CoreData
import CoreSpotlight
import SwiftUI
import WidgetKit

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
final class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs).
    ///
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing purposes, we create a temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.com.yourcompany.ultimateportfolio"

            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
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

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()

    /// Creates example projects and items to make amanunal testing easier.
    ///  - Throws: an NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for itemCounter in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }

        try viewContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    func delete(_ object: NSManagedObject) {
        // Remove data from Spotlight database
        let id = object.objectID.uriRepresentation().absoluteString
        if object is Item {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        } else if object is Project {
            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        }

        // Remove object from CoreData
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func update(_ item: Item) {
        // Use CoreData URI to identify item in Spotlight database
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString

        // Add title and detail as searchable attribute
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemDetail

        // Add item to Spotlight index
        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([searchableItem])

        save()
    }

    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? Item
    }

    func addProject() {
        let project = Project(context: container.viewContext)
        project.closed = false
        project.creationDate = Date()
        save()
    }

    func fetchRequestForTopItems(count: Int) -> NSFetchRequest<Item> {
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        itemRequest.predicate = compoundPredicate

        itemRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]

        itemRequest.fetchLimit = count
        return itemRequest
    }

    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
}
