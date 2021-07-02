//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

struct ItemRowView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject var item: Item

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(viewModel.title)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
            }
        }
        .accessibility(label: Text(viewModel.label))
    }

    init(project: Project, item: Item) {
        let viewModel = ViewModel(project: project, item: item)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.item = item
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: .example, item: .example)
    }
}
