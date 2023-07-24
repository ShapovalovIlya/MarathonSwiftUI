//
//  AppsTab.swift
//  
//
//  Created by User on 18.07.2023.
//

import SwiftUI
import SwiftUDF
import WeSplit
import UnitConversions
import BetterRest

struct AppsTab: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("We Split") {
                        WeSplitView(store: WeSplitDomain.previewStore)
                    }
                    NavigationLink("Unit conversion") {
                        UnitConversionsView(store: UnitConversionsDomain.previewStore)
                    }
                    NavigationLink("Better rest") {
                        BetterRestView(store: BetterRestDomain.previewStore)
                    }
                }
            }
            .navigationTitle("Regular Apps")
        }
    }
}

struct AppsTab_Previews: PreviewProvider {
    static var previews: some View {
        AppsTab()
    }
}
