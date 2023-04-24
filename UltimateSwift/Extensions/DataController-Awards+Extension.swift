//
//  DataController-Awards+Extension.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 02.04.2023.
//

import Foundation
import CoreData

extension DataController {

  /// Earned Awards checker
  func hasEarned(award: Award) -> Bool {
    switch award.criterion {
    case "items":
      // returns true if added a certain number of items
      let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
      let awardCount = count(for: fetchRequest)
      return awardCount >= award.value
    case "complete":
      // returns true if completed a certain number of items
      let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
      fetchRequest.predicate = NSPredicate(format: "completed = true")
      let awardCount = count(for: fetchRequest)
      return awardCount >= award.value
    case "chat":
      // returns true if they posted a certain number of chat messages
      return UserDefaults.standard.integer(forKey: "chatCount") >= award.value
    default:
      // an unknown award criterion; this should never be allowed
      //      fatalError("Unknown award criterion: \(award.criterion)")
      return false
    }
  }
}
