//
//  WordRow.swift
//  
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import SwiftUI

struct WordRow: View {
    let word: String
    
    var body: some View {
        HStack {
            Image(systemName: "\(word.count).circle")
            Text(word)
        }
    }
}

#Preview {
    WordRow(word: "word")
}
