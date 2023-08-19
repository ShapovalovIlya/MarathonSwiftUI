//
//  CancelButton.swift
//
//
//  Created by Илья Шаповалов on 19.08.2023.
//

import SwiftUI

struct CancelButton: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Cancel", action: dismiss.callAsFunction)
        }
    }
}
