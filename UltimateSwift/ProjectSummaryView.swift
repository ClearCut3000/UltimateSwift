//
//  ProjectSummaryView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 25.01.2023.
//

import SwiftUI

struct ProjectSummaryView: View {

  //MARK: - View Properties
  @ObservedObject var project: Project

  //MARK: - View Body
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
      .shadow(color: Color.black.opacity(0.2), radius: 5)
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(project.label)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
      ProjectSummaryView(project: Project.example)
    }
}
