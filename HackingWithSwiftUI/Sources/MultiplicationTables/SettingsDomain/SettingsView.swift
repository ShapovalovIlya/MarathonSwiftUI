//
//  SettingsView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct SettingsView: View {
    private struct Drawing {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 5
        static let itemSpacing: CGFloat = 15
        static let buttonSize: CGSize = .init(width: 250, height: 55)
    }
    @StateObject private var store = SettingsDomain.previewStore

    let onCommit: (SettingsDomain.State) -> Void
    
    var body: some View {
        VStack(spacing: Drawing.itemSpacing) {
            Text("Settings")
                .font(.title)
            Stepper(
                "Selected table: \(store.tableDifficult.description)",
                value: Binding(
                    get: { store.tableDifficult },
                    set: { store.send(.setDifficult($0)) }),
                in: 2...12
            )
            Text("Select questions count:")
            QuestionPicker(
                selection: Binding(
                    get: { store.totalQuestions },
                    set: { store.send(.setTotalQuestions($0)) })
            )
            .equatable()
            RoundedRectangleButton(title: "Start") {
                onCommit(store.state)
            }
            .equatable()
        }
        .padding()
        .background(Material.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
        .shadow(radius: Drawing.shadowRadius)
    }
}

#Preview {
    ZStack {
        Color.blue
        SettingsView(onCommit: { _ in })
    }
}
