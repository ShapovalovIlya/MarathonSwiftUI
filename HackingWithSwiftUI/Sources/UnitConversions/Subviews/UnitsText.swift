//
//  SwiftUIView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct UnitsText: View, Equatable {
    private let text: String
    private let textColor: Color
    
    var body: some View {
        Text(text)
            .frame(height: 55)
            .foregroundColor(textColor)
            .frame(minWidth: 75, maxWidth: .infinity)
            .background(Color.white)
            .multilineTextAlignment(.center)
    }
    
    init(
        _ text: String,
        textColor: Color = .blue
    ) {
        self.text = text
        self.textColor = textColor
    }

}

struct TemperatureText_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            UnitsText("Text")
        }
    }
}
