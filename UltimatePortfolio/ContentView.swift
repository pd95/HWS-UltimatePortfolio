//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem({ Label("Home", systemImage: "house") })
            
            ProjectsView(showClosedProjects: false)
                .tabItem({ Label("Open", systemImage: "list.bullet") })

            ProjectsView(showClosedProjects: true)
                .tabItem({ Label("Closed", systemImage: "checkmark") })
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
