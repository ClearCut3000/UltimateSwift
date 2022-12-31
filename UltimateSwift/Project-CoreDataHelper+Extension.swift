//
//  Project-CoreDataHelper+Extension.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 31.12.2022.
//

import Foundation

extension Project {
  var projectTitle: String {
    title ?? ""
  }

  var projectDetail: String {
    detail ?? ""
  }

  var projectColor: String {
    color ?? "Light Blue"
  }

  static var example: Project {
    let controller = DataController(inMemory: true)
    let viewContext = controller.container.viewContext
    let project = Project(context: viewContext)
    project.title = "Example Project"
    project.detail = "This is an example project"
    project.closed = true
    project.creationDate = Date()
    return project
  }
}
