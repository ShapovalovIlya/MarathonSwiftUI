//
//  WeaponButton.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI

struct WeaponButton: View, Equatable {
    let type: WeaponType
    let action: (WeaponType) -> Void
    
    var body: some View {
        Button {
            action(type)
        } label: {
            Image(systemName: type.imageName)
                .resizable()
                .frame(width: 80, height: 70)
                .foregroundStyle(.indigo)
        }
        .buttonBorderShape(.roundedRectangle)
        .padding()
        .background(Material.thickMaterial)
        .shadow(radius: 5)
        .cornerRadius(12)
    }
    
    static func == (lhs: WeaponButton, rhs: WeaponButton) -> Bool {
        lhs.type == rhs.type
    }
}

struct WeaponButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            VStack {
                WeaponButton(type: .paper, action: { _ in })
                WeaponButton(type: .rock, action: { _ in })
                WeaponButton(type: .scissors, action: { _ in })
            }
        }
    }
}
