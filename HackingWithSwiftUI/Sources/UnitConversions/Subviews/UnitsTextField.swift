//
//  SwiftUIView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct UnitsTextField: View, Equatable {
    let placeholder: String
    let binding: Binding<Double>
    var textColor: Color = .blue
    
    var body: some View {
        TextField(
            placeholder,
            value: binding,
            format: .number)
        .frame(height: 55)
        .background(Color.white)
        .textFieldStyle(DefaultTextFieldStyle())
        .foregroundColor(textColor)
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.center)
    }
    
    static func == (lhs: UnitsTextField, rhs: UnitsTextField) -> Bool {
        lhs.binding.wrappedValue == rhs.binding.wrappedValue
    }
}

struct TemperatureTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            UnitsTextField(
                placeholder: "",
                binding: .constant(0))
        }
    }
}
