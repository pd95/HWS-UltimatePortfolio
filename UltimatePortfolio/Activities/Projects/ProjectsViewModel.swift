//
//  ProjectsViewModel.swift
//  UltimatePortfolio
//
//  Created by Philipp on 02.07.21.
//

import Foundation
import CoreData

extension ProjectsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

        let dataController: DataController
        let showClosedProjects: Bool

        @Published var sortOrder = Item.SortOrder.optimized

        private let projectsController: NSFetchedResultsController<Project>
        @Published var projects = [Project]()
        @Published var selectedItem: Item?

        @Published var showingUnlockView = false

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            projectsController.delegate = self

            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our projects!")
            }
        }

        func addProject() {
            let canCreate = dataController.fullVersionUnlocked ||
                    dataController.count(for: Project.fetchRequest()) < 3
            if canCreate {
                dataController.addProject()
            } else {
                showingUnlockView.toggle()
            }
        }

        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.creationDate = Date()
            item.priority = 2
            item.completed = false
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortOrder)
            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }
            dataController.save()
        }

        func delete(_ item: Item) {
            dataController.delete(item)
            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            projects = projectsController.fetchedObjects ?? []
        }
    }
}
