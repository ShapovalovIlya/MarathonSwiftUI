//
//  VolumeView.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct VolumeView: View {
    @ObservedObject var store: StoreOf<VolumeDomain>
    
    private struct Drawing {
        static let elementsSpacing: CGFloat = 0
        static let textCorner: CGFloat = 6
        static let viewCorner: CGFloat = 12
        static let shadowRadius: CGFloat = 5
    }
    
    var body: some View {
        VStack {
            UnitImage(systemName: "testtube.2")
            UnitsText(
                store.resultVolume,
                textColor: .black)
            .equatable()
            .cornerRadius(Drawing.textCorner)
            .padding()
            HStack(spacing: Drawing.elementsSpacing) {
                VolumePicker(
                    selection: Binding(
                        get: { store.inputValueType },
                        set: { store.send(.setInputType($0)) })
                )
                .equatable()
                UnitsTextField(
                    placeholder: "From",
                    binding: Binding(
                        get: { store.inputVolume },
                        set: { store.send(.setInputVolume($0)) })
                )
                .equatable()
                VolumePicker(
                    selection: Binding(
                        get: { store.outputValueType },
                        set: { store.send(.setOutputType($0)) })
                )
                .equatable()
            }
        }
        .background(VolumeBackground())
        .cornerRadius(Drawing.viewCorner)
        .padding()
        .shadow(radius: Drawing.shadowRadius)
    }
}

struct VolumeView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeView(store: VolumeDomain.previewStore)
    }
}
