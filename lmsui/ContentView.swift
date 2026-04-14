import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    // Ensure the tab bar uses your brand colors
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Your existing Home Dashboard
            HomeDashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            // The new Discovery Screen
            LoanMarketplaceView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(1)
            
            // Placeholder for Future Application Tracking
            Text("Track Applications")
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Track")
                }
                .tag(2)
            
            // Placeholder for Profile
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.mainBlue) // Uses your #002FDC
    }
}

#Preview {
    ContentView()
}
