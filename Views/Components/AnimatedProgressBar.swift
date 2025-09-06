import SwiftUI

struct AnimatedProgressBar: View {
    let progress: Double
    let color: Color
    let backgroundColor: Color
    let height: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    init(progress: Double, color: Color = AppTheme.forestGreen, backgroundColor: Color = AppTheme.lightGray, height: CGFloat = 8) {
        self.progress = progress
        self.color = color
        self.backgroundColor = backgroundColor
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(height: height)
                    .cornerRadius(height / 2)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * min(animatedProgress, 1.0), height: height)
                    .cornerRadius(height / 2)
                    .animation(.easeInOut(duration: 1.0), value: animatedProgress)
            }
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newProgress
            }
        }
    }
}

struct PulsingView: View {
    @State private var isPulsing = false
    let color: Color
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.3))
            .frame(width: size, height: size)
            .scaleEffect(isPulsing ? 1.2 : 1.0)
            .opacity(isPulsing ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

struct SlideInView<Content: View>: View {
    let content: Content
    let direction: SlideDirection
    let delay: Double
    
    @State private var isVisible = false
    
    enum SlideDirection {
        case left, right, top, bottom
    }
    
    init(direction: SlideDirection = .bottom, delay: Double = 0, @ViewBuilder content: () -> Content) {
        self.direction = direction
        self.delay = delay
        self.content = content()
    }
    
    var body: some View {
        content
            .offset(
                x: isVisible ? 0 : offsetX,
                y: isVisible ? 0 : offsetY
            )
            .opacity(isVisible ? 1 : 0)
            .animation(.easeOut(duration: 0.6).delay(delay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
    
    private var offsetX: CGFloat {
        switch direction {
        case .left: return -100
        case .right: return 100
        default: return 0
        }
    }
    
    private var offsetY: CGFloat {
        switch direction {
        case .top: return -100
        case .bottom: return 100
        default: return 0
        }
    }
}

struct ScaleInView<Content: View>: View {
    let content: Content
    let delay: Double
    
    @State private var isVisible = false
    
    init(delay: Double = 0, @ViewBuilder content: () -> Content) {
        self.delay = delay
        self.content = content()
    }
    
    var body: some View {
        content
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        AnimatedProgressBar(progress: 0.7)
            .frame(height: 8)
        
        PulsingView(color: AppTheme.forestGreen, size: 50)
        
        SlideInView(direction: .left) {
            Text("Slide from left")
                .padding()
                .background(AppTheme.cream)
                .cornerRadius(8)
        }
        
        ScaleInView(delay: 0.3) {
            Text("Scale in")
                .padding()
                .background(AppTheme.beige)
                .cornerRadius(8)
        }
    }
    .padding()
}
