//
//  TimeView.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct TimeView: View {
    @ObservedObject var store: StoreOf<TimeDomain>
    
    private struct Drawing {
        static let imageSize: CGSize = .init(width: 150, height: 120)
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 5
        static let childCornerRadius: CGFloat = 8
    }
    
    var body: some View {
        VStack {
            UnitImage(
                systemName: "clock.arrow.2.circlepath",
                imageSize: Drawing.imageSize)
            .equatable()
            UnitsText(store.resultTime)
                .equatable()
                .cornerRadius(Drawing.childCornerRadius)
                .padding(.horizontal)
            HStack {
                TimePicker(
                    title: "",
                    selection: Binding(
                        get: { store.inputValueType },
                        set: { store.send(.setInputType($0)) })
                )
                .equatable()
                UnitIcon(systemName: "chevron.right.circle")
                    .equatable()
                
                TimePicker(
                    title: "",
                    selection: Binding(
                        get: { store.outputValueType },
                        set: { store.send(.setOutputType($0)) })
                )
                .equatable()
            }
            .padding()
            UnitsTextField(
                placeholder: "Type time...",
                binding: Binding(
                    get: { store.inputTime },
                    set: { store.send(.setInputTime($0)) })
            )
            .equatable()
            .cornerRadius(Drawing.childCornerRadius)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(TimeBackground())
        .cornerRadius(Drawing.cornerRadius)
        .shadow(radius: Drawing.shadowRadius)
        .padding()
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(store: TimeDomain.previewStore)
    }
}
