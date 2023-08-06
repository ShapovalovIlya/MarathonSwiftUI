//
//  Moonshot.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import SwiftUI
import SwiftUDF

public struct Moonshot: View {
    @StateObject var store: StoreOf<MoonshotDomain>
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(store.missions) { mission in
                        NavigationLink {
                            Text("Detail")
                        } label: {
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
