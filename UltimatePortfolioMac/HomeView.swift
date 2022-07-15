//
//  HomeView.swift
//  UltimatePortfolioMac
//
//  Created by Philipp on 15.07.22.
//

import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    @StateObject private var viewModel: ViewModel

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                ItemListView(title: "Up next", items: $viewModel.upNext)
                ItemListView(title: "More to explore", items: $viewModel.moreToExplore)
            }
            .listStyle(.sidebar)
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
