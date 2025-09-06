import SwiftUI
import CoreData
import Charts

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodLog.loggedAt, ascending: false)],
        animation: .default)
    private var allFoodLogs: FetchedResults<FoodLog>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserProfile.createdAt, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<UserProfile>
    
    @State private var selectedTimeRange = TimeRange.week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    if let profile = profiles.first {
                        timeRangeSelector
                        weeklyOverviewSection(profile: profile)
                        nutritionTrendsSection
                        mealDistributionSection
                        insightsSection
                    } else {
                        Text("Please set up your profile first")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.warmGray)
                    }
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var timeRangeSelector: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .cardStyle()
    }
    
    private func weeklyOverviewSection(profile: UserProfile) -> some View {
        let weeklyData = getWeeklyData()
        
        return VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Weekly Overview")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            HStack(spacing: AppTheme.paddingMedium) {
                overviewCard(
                    title: "Avg Calories",
                    value: "\(Int(weeklyData.averageCalories))",
                    subtitle: "per day",
                    color: AppTheme.forestGreen,
                    progress: weeklyData.averageCalories / Double(profile.dailyCalorieGoal)
                )
                
                overviewCard(
                    title: "Days Logged",
                    value: "\(weeklyData.daysLogged)",
                    subtitle: "this week",
                    color: .blue,
                    progress: Double(weeklyData.daysLogged) / 7.0
                )
            }
            
            HStack(spacing: AppTheme.paddingMedium) {
                overviewCard(
                    title: "Avg Protein",
                    value: "\(Int(weeklyData.averageProtein))g",
                    subtitle: "per day",
                    color: .purple,
                    progress: weeklyData.averageProtein / (Double(profile.dailyCalorieGoal) * 0.175 / 4.0)
                )
                
                overviewCard(
                    title: "Meals Logged",
                    value: "\(weeklyData.totalMeals)",
                    subtitle: "this week",
                    color: .orange,
                    progress: Double(weeklyData.totalMeals) / 28.0 // 4 meals per day * 7 days
                )
            }
        }
        .cardStyle()
    }
    
    private func overviewCard(title: String, value: String, subtitle: String, color: Color, progress: Double) -> some View {
        VStack(spacing: AppTheme.paddingSmall) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            Text(value)
                .font(AppTheme.headlineFont)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.warmGray)
            
            CircularProgressBar(
                progress: min(progress, 1.0),
                color: color,
                backgroundColor: color.opacity(0.2),
                lineWidth: 4
            )
            .frame(width: 40, height: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.paddingMedium)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private var nutritionTrendsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Nutrition Trends")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            if #available(iOS 16.0, *) {
                Chart(getDailyNutritionData()) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Calories", data.calories)
                    )
                    .foregroundStyle(AppTheme.forestGreen)
                    .symbol(Circle())
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
            } else {
                // Fallback for iOS 15
                VStack {
                    Text("Nutrition Chart")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    Text("Charts available on iOS 16+")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(AppTheme.lightGray)
                .cornerRadius(AppTheme.cornerRadiusMedium)
            }
        }
        .cardStyle()
    }
    
    private var mealDistributionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Meal Distribution")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            let mealStats = getMealDistribution()
            
            VStack(spacing: AppTheme.paddingSmall) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    let percentage = mealStats[mealType.rawValue] ?? 0
                    mealDistributionRow(
                        mealType: mealType,
                        percentage: percentage
                    )
                }
            }
        }
        .cardStyle()
    }
    
    private func mealDistributionRow(mealType: MealType, percentage: Double) -> some View {
        HStack {
            Text("\(mealType.emoji) \(mealType.rawValue)")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.navy)
            
            Spacer()
            
            Text("\(Int(percentage))%")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            AnimatedProgressBar(
                progress: percentage / 100.0,
                color: mealTypeColor(mealType),
                backgroundColor: AppTheme.lightGray
            )
            .frame(width: 60, height: 6)
        }
    }
    
    private func mealTypeColor(_ mealType: MealType) -> Color {
        switch mealType {
        case .breakfast: return .orange
        case .lunch: return .green
        case .dinner: return .blue
        case .snack: return .purple
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                
                Text("AI Insights")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.navy)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
                ForEach(generateInsights(), id: \.self) { insight in
                    insightRow(insight: insight)
                }
            }
        }
        .cardStyle()
    }
    
    private func insightRow(insight: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.paddingSmall) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
                .padding(.top, 2)
            
            Text(insight)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
        }
    }
    
    // MARK: - Data Processing Methods
    
    private func getWeeklyData() -> WeeklyData {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        let weekLogs = allFoodLogs.filter { log in
            log.loggedAt >= weekAgo && log.loggedAt <= now
        }
        
        let totalCalories = weekLogs.reduce(0) { $0 + Int($1.calories) }
        let totalProtein = weekLogs.reduce(0.0) { $0 + $1.protein }
        let totalMeals = weekLogs.count
        
        let uniqueDays = Set(weekLogs.map { calendar.startOfDay(for: $0.loggedAt) })
        let daysLogged = uniqueDays.count
        
        let averageCalories = daysLogged > 0 ? Double(totalCalories) / Double(daysLogged) : 0
        let averageProtein = daysLogged > 0 ? totalProtein / Double(daysLogged) : 0
        
        return WeeklyData(
            averageCalories: averageCalories,
            averageProtein: averageProtein,
            daysLogged: daysLogged,
            totalMeals: totalMeals
        )
    }
    
    private func getDailyNutritionData() -> [DailyNutritionChart] {
        let calendar = Calendar.current
        let now = Date()
        let daysBack = selectedTimeRange == .week ? 7 : (selectedTimeRange == .month ? 30 : 90)
        let startDate = calendar.date(byAdding: .day, value: -daysBack, to: now) ?? now
        
        var dailyData: [Date: (calories: Int, protein: Double)] = [:]
        
        let filteredLogs = allFoodLogs.filter { log in
            log.loggedAt >= startDate && log.loggedAt <= now
        }
        
        for log in filteredLogs {
            let day = calendar.startOfDay(for: log.loggedAt)
            if dailyData[day] == nil {
                dailyData[day] = (0, 0.0)
            }
            dailyData[day]!.calories += Int(log.calories)
            dailyData[day]!.protein += log.protein
        }
        
        return dailyData.map { date, data in
            DailyNutritionChart(date: date, calories: data.calories, protein: data.protein)
        }.sorted { $0.date < $1.date }
    }
    
    private func getMealDistribution() -> [String: Double] {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        let weekLogs = allFoodLogs.filter { log in
            log.loggedAt >= weekAgo && log.loggedAt <= now
        }
        
        let totalMeals = weekLogs.count
        guard totalMeals > 0 else { return [:] }
        
        var mealCounts: [String: Int] = [:]
        for mealType in MealType.allCases {
            mealCounts[mealType.rawValue] = 0
        }
        
        for log in weekLogs {
            mealCounts[log.mealType, default: 0] += 1
        }
        
        var distribution: [String: Double] = [:]
        for (mealType, count) in mealCounts {
            distribution[mealType] = Double(count) / Double(totalMeals) * 100.0
        }
        
        return distribution
    }
    
    private func generateInsights() -> [String] {
        let weeklyData = getWeeklyData()
        var insights: [String] = []
        
        if weeklyData.daysLogged >= 5 {
            insights.append("Great consistency! You've logged food for \(weeklyData.daysLogged) days this week.")
        } else {
            insights.append("Try to log your meals more consistently for better tracking.")
        }
        
        if weeklyData.averageCalories > 0 {
            if let profile = profiles.first {
                let goalCalories = Double(profile.dailyCalorieGoal)
                if weeklyData.averageCalories < goalCalories * 0.8 {
                    insights.append("You're eating below your calorie goal. Consider adding healthy snacks.")
                } else if weeklyData.averageCalories > goalCalories * 1.2 {
                    insights.append("You're exceeding your calorie goal. Focus on portion control.")
                } else {
                    insights.append("You're maintaining good calorie balance this week!")
                }
            }
        }
        
        let mealDistribution = getMealDistribution()
        if let breakfastPercentage = mealDistribution["Breakfast"], breakfastPercentage < 20 {
            insights.append("Consider eating more breakfast meals for better energy throughout the day.")
        }
        
        if weeklyData.averageProtein > 0 {
            if let profile = profiles.first {
                let proteinGoal = Double(profile.dailyCalorieGoal) * 0.175 / 4.0
                if weeklyData.averageProtein < proteinGoal * 0.8 {
                    insights.append("Try to include more protein-rich foods like dal, eggs, or chicken.")
                }
            }
        }
        
        return insights.isEmpty ? ["Keep logging your meals to get personalized insights!"] : insights
    }
}

// MARK: - Data Models

struct WeeklyData {
    let averageCalories: Double
    let averageProtein: Double
    let daysLogged: Int
    let totalMeals: Int
}

struct DailyNutritionChart {
    let date: Date
    let calories: Int
    let protein: Double
}

#Preview {
    AnalyticsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
