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

  var completionAmount: Double {
    let originalItems = items?.allObjects as? [Item] ?? []
    guard originalItems.isEmpty == false else { return 0 }
    let completedItems = originalItems.filter(\.completed)
    return Double(completedItems.count) / Double(originalItems.count)
  }

  var projectItems: [Item] {
    let itemsArray = items?.allObjects as? [Item] ?? []

    return itemsArray.sorted {first, second in
      if first.completed == false {
        if second.completed == true {
          return true
        }
      } else if first.completed == true {
        if second.completed == false {
          return false
        }
      }
      if first.priority > second.priority {
        return true
      } else if first.priority < second.priority {
        return false
      }
      return first.itemCreationDate < second.itemCreationDate
    }
  }
}
