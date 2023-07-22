//
//  ScoreTitle.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI

struct GameText: View, Equatable {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.indigo)
            .padding()
            .background(Material.thin)
            .cornerRadius(8)
            .shadow(radius: 5)
    }
}

struct GameText_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            GameText(text: "Score: 10")
        }
    }
}
