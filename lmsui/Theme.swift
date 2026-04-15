import SwiftUI

extension Color {
    static let primaryBlue = Color(hex: "#264BE3")
    static let secondaryBlue = Color(hex: "#002FDC")
    static let appBackground = Color(hex: "#E8F2FA")
    static let accentRed = Color(hex: "#ED1E48")

    static let textPrimary = Color(hex: "#102042")
    static let textSecondary = Color(hex: "#667085")
    static let cardBackground = Color.white
    static let dividerLight = Color(hex: "#D9E2F2")
    static let inactiveStep = Color(hex: "#C9D4E5")
    static let shadowColor = Color.black.opacity(0.06)
}

extension Color {
    init(hex: String) {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8) & 0xFF) / 255
        let blue = Double(rgb & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

enum AppSpacing {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 40
}

enum AppRadius {
    static let card: CGFloat = 20
    static let button: CGFloat = 16
    static let pill: CGFloat = 999
}

enum AppFont {
    static func largeTitle() -> Font {
        .system(size: 30, weight: .bold, design: .default)
    }

    static func title() -> Font {
        .system(size: 18, weight: .semibold, design: .default)
    }

    static func body() -> Font {
        .system(size: 16, weight: .regular, design: .default)
    }

    static func bodyMedium() -> Font {
        .system(size: 16, weight: .medium, design: .default)
    }

    static func button() -> Font {
        .system(size: 17, weight: .medium, design: .default)
    }

    static func caption() -> Font {
        .system(size: 14, weight: .medium, design: .default)
    }
}

struct PrimaryCTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.button())
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(configuration.isPressed ? Color.secondaryBlue : Color.primaryBlue)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous))
            .shadow(color: Color.primaryBlue.opacity(0.18), radius: 10, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
            .shadow(color: Color.shadowColor, radius: 16, x: 0, y: 8)
    }
}

extension View {
    func appCardStyle() -> some View {
        modifier(CardModifier())
    }
}
