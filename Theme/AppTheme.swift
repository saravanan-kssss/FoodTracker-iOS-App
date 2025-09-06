import SwiftUI

struct AppTheme {
    // MARK: - Colors (Old Money Aesthetic)
    static let primaryColor = Color("PrimaryColor")
    static let secondaryColor = Color("SecondaryColor")
    static let accentColor = Color("AccentColor")
    static let backgroundColor = Color("BackgroundColor")
    static let cardColor = Color("CardColor")
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    
    // Fallback colors if asset catalog is not available
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let beige = Color(red: 0.96, green: 0.93, blue: 0.87)
    static let forestGreen = Color(red: 0.13, green: 0.27, blue: 0.20)
    static let navy = Color(red: 0.12, green: 0.16, blue: 0.25)
    static let warmGray = Color(red: 0.45, green: 0.42, blue: 0.38)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    
    // MARK: - Typography
    static let titleFont = Font.custom("Georgia", size: 28).weight(.bold)
    static let headlineFont = Font.custom("Georgia", size: 22).weight(.semibold)
    static let bodyFont = Font.custom("Georgia", size: 16).weight(.regular)
    static let captionFont = Font.custom("Georgia", size: 14).weight(.regular)
    static let smallFont = Font.custom("Georgia", size: 12).weight(.regular)
    
    // MARK: - Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32
    
    // MARK: - Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    
    // MARK: - Shadows
    static let cardShadow = Color.black.opacity(0.08)
    static let shadowRadius: CGFloat = 8
    static let shadowOffset = CGSize(width: 0, height: 2)
    
    // MARK: - Animation
    static let defaultAnimation = Animation.easeInOut(duration: 0.3)
    static let springAnimation = Animation.spring(response: 0.6, dampingFraction: 0.8)
}

// MARK: - Custom View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cream)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .shadow(
                color: AppTheme.cardShadow,
                radius: AppTheme.shadowRadius,
                x: AppTheme.shadowOffset.width,
                y: AppTheme.shadowOffset.height
            )
    }
}

struct PrimaryButtonStyle: ViewModifier {
    let isEnabled: Bool
    
    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        content
            .font(AppTheme.bodyFont)
            .foregroundColor(.white)
            .padding(.horizontal, AppTheme.paddingLarge)
            .padding(.vertical, AppTheme.paddingMedium)
            .background(isEnabled ? AppTheme.forestGreen : AppTheme.warmGray)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .shadow(
                color: AppTheme.cardShadow,
                radius: 4,
                x: 0,
                y: 2
            )
            .scaleEffect(isEnabled ? 1.0 : 0.95)
            .animation(AppTheme.defaultAnimation, value: isEnabled)
    }
}

struct SecondaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTheme.bodyFont)
            .foregroundColor(AppTheme.forestGreen)
            .padding(.horizontal, AppTheme.paddingLarge)
            .padding(.vertical, AppTheme.paddingMedium)
            .background(AppTheme.beige)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                    .stroke(AppTheme.forestGreen, lineWidth: 1)
            )
    }
}

struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTheme.bodyFont)
            .padding(AppTheme.paddingMedium)
            .background(AppTheme.lightGray)
            .cornerRadius(AppTheme.cornerRadiusSmall)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                    .stroke(AppTheme.warmGray.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        modifier(PrimaryButtonStyle(isEnabled: isEnabled))
    }
    
    func secondaryButtonStyle() -> some View {
        modifier(SecondaryButtonStyle())
    }
    
    func customTextFieldStyle() -> some View {
        modifier(TextFieldStyle())
    }
    
    func slideInFromBottom() -> some View {
        transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    func scaleOnTap() -> some View {
        scaleEffect(1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                // Scale animation handled by button styles
            }
        }
    }
}
