//
//  ProjectHeaderView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 03.01.2023.
//

import SwiftUI

struct ProjectHeaderView: View {

  //MARK: - View Properties
  @ObservedObject var project: Project

  //MARK: - View Body
    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          Text(project.projectTitle)
          ProgressView(value: project.completionAmount)
            .accentColor(Color(project.projectColor))
        }
        Spacer()
        NavigationLink(destination: EditProjectView(project: project)) {
          Image(systemName: "square.and.pencil")
            .imageScale(.large)
        }
      }
      .padding(.bottom, 10)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
      ProjectHeaderView(project: Project.example)
    }
}
