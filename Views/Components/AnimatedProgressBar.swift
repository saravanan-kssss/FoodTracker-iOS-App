import SwiftUI

struct AnimatedProgressBar: View {
    let progress: Double
    let color: Color
    let backgroundColor: Color
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * animatedProgress, height: geometry.size.height)
                    .animation(AppTheme.springAnimation, value: animatedProgress)
            }
        }
        .clipShape(Capsule())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(AppTheme.springAnimation) {
                animatedProgress = newProgress
            }
        }
    }
}

struct CircularProgressBar: View {
    let progress: Double
    let color: Color
    let backgroundColor: Color
    let lineWidth: CGFloat
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(AppTheme.springAnimation, value: animatedProgress)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(AppTheme.springAnimation) {
                animatedProgress = newProgress
            }
        }
    }
}

struct NutritionProgressRing: View {
    let title: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color
    
    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(current / goal, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                CircularProgressBar(
                    progress: progress,
                    color: color,
                    backgroundColor: color.opacity(0.2),
                    lineWidth: 6
                )
                .frame(width: 60, height: 60)
                
                VStack(spacing: 2) {
                    Text("\(Int(current))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.navy)
                    
                    Text(unit)
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.warmGray)
                }
            }
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppTheme.navy)
                .multilineTextAlignment(.center)
            
            Text("of \(Int(goal))")
                .font(.system(size: 10))
                .foregroundColor(AppTheme.warmGray)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        AnimatedProgressBar(
            progress: 0.7,
            color: AppTheme.forestGreen,
            backgroundColor: AppTheme.lightGray
        )
        .frame(height: 8)
        
        HStack(spacing: 20) {
            NutritionProgressRing(
                title: "Calories",
                current: 1450,
                goal: 2000,
                unit: "cal",
                color: AppTheme.forestGreen
            )
            
            NutritionProgressRing(
                title: "Protein",
                current: 65,
                goal: 80,
                unit: "g",
                color: .blue
            )
            
            NutritionProgressRing(
                title: "Fiber",
                current: 22,
                goal: 30,
                unit: "g",
                color: .green
            )
        }
    }
    .padding()
    .background(AppTheme.beige)
}
