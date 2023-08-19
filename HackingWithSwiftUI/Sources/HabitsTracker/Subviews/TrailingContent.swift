//
//  TrailingContent.swift
//
//
//  Created by Илья Шаповалов on 19.08.2023.
//

import SwiftUI

struct TrailingContent: ToolbarContent {
    let addButtonAction: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            EditButton()
            Button(action: addButtonAction) {
                Image(systemName: "plus.circle")
            }
        }
    }
}
