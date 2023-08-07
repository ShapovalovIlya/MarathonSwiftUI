//
//  MoonshotImage.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 07.08.2023.
//

import SwiftUI

struct MoonshotImage: View {
    let name: String
    
    var body: some View {
        Image(name, bundle: .module)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    MoonshotImage(name: "armstrong")
}
