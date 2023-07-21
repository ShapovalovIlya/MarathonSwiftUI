//
//  TemperaturePicker.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct TemperaturePicker: View, Equatable {
    let title: String
    let selection: Binding<TemperatureType>
    
    var body: some View {
        Picker(title, selection: selection) {
            ForEach(TemperatureType.allCases) { type in
                Text(type.unit.symbol)
                    .tag(type)
            }
        }
        .frame(width: 80, height: 55)
        .background(Color.gray)
        .tint(.white)
    }
    
    static func == (lhs: TemperaturePicker, rhs: TemperaturePicker) -> Bool {
        lhs.selection.wrappedValue == rhs.selection.wrappedValue
    }
}


struct TemperaturePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TemperaturePicker(
                title: "From",
                selection: .constant(.celsius))
            TemperaturePicker(
                title: "From",
                selection: .constant(.fahrenheit))
            TemperaturePicker(
                title: "From",
                selection: .constant(.kelvin))
        }
    }
}
