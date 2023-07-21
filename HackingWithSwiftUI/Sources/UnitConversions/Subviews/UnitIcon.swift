//
//  UnitIcon.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI

struct UnitIcon: View, Equatable {
    let systemName: String
    let size: CGSize
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .foregroundColor(.white.opacity(0.7))
            .frame(
                width: size.width,
                height: size.height)
            .shadow(radius: 5)
    }
    
    init(
        systemName: String,
        size: CGFloat = 50
    ) {
        self.systemName = systemName
        self.size = .init(width: size, height: size)
    }
    
    init(
        systemName: String,
        size: CGSize
    ) {
        self.systemName = systemName
        self.size = size
    }
}

struct ArrowImage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            UnitIcon(systemName: "chevron.right.circle")
        }
    }
}
