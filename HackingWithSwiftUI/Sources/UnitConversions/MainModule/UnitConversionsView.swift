//
//  SwiftUIView.swift
//  
//
//  Created by User on 18.07.2023.
//

import SwiftUI
import SwiftUDF

public struct UnitConversionsView: View {
    @StateObject var store: StoreOf<UnitConversionsDomain>
    
    @StateObject private var temperatureStore = Store(
        state: TemperatureDomain.State(),
        reducer: TemperatureDomain())
    @StateObject private var lenghtStore = Store(
        state: LenghtDomain.State(),
        reducer: LenghtDomain())
    @StateObject private var timeStore = Store(
        state: TimeDomain.State(),
        reducer: TimeDomain())
    @StateObject private var volumeStore = Store(
        state: VolumeDomain.State(),
        reducer: VolumeDomain())
    
    public var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
                .overlay(Material.ultraThin)
            VStack {
                Spacer()
                Group {
                    switch store.type {
                    case .temperature:
                        TemperatureView(store: temperatureStore)
                        
                    case .length:
                        LengthView(store: lenghtStore)
                        
                    case .time:
                        TimeView(store: timeStore)
                        
                    case .volume:
                        VolumeView(store: volumeStore)
                    }
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut, value: store.type)
                Spacer()
                UnitPicker(
                    text: "Chose unit",
                    selection: Binding(
                        get: { store.type },
                        set: { store.send(.setUnitType($0)) })
                )
                .equatable()
                .padding()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    public init(store: StoreOf<UnitConversionsDomain> = UnitConversionsDomain.previewStore) {
        self._store = StateObject(wrappedValue: store)
    }
}

struct UnitConversionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UnitConversionsView(store: UnitConversionsDomain.previewStore)
        }
    }
}
