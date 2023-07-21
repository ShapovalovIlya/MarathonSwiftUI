//
//  SwiftUIView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct UnitImage: View, Equatable {
    let systemName: String
    var imageSize: CGSize = .init(width: 180, height: 200)
    
    private struct Drawing {
        static let imageOpacity: Double = 0.7
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 5
    }
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(
                width: imageSize.width,
                height: imageSize.height)
            .padding()
            .foregroundColor(.gray.opacity(Drawing.imageOpacity))
            .background(Material.thin)
            .cornerRadius(Drawing.cornerRadius)
            .padding()
            .shadow(radius: Drawing.shadowRadius)
    }
}

struct UnitImage_Previews: PreviewProvider {
    static var previews: some View {
        UnitImage(systemName: "house")
    }
}
