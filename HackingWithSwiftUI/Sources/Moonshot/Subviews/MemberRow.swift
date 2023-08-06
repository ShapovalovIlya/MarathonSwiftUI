//
//  MemberRow.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 07.08.2023.
//

import SwiftUI

struct MemberRow: View, Equatable {
    private struct Drawing {
        static let imageSize: CGSize = .init(width: 104, height: 72)
        static let lineWidth: CGFloat = 1
        
    }
    
    let member: MissionView.CrewMember
    
    var body: some View {
        HStack {
            Image(member.astronaut.id, bundle: .module)
                .resizable()
                .frame(
                    width: Drawing.imageSize.width,
                    height: Drawing.imageSize.height
                )
                .clipShape(Capsule())
                .overlay{
                    Capsule()
                        .strokeBorder(.white, lineWidth: Drawing.lineWidth)
                }
            
            VStack(alignment: .leading) {
                Text(member.astronaut.name)
                    .foregroundStyle(.white)
                    .font(.headline)
                Text(member.role)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
    }
    
    static func == (lhs: MemberRow, rhs: MemberRow) -> Bool {
        return lhs.member == rhs.member
    }
}

#Preview {
    MemberRow(member:
            .init(
                role: "Role",
                astronaut: .sample.map(\.value)[0]
            )
    )
    .preferredColorScheme(.dark)
}
