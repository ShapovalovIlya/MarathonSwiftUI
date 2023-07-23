//
//  EnemyWeaponLabel.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI

struct EnemyWeaponLabel: View, Equatable {
    let weapon: WeaponType
    
    private let transition: AnyTransition = .slide
    
    var body: some View {
        VStack {
            Text("Enemy weapon:")
            Group {
                switch weapon {
                case .rock:
                    Image(systemName: weapon.imageName)
                        .resizable()
                case .paper:
                    Image(systemName: weapon.imageName)
                        .resizable()
                case .scissors:
                    Image(systemName: weapon.imageName)
                        .resizable()
                }
            }
            .frame(width: 100, height: 80)
            .animation(.easeInOut, value: weapon)
            .transition(transition)
        }
        .foregroundColor(.indigo)
        .padding()
        .background(Material.thinMaterial)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    static func == (lhs: EnemyWeaponLabel, rhs: EnemyWeaponLabel) -> Bool {
        lhs.weapon == rhs.weapon
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            VStack {
                EnemyWeaponLabel(weapon: .rock)
            }
        }
    }
}
