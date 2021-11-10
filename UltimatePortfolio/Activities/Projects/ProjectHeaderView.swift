//
//  ProjectHeaderView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)

                ProgressView(value: project.completionAmount)
                    .accentColor(Color(project.projectColor))
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: project)) {
                Label("Edit Project", systemImage: "square.and.pencil")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: .example)
    }
}
