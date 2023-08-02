//
//  NumberField.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 02.08.2023.
//

import SwiftUI

public struct NumberField: View, Equatable {
    private let size: CGSize = .init(width: 100, height: 55)
    
    let title: String
    let binding: Binding<Int>
    let textColor: Color
    
    public var body: some View {
        TextField(
            title,
            value: binding,
            format: .number
        )
        .frame(
            width: size.width,
            height: size.height
            )
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.center)
        .foregroundColor(textColor)
    }
    
    public init(
        title: String,
        binding: Binding<Int>,
        textColor: Color = .black
    ) {
        self.title = title
        self.binding = binding
        self.textColor = textColor
    }
    
    public static func == (lhs: NumberField, rhs: NumberField) -> Bool {
        return lhs.title == rhs.title &&
        lhs.binding.wrappedValue == rhs.binding.wrappedValue
    }
}

#Preview {
    NumberField(title: "Title", binding: .constant(5))
}
