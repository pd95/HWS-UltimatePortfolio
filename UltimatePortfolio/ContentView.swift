//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem({ Label("Home", systemImage: "house") })
            
            ProjectsView(showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem({ Label("Open", systemImage: "list.bullet") })

            ProjectsView(showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem({ Label("Closed", systemImage: "checkmark") })
            
            AwardsView()
                .tag(AwardsView.tag)
                .tabItem({ Label("Awards", systemImage: "rosette") })
        }
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
