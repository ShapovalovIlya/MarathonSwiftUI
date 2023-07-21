//
//  TimePicker.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI

struct TimePicker: View, Equatable {
    private let title: String
    private let selection: Binding<TimeType>
    
    var body: some View {
        Picker(title, selection: selection) {
            ForEach(TimeType.allCases) { time in
                Text(time.unit.symbol)
                    .tag(time)
            }
        }
        .tint(.accentColor)
        .padding()
        .background {
            Circle()
                .fill(Material.ultraThinMaterial)
        }
        .shadow(radius: 5)
        .frame(width: 110)
    }
    
    init(
        title: String,
        selection: Binding<TimeType>
    ) {
        self.title = title
        self.selection = selection
    }
    
    static func == (lhs: TimePicker, rhs: TimePicker) -> Bool {
        lhs.title == rhs.title
        && lhs.selection.wrappedValue == rhs.selection.wrappedValue
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimePicker(title: "hours", selection: .constant(.hours))
            TimePicker(title: "milliseconds", selection: .constant(.milliseconds))
            TimePicker(title: "minutes", selection: .constant(.minutes))
            TimePicker(title: "seconds", selection: .constant(.seconds))
        }
    }
}
