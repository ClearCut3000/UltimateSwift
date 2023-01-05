//
//  SelectSomethingView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 05.01.2023.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
      Text("Please, select something from menu to begin!")
        .italic()
        .foregroundColor(.secondary)
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
