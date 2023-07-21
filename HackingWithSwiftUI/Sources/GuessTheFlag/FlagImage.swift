//
//  FlagImage.swift
//  GuesTheFlag
//
//  Created by User on 17.07.2023.
//

import SwiftUI

struct FlagImage: View {
    private let flag: String
    
    var body: some View {
        Image(flag, bundle: .module)
            .resizable()
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 5)
    }
    
    init(_ flag: String) {
        self.flag = flag
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage("Russia")
            .frame(width: 200, height: 150)
    }
}
