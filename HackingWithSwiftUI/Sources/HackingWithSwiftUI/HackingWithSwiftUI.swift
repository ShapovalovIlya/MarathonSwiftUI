import SwiftUI
import SwiftUDF
import WeSplit
import GuessTheFlag

public struct HackingWithSwiftUIMatathon: View {
    
    public var body: some View {
        TabView {
            AppsTab()
                .tabItem { Label("App", systemImage: "iphone.gen3") }
            GamesTab()
                .tabItem { Label("Game", systemImage: "gamecontroller") }
        }
    }
    
    public init() {}
}

struct HackingWithSwiftUIMatathon_Previews: PreviewProvider {
    static var previews: some View {
        HackingWithSwiftUIMatathon()
    }
}
