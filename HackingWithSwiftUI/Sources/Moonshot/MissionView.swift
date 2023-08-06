//
//  MissionView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 06.08.2023.
//

import SwiftUI
import Shared


struct MissionView: View, Equatable {
    private struct Drawing {
        static let bottomPadding: CGFloat = 5
    }
    
    struct CrewMember: Equatable {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack{
                    Image(mission.image, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                    
                    VStack(alignment: .leading) {
                        Text("Crew")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                            .padding(.bottom, Drawing.bottomPadding)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(crew, id: \.role) { member in
                                    NavigationLink {
                                        AstronautView(astronaut: member.astronaut)
                                    } label: {
                                        MemberRow(member: member)
                                            .equatable()
                                    }
                                }
                            }
                        }
                        CustomDivider()
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, Drawing.bottomPadding)
                        Text(mission.description)
                        CustomDivider()
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map{ member in
            guard let astronaut = astronauts[member.name] else {
                fatalError("Missing \(member.name)")
            }
            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
    
    static func == (lhs: MissionView, rhs: MissionView) -> Bool {
        return lhs.mission == rhs.mission &&
        lhs.crew == rhs.crew
    }
    
}

extension MissionView {
    struct CustomDivider: View {
        var body: some View {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.lightBackground)
                .padding(.vertical)
        }
    }
}

#Preview {
    NavigationStack {
        MissionView(mission: .sample[0], astronauts: Astronaut.sample)
    }
    .preferredColorScheme(.dark)
}
