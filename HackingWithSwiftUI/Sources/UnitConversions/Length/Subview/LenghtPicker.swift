//
//  SwiftUIView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct LenghtPicker: View, Equatable {
    private let title: String
    private let selection: Binding<LengthType>
    
    var body: some View {
        Picker(title, selection: selection) {
            ForEach(LengthType.allCases) { lenght in
                Text(lenght.unit.symbol)
                    .tag(lenght)
            }
        }
        .frame(width: 70, height: 55)
        .background(Material.ultraThinMaterial)
        .shadow(radius: 5)
    }
    
    //MARK: - init(_:)
    init(
        _ title: String,
        selection: Binding<LengthType>
    ) {
        self.title = title
        self.selection = selection
    }
    
    static func == (lhs: LenghtPicker, rhs: LenghtPicker) -> Bool {
        lhs.title == rhs.title
        && lhs.selection.wrappedValue == rhs.selection.wrappedValue
    }
}

struct LenghtPickerw_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LenghtPicker("Picker", selection: .constant(.feet))
            LenghtPicker("Picker", selection: .constant(.kilometers))
            LenghtPicker("Picker", selection: .constant(.meters))
            LenghtPicker("Picker", selection: .constant(.miles))
            LenghtPicker("Picker", selection: .constant(.yards))
        }
    }
}
