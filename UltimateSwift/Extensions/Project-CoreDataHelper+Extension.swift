//
//  Project-CoreDataHelper+Extension.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 31.12.2022.
//

import Foundation

extension Project {
  static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]

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

  /// No sorting items property
  var projectItems: [Item] {
    items?.allObjects as? [Item] ?? []
  }

  /// Default sorting items property
  var projectItemsDefaultSorted: [Item] {
    projectItems.sorted {first, second in
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

  /// custom sorting methods for projects items
  func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
    switch sortOrder {
    case .title:
      return projectItems.sorted(by: \Item.itemTitle)
    case .optimazed:
      return projectItemsDefaultSorted
    case .creationDate:
      return projectItems.sorted(by: \Item.itemCreationDate)
    }
  }
}
