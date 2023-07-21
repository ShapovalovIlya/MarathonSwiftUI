//
//  VolumePicker.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI

struct VolumePicker: View, Equatable {
    let selection: Binding<VolumeType>
    
    var body: some View {
        Picker("", selection: selection) {
            ForEach(VolumeType.allCases) { volume in
                Text(volume.unit.symbol)
                    .tag(volume)
            }
        }
        .tint(.black)
        .frame(width: 80, height: 55)
        .background(Material.ultraThinMaterial)
        .shadow(radius: 5)
    }
    
    static func == (lhs: VolumePicker, rhs: VolumePicker) -> Bool {
        lhs.selection.wrappedValue == rhs.selection.wrappedValue
    }
}

struct VolumePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VolumePicker(selection: .constant(.cups))
            VolumePicker(selection: .constant(.gallons))
            VolumePicker(selection: .constant(.liters))
            VolumePicker(selection: .constant(.milliliters))
            VolumePicker(selection: .constant(.pints))
        }
    }
}
