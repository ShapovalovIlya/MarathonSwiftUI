//
//  GuessTheFlagView.swift
//  GuesTheFlag
//
//  Created by User on 16.07.2023.
//

import SwiftUI
import SwiftUDF

public struct GuessTheFlagView: View {
    @ObservedObject var store: StoreOf<GuessTheFlagDomain>
    
    @State private var selectedFlag: String?
    
    public var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(
                        color: .init(red: 0.1, green: 0.2, blue: 0.45),
                        location: 0.3),
                    .init(
                        color: .init(red: 0.76, green: 0.15, blue: 0.26),
                        location: 0.3)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap on flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(store.currentFlag)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(store.countries[0..<3], id: \.self) { flag in
                        FlagButton(
                            flag,
                            action: {
                                selectedFlag = flag
                                store.send(.tapOnFlag($0))
                            }
                        )
                        .opacity( computeOpacity(for: flag) )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Text("Score: \(store.score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text("Question \(store.currentNumberOfQuestions) of \(store.totalQuestions)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.askQuestion) }
        .onDisappear { store.send(.restartGame) }
        .alert(
            store.scoreTitle,
            isPresented: Binding(
                get: { store.showScore },
                set: { _ in store.send(.closeAlert) })
        ) {
            Button("Continue") {
                store.send(.askQuestion)
                selectedFlag = nil
            }
        } message: {
            Text("Your score is: \(store.score)")
        }
        .alert(
            store.scoreTitle,
            isPresented: Binding(
                get: { store.showFinalScore },
                set: { _ in store.send(.closeAlert) })
        ) {
            Button("Play again.") {
                store.send(.restartGame)
            }
        }
    }
    
    //MARK: - init(_:)
    public init(store: StoreOf<GuessTheFlagDomain>) {
        self.store = store
    }
    
    //MARK: -  Private Methods
    private func computeOpacity(for flag: String) -> Double {
        guard
            let selectedFlag = selectedFlag,
            selectedFlag != flag
        else {
            return 1
        }
        return 0.25
    }
    
}

struct GuessTheFlagView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GuessTheFlagView(store: GuessTheFlagDomain.previewStore)
        }
    }
}
