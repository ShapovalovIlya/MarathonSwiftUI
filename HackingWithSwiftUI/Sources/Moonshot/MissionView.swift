//
//  MissionView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 06.08.2023.
//

import SwiftUI
import Shared

struct MissionView: View {
    let mission: Mission
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack{
                    Image(mission.image, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                    
                    
                }
            }
        }
    }
}

#Preview {
    MissionView(mission: .sample[0])
}
