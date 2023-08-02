//
//  FinalScoreView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 02.08.2023.
//

import SwiftUI
import Shared

struct FinalScoreView: View {
    private struct Drawing {
        static let spacing: CGFloat = 20
        static let imageSize: CGSize = .init(width: 160, height: 100)
        static let shadowRadius: CGFloat = 5
    }
    private let imageGradient: Gradient = .init(colors: [.red, .green, .blue ])
    
    let score: Score
    let playAgainTap: () -> Void
    
    var body: some View {
        VStack(spacing: Drawing.spacing) {
            Image(systemName: "flag.checkered.2.crossed")
                .resizable()
                .frame(
                    width: Drawing.imageSize.width,
                    height: Drawing.imageSize.height
                )
                .foregroundStyle(imageGradient)
            Text("Your final score is \(score.score) from \(score.questionsCount)!")
                .font(.title2)
                .foregroundStyle(Color.blue)
            Text(score.message)
                .font(.title3)
                .foregroundStyle(Color.blue)
            RoundedRectangleButton(title: "Play again", action: playAgainTap)
        }
        .padding()
        .background(Material.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: Drawing.shadowRadius)
    }
    
    init(
        _ score: Score,
        playAgainTap: @escaping () -> Void
    ) {
        self.score = score
        self.playAgainTap = playAgainTap
    }
}

#Preview {
    ZStack {
        Color.green
        FinalScoreView(.sample, playAgainTap: {})
    }
}
