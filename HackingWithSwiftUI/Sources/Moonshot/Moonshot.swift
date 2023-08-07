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
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    LazyVGrid(columns: columns) {
                        NavigationCollection(data: store.missions
                        ) { mission in
                            MissionView(mission: mission, astronauts: store.astronauts)
                                .equatable()
                        } label: { mission in
                            MissionRow(mission: mission)
                                .equatable()
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button {
                    isGridLayout.toggle()
                } label: {
                    Image(systemName: isGridLayout
                          ? "square.grid.3x3"
                          : "list.bullet")
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
