//
//  SharedProject.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 13.04.2023.
//

import Foundation

struct SharedProject: Identifiable {
  let id: String
  let title: String
  let detail: String
  let owner: String
  let closed: Bool

  static let example = SharedProject(id: "1",
                                     title: "Example",
                                     detail: "Detail",
                                     owner: "TwoStraws",
                                     closed: false)
}
