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
import iExpense
import Moonshot

struct AppsTab: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("We Split", destination: WeSplitView())
                NavigationLink("Unit conversion", destination: UnitConversionsView())
                NavigationLink("Better rest", destination: BetterRestView())
                NavigationLink("iExpenses", destination: iExpenseView())
                NavigationLink("Moonshot", destination: Moonshot())
            }
            .navigationTitle("Regular Apps")
        }
    }
}

#Preview {
    AppsTab()
}
