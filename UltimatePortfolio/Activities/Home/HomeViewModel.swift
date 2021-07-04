//
//  HomeViewModel.swift
//  UltimatePortfolio
//
//  Created by Philipp on 02.07.21.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var projects: [Project] = []
        @Published var items: [Item] = []
        @Published var selectedItem: Item?

        var dataController: DataController

        @Published var upNext = ArraySlice<Item>()
        @Published var moreToExplore = ArraySlice<Item>()

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
            projectRequest.predicate = NSPredicate(format: "closed = false")

            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show the 10 highest-priority, incomplete items from open projects
            let itemRequest = dataController.fetchRequestForTopItems(count: 10)

            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Initialize parent object before assigning ourself as controller delegate
            super.init()
            projectsController.delegate = self
            itemsController.delegate = self

            // Fetch initial data
            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if controller == itemsController, let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } else if controller == projectsController, let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        func selectItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
    }
}
