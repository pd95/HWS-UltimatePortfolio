//
//  ProjectSummaryView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

struct ProjectSummaryView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(project.projectItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(project.projectTitle)
                .font(.title2)
            
            ProgressView(value: project.completionAmount)
                .accentColor(Color(project.projectColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.label)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(project: .example)
    }
}
