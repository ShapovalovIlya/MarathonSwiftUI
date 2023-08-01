//
//  QuestionPicker.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import SwiftUI

struct QuestionPicker: View, Equatable {
    let selection: Binding<Int>
    
    var body: some View {
        Picker(
            "Select questions count.",
            selection: selection) {
                ForEach(QuestionCount.allCases) { questionCount in
                    Text(questionCount.rawValue.description)
                        .tag(questionCount)
                }
            }
            .pickerStyle(.segmented)
    }
    
    static func == (lhs: QuestionPicker, rhs: QuestionPicker) -> Bool {
        lhs.selection.wrappedValue == rhs.selection.wrappedValue
    }
}

#Preview {
    QuestionPicker(selection: .constant(10))
}
