import SwiftUI
import Charts
import CoreData

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodLog.loggedAt, ascending: false)],
        animation: .default)
    private var allFoodLogs: FetchedResults<FoodLog>
    
    @State private var selectedTimeframe: TimeFrame = .week
    @State private var selectedMetric: NutritionMetric = .calories
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.largePadding) {
                    // Header
                    headerView
                    
                    // Weekly Summary Card
                    weeklySummaryCard
                    
                    // Chart Section
                    chartSection
                    
                    // Insights Section
                    insightsSection
                    
                    // Goal Progress
                    goalProgressSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, AppTheme.mediumPadding)
            }
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text("Analytics")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.darkGray)
            
            Text("Track your nutrition progress over time")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppTheme.largePadding)
    }
    
    private var weeklySummaryCard: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            HStack {
                Text("Weekly Summary")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Spacer()
                
                // Day selector
                HStack(spacing: 4) {
                    ForEach(["D", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(AppTheme.captionFont)
                            .foregroundColor(day == "W" ? .white : AppTheme.darkGray.opacity(0.7))
                            .frame(width: 24, height: 24)
                            .background(day == "W" ? AppTheme.forestGreen : Color.clear)
                            .clipShape(Circle())
                    }
                }
            }
            
            // Weekly chart bars
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(weeklyData, id: \.day) { data in
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(data.day == "W" ? AppTheme.forestGreen : AppTheme.beige)
                            .frame(width: 20, height: CGFloat(data.value) * 2)
                            .cornerRadius(2)
                        
                        Text(data.day)
                            .font(AppTheme.smallFont)
                            .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    }
                }
            }
            .frame(height: 120)
            
            // Summary stats
            HStack(spacing: AppTheme.largePadding) {
                summaryStatItem(title: "Calories", value: "1650")
                summaryStatItem(title: "Avg Daily", value: "1420")
                summaryStatItem(title: "Goal Met", value: "5/7")
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func summaryStatItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppTheme.bodyFont)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.darkGray)
            
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
        }
    }
    
    private var chartSection: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            // Chart controls
            HStack {
                Text("Nutrition Trends")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Spacer()
                
                // Metric selector
                Picker("Metric", selection: $selectedMetric) {
                    ForEach(NutritionMetric.allCases, id: \.self) { metric in
                        Text(metric.displayName).tag(metric)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            // Chart
            if #available(iOS 16.0, *) {
                Chart(chartData) { item in
                    LineMark(
                        x: .value("Day", item.date),
                        y: .value(selectedMetric.displayName, item.value)
                    )
                    .foregroundStyle(AppTheme.forestGreen)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    PointMark(
                        x: .value("Day", item.date),
                        y: .value(selectedMetric.displayName, item.value)
                    )
                    .foregroundStyle(AppTheme.forestGreen)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            } else {
                // Fallback for iOS 15
                VStack {
                    Text("Chart requires iOS 16+")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    
                    // Simple bar representation
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<7) { index in
                            Rectangle()
                                .fill(AppTheme.forestGreen)
                                .frame(width: 30, height: CGFloat.random(in: 50...150))
                                .cornerRadius(4)
                        }
                    }
                }
                .frame(height: 200)
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            Text("AI Insights")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            VStack(spacing: AppTheme.mediumPadding) {
                insightCard(
                    icon: "lightbulb",
                    title: "Great Progress!",
                    description: "You've been consistent with logging meals this week. Your average calorie intake is well-balanced.",
                    color: AppTheme.forestGreen
                )
                
                insightCard(
                    icon: "leaf",
                    title: "Increase Fiber",
                    description: "Consider adding more vegetables and whole grains to reach your daily fiber goal of 25g.",
                    color: AppTheme.primaryGreen
                )
                
                insightCard(
                    icon: "flame",
                    title: "Calorie Distribution",
                    description: "Your Tamil cuisine choices are nutritionally balanced. Keep exploring traditional recipes!",
                    color: AppTheme.navy
                )
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func insightCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: AppTheme.mediumPadding) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.bodyFont)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.darkGray)
                
                Text(description)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(AppTheme.smallPadding)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.smallRadius)
    }
    
    private var goalProgressSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            Text("Daily Goals Progress")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            VStack(spacing: AppTheme.mediumPadding) {
                goalProgressBar(title: "Calories", current: 1420, goal: 1650, color: AppTheme.forestGreen)
                goalProgressBar(title: "Protein", current: 65, goal: 80, color: AppTheme.primaryGreen)
                goalProgressBar(title: "Fiber", current: 18, goal: 25, color: AppTheme.navy)
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func goalProgressBar(title: String, current: Int, goal: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            HStack {
                Text(title)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Spacer()
                
                Text("\(current)/\(goal)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppTheme.lightGray)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * min(Double(current) / Double(goal), 1.0), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
    
    // Sample data
    private var weeklyData: [WeeklyDataPoint] {
        [
            WeeklyDataPoint(day: "M", value: 45),
            WeeklyDataPoint(day: "T", value: 52),
            WeeklyDataPoint(day: "W", value: 60),
            WeeklyDataPoint(day: "T", value: 48),
            WeeklyDataPoint(day: "F", value: 55),
            WeeklyDataPoint(day: "S", value: 42),
            WeeklyDataPoint(day: "S", value: 38)
        ]
    }
    
    private var chartData: [ChartDataPoint] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let value: Double
            
            switch selectedMetric {
            case .calories:
                value = Double.random(in: 1200...1800)
            case .protein:
                value = Double.random(in: 40...90)
            case .fiber:
                value = Double.random(in: 15...30)
            }
            
            return ChartDataPoint(date: date, value: value)
        }.reversed()
    }
}

// MARK: - Supporting Types
enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

enum NutritionMetric: String, CaseIterable {
    case calories = "Calories"
    case protein = "Protein"
    case fiber = "Fiber"
    
    var displayName: String {
        return rawValue
    }
}

struct WeeklyDataPoint {
    let day: String
    let value: Double
}

struct ChartDataPoint {
    let date: Date
    let value: Double
}

#Preview {
    AnalyticsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
