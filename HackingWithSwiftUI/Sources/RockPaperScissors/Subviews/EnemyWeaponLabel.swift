//
//  EnemyWeaponLabel.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI

struct EnemyWeaponLabel: View, Equatable {
    let weapon: WeaponType
    
    var body: some View {
        VStack {
            Text("Enemy weapon:")
                
            Image(systemName: weapon.imageName)
                .resizable()
                .frame(width: 100, height: 80)
            
        }
        .foregroundColor(.indigo)
        .padding()
        .background(Material.thinMaterial)
        .cornerRadius(12)
        .shadow(radius: 5)
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
