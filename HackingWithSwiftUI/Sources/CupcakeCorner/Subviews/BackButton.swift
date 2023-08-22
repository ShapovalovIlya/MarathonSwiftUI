//
//  BackButton.swift
//
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import SwiftUI

struct BackButton: ToolbarContent {
    let backButtonTap: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Label("Back", systemImage: "chevron.backward.circle")
                .onTapGesture(perform: backButtonTap)
        }
    }
}
