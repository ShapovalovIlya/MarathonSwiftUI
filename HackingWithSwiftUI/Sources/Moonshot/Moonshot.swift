//
//  Moonshot.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import SwiftUI
import SwiftUDF
import Shared

public struct Moonshot: View {
    @StateObject var store: StoreOf<MoonshotDomain>
    @State var isGridLayout = true
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
    
    private let rows: [GridItem] = [
        .init(.flexible(maximum: .infinity))
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: isGridLayout ? columns : rows
                ) {
                    NavigationCollection(data: store.missions
                    ) { mission in
                        MissionView(mission: mission, astronauts: store.astronauts)
                            .equatable()
                    } label: { mission in
                        MissionRow(mission: mission)
                            .equatable()
                    }
                }
                .padding([.horizontal, .bottom])
                .animation(.easeInOut, value: isGridLayout)
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button {
                    isGridLayout.toggle()
                } label: {
                    Image(systemName: isGridLayout
                          ? "list.bullet"
                          : "square.grid.3x3")
                }
            }
        }
        .onAppear { store.send(.viewAppeared) }
    }
    
    public init(store: StoreOf<MoonshotDomain> = MoonshotDomain.liveStore) {
        self._store = StateObject(wrappedValue: store)
    }
}

#Preview {
    Moonshot(store: MoonshotDomain.previewStore)
}
