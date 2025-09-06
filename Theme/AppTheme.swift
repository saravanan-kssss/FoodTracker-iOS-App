import SwiftUI

struct AppTheme {
    // Old Money Color Palette
    static let cream = Color(red: 0.96, green: 0.94, blue: 0.89)
    static let beige = Color(red: 0.89, green: 0.85, blue: 0.78)
    static let lightBeige = Color(red: 0.94, green: 0.91, blue: 0.86)
    static let forestGreen = Color(red: 0.20, green: 0.35, blue: 0.31)
    static let primaryGreen = Color(red: 0.25, green: 0.42, blue: 0.37)
    static let navy = Color(red: 0.15, green: 0.20, blue: 0.35)
    static let darkGray = Color(red: 0.25, green: 0.25, blue: 0.25)
    static let lightGray = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    // Typography
    static let titleFont = Font.custom("Playfair Display", size: 24).weight(.semibold)
    static let headlineFont = Font.custom("Playfair Display", size: 20).weight(.medium)
    static let bodyFont = Font.custom("Source Serif Pro", size: 16)
    static let captionFont = Font.custom("Source Serif Pro", size: 14)
    static let smallFont = Font.custom("Source Serif Pro", size: 12)
    
    // Spacing
    static let smallPadding: CGFloat = 8
    static let mediumPadding: CGFloat = 16
    static let largePadding: CGFloat = 24
    static let extraLargePadding: CGFloat = 32
    
    // Corner Radius
    static let smallRadius: CGFloat = 8
    static let mediumRadius: CGFloat = 12
    static let largeRadius: CGFloat = 16
}

// Custom View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cream)
            .cornerRadius(AppTheme.mediumRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(AppTheme.forestGreen)
            .cornerRadius(AppTheme.smallRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
