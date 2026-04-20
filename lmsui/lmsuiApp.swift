import SwiftUI

@main
struct lmsuiApp: App {
    // 1. Initialize the LanguageManager here
    @StateObject var langManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Inject it into the environment so all child views can access it
                .environmentObject(langManager)
                // 3. Force the entire app's locale to update instantly when changed
                .environment(\.locale, langManager.currentLocale)
        }
    }
}
