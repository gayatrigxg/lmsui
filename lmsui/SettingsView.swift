import SwiftUI

// MARK: - Main Settings View
struct SettingsView: View {
    @EnvironmentObject var router: Router
    @State private var faceIDEnabled = true
    @State private var notificationsEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Preferences
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preferences").font(.caption).foregroundColor(.secondary).padding(.horizontal, 20)
                    VStack(spacing: 0) {
                        SettingsNavRow(icon: "globe", title: "Language", value: "English") { router.push(.languageSelection) }
                        Divider().padding(.leading, 56)
                        SettingsNavRow(icon: "figure.accessibility", title: "Accessibility") { router.push(.accessibilitySettings) }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                // Security & Alerts
                VStack(alignment: .leading, spacing: 8) {
                    Text("Security & Alerts").font(.caption).foregroundColor(.secondary).padding(.horizontal, 20)
                    VStack(spacing: 0) {
                        SettingsToggleRow(icon: "faceid", title: "Face ID / Biometrics", isOn: $faceIDEnabled)
                        Divider().padding(.leading, 56)
                        SettingsToggleRow(icon: "bell.fill", title: "Push Notifications", isOn: $notificationsEnabled)
                        Divider().padding(.leading, 56)
                        SettingsNavRow(icon: "lock.fill", title: "Change App PIN") { }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                }
                
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Language Selection View
struct LanguageSelectionView: View {
    @State private var selectedLanguage = "English"
    let languages = ["English", "Hindi (हिन्दी)", "Marathi (मराठी)", "Tamil (தமிழ்)", "Telugu (தமிழ்)"]
    
    var body: some View {
        List {
            ForEach(languages, id: \.self) { lang in
                Button {
                    selectedLanguage = lang
                } label: {
                    HStack {
                        Text(lang).foregroundColor(.primary)
                        Spacer()
                        if selectedLanguage == lang {
                            Image(systemName: "checkmark").foregroundColor(.mainBlue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Accessibility Settings View
struct AccessibilitySettingsView: View {
    @State private var highContrast = false
    @State private var reduceMotion = false
    @State private var textSize: Double = 1.0
    
    var body: some View {
        Form {
            Section(header: Text("Display")) {
                Toggle("High Contrast Mode", isOn: $highContrast)
                    .tint(.mainBlue)
                
                VStack(alignment: .leading) {
                    Text("Text Size")
                    Slider(value: $textSize, in: 0.8...1.5, step: 0.1)
                        .accentColor(.mainBlue)
                }
                .padding(.vertical, 4)
            }
            
            Section(header: Text("Animations")) {
                Toggle("Reduce Motion", isOn: $reduceMotion)
                    .tint(.mainBlue)
            }
        }
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings Subcomponents
struct SettingsNavRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon).font(.title3).foregroundColor(.mainBlue).frame(width: 24)
                Text(title).font(.body).foregroundColor(.primary)
                Spacer()
                if let val = value { Text(val).font(.subheadline).foregroundColor(.secondary) }
                Image(systemName: "chevron.right").font(.subheadline).foregroundColor(.secondary.opacity(0.5))
            }
            .padding(16)
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon).font(.title3).foregroundColor(.mainBlue).frame(width: 24)
            Toggle(title, isOn: $isOn)
                .font(.body)
                .tint(.mainBlue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
