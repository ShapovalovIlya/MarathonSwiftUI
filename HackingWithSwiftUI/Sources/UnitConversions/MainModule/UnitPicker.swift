//
//  UnitPicker.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct UnitPicker: View, Equatable {
    let text: String
    let selection: Binding<UnitTypes>
    
    var body: some View {
        Picker(
            text,
            selection: selection
        ) {
            ForEach(UnitTypes.allCases) { unit in
                Image(systemName: unit.imageName)
                    .tag(unit)
            }
        }
        .pickerStyle(.segmented)
    }
    
    static func == (lhs: UnitPicker, rhs: UnitPicker) -> Bool {
        lhs.selection.wrappedValue == lhs.selection.wrappedValue
    }
}

struct UnitPicker_Previews: PreviewProvider {
    static var previews: some View {
        UnitPicker(
            text: "",
            selection: .constant(.length))
    }
}
