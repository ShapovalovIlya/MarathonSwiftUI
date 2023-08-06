//
//  MissionRow.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 06.08.2023.
//

import SwiftUI
import Shared

struct MissionRow: View, Equatable {
    private struct Drawing {
        static let imageSize: CGFloat = 100
        static let cornerRadius: CGFloat = 10
        static let opacity: Double = 0.5
    }
    
    let mission: Mission
    
    var body: some View {
        VStack {
            Image(mission.image, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(
                    width: Drawing.imageSize,
                    height: Drawing.imageSize
                )
                .padding()
            
            VStack {
                Text(mission.displayName)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(mission.formattedLaunchDate)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(Drawing.opacity))
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(.lightBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                .stroke(.lightBackground)
        }
    }
    
    static func == (lhs: MissionRow, rhs: MissionRow) -> Bool {
        return lhs.mission == rhs.mission
    }
}

#Preview {
    VStack {
        MissionRow(mission: .sample[0])
        MissionRow(mission: .sample[1])
        MissionRow(mission: .sample[2])
    }
}
