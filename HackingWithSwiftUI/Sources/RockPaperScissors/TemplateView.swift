//
//  TemplateView.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI

struct TemplateView: View {
    let title: String
    let description: String
    let play: () -> Void
    
    var body: some View {
        VStack(spacing: 50) {
            Text(title)
                .font(.title.bold())
            Text(description)
                .font(.title2)
            Spacer()
            Button(action: play) {
                Text("Play!")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: 140, height: 40)
            }
            .padding()
            .background(Color.cyan)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .foregroundColor(.indigo)
        .frame(width: 300, height: 300)
        .padding()
        .background(Material.thick)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateView(
            title: "Game over!",
            description: "Some description!",
            play: {})
    }
}
