//
//  RoundedRectangleButton.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 02.08.2023.
//

import SwiftUI

public struct RoundedRectangleButton: View, Equatable {
    let title: String
    let action: () -> Void
    var textColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat
    
    public var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundStyle(textColor)
                .padding()
                .frame(width: 250, height: 55)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        })
    }
    
    public init(
        title: String,
        action: @escaping () -> Void,
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = 12
    ) {
        self.title = title
        self.action = action
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    public static func == (lhs: RoundedRectangleButton, rhs: RoundedRectangleButton) -> Bool {
        return lhs.title == rhs.title &&
        lhs.textColor == rhs.textColor &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.cornerRadius == rhs.cornerRadius
    }
}

#Preview {
    RoundedRectangleButton(title: "Title", action: {})
}
