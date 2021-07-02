//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI
import CoreSpotlight

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem({ Label("Home", systemImage: "house") })

            ProjectsView(dataController: dataController, showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem({ Label("Open", systemImage: "list.bullet") })

            ProjectsView(dataController: dataController, showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem({ Label("Closed", systemImage: "checkmark") })

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem({ Label("Awards", systemImage: "rosette") })
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
    }

    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
