//
//  LengthView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct LengthView: View {
    @ObservedObject var store: StoreOf<LenghtDomain>
    
    private struct Drawing {
        static let imageSize: CGSize = .init(width: 250, height: 80)
        static let cornerRadius: CGFloat = 12
        static let verticalPadding: Double = 10
    }
    
    var body: some View {
        VStack {
            UnitIcon(
                systemName: "ruler",
                size: Drawing.imageSize)
            .equatable()
            .padding()
            
            Text("To:")
                .foregroundColor(.white)
                .font(.title2)
            
            HStack(spacing: 0) {
                LenghtPicker(
                    "To",
                    selection: Binding(
                        get: { store.outputValueType },
                        set: { store.send(.setOutputType($0)) })
                )
                .equatable()
                UnitsText(
                    store.resultLenght,
                    textColor: .black)
                .equatable()
            }
            .cornerRadius(8)
            .padding(.horizontal)
            
            Text("From:")
                .foregroundColor(.white)
                .font(.title2)
            
            HStack(spacing: 0) {
                LenghtPicker(
                    "From",
                    selection: Binding(
                        get: { store.inputValueType },
                        set: { store.send(.setInputType($0)) })
                )
                .equatable()
                
                UnitsTextField(
                    placeholder: "Type Lenght",
                    binding: Binding(
                        get: { store.inputLenght },
                        set: { store.send(.setInputLenght($0)) }),
                    textColor: .black
                )
                .equatable()
            }
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom)
            
        }
        .background(LengthBackground())
        .cornerRadius(Drawing.cornerRadius)
        .shadow(radius: 5)
        .padding()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LengthView(store: LenghtDomain.previewStore)
    }
}
