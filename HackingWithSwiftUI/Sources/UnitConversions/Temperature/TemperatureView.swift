//
//  TemperatureView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct TemperatureView: View {
    @ObservedObject var store: StoreOf<TemperatureDomain>
    
    private struct Drawing {
        static let cornerRadius: CGFloat = 12
        static let elementCornerRadius: CGFloat = 6
        static let contentSpacing: CGFloat = 0
        static let shadowRadius: CGFloat = 5
    }
    
    var body: some View {
        VStack {
            UnitImage(systemName: "thermometer.sun")
                .equatable()
            HStack(spacing: Drawing.contentSpacing) {
                TemperaturePicker(
                    title: "To",
                    selection: Binding(
                        get: { store.outputValueType },
                        set: { store.send(.setOutputType($0)) })
                )
                .equatable()
                .cornersRadius(
                    Drawing.elementCornerRadius,
                    corners: [.topLeft, .bottomLeft])
                UnitsText(store.temperatureResult)
                    .equatable()
                    .cornersRadius(
                        Drawing.elementCornerRadius,
                        corners: [.topRight, .bottomRight])
            }
            .padding(.horizontal)
            HStack(spacing: Drawing.contentSpacing) {
                TemperaturePicker(
                    title: "From",
                    selection: Binding(
                        get: { store.inputValueType },
                        set: { store.send(.setInputType($0)) })
                )
                .equatable()
                .cornersRadius(
                    Drawing.elementCornerRadius,
                    corners: [.topLeft, .bottomLeft])
                UnitsTextField(
                    placeholder: "From",
                    binding: Binding(
                        get: { store.inputTemperature },
                        set: { store.send(.setInputTemperature($0)) })
                )
                .equatable()
                .cornersRadius(
                    Drawing.elementCornerRadius,
                    corners: [.topRight, .bottomRight])
            }
            .padding()
        }
        .background(BackgroundGradient())
        .cornerRadius(Drawing.cornerRadius)
        .shadow(radius: Drawing.shadowRadius)
        .padding()
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView(store: TemperatureDomain.previewStore)
    }
}
