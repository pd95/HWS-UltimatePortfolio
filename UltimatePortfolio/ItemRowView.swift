//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var item: Item

    var icon: some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }

    var label: Text {
        if item.completed {
            return Text("\(item.itemTitle), completed.")
        } else if item.priority == 3 {
            return Text("\(item.itemTitle), high priority.")
        }
        return Text(item.itemTitle)
    }

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                icon
            }
        }
        .accessibility(label: label)
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: .example, item: .example)
    }
}
