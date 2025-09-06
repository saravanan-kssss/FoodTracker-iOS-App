import SwiftUI
import CoreData

struct DailyIntakeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodLog.loggedAt, ascending: false)],
        predicate: NSPredicate(format: "loggedAt >= %@ AND loggedAt < %@", 
                              Calendar.current.startOfDay(for: Date()) as CVarArg,
                              Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as CVarArg),
        animation: .default)
    private var todaysFoodLogs: FetchedResults<FoodLog>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserProfile.createdAt, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<UserProfile>
    
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    if let profile = profiles.first {
                        dailySummaryCard(profile: profile)
                        nutritionProgressCards(profile: profile)
                        mealBreakdownSection
                        recentFoodsSection
                    } else {
                        Text("Please set up your profile first")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.warmGray)
                    }
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Daily Intake")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddFood = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppTheme.forestGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddFood) {
            AddFoodView()
        }
    }
    
    private func dailySummaryCard(profile: UserProfile) -> some View {
        let summary = calculateDailySummary(profile: profile)
        
        return VStack(spacing: AppTheme.paddingMedium) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Today's Progress")
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.navy)
                    
                    Text(Date(), style: .date)
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(summary.totalCalories)")
                        .font(AppTheme.titleFont)
                        .foregroundColor(AppTheme.forestGreen)
                    
                    Text("of \(summary.goalCalories) cal")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
            }
            
            AnimatedProgressBar(
                progress: min(summary.calorieProgress, 1.0),
                color: AppTheme.forestGreen,
                backgroundColor: AppTheme.lightGray
            )
            .frame(height: 8)
            
            HStack {
                progressIndicator(
                    title: "Protein",
                    value: "\(Int(summary.totalProtein))g",
                    progress: min(summary.proteinProgress, 1.0),
                    color: .blue
                )
                
                Spacer()
                
                progressIndicator(
                    title: "Fiber",
                    value: "\(Int(summary.totalFiber))g",
                    progress: min(summary.fiberProgress, 1.0),
                    color: .green
                )
                
                Spacer()
                
                progressIndicator(
                    title: "Meals",
                    value: "\(todaysFoodLogs.count)",
                    progress: min(Double(todaysFoodLogs.count) / 4.0, 1.0),
                    color: .orange
                )
            }
        }
        .cardStyle()
        .padding(.vertical, AppTheme.paddingMedium)
    }
    
    private func progressIndicator(title: String, value: String, progress: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            Text(value)
                .font(AppTheme.bodyFont)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.navy)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, lineWidth: 3)
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(-90))
                .overlay(
                    Circle()
                        .stroke(color.opacity(0.2), lineWidth: 3)
                )
        }
    }
    
    private func nutritionProgressCards(profile: UserProfile) -> some View {
        let summary = calculateDailySummary(profile: profile)
        
        return HStack(spacing: AppTheme.paddingMedium) {
            nutritionCard(
                title: "Calories",
                current: summary.totalCalories,
                goal: summary.goalCalories,
                unit: "cal",
                color: AppTheme.forestGreen,
                progress: summary.calorieProgress
            )
            
            nutritionCard(
                title: "Protein",
                current: Int(summary.totalProtein),
                goal: Int(summary.proteinGoal),
                unit: "g",
                color: .blue,
                progress: summary.proteinProgress
            )
        }
    }
    
    private func nutritionCard(title: String, current: Int, goal: Int, unit: String, color: Color, progress: Double) -> some View {
        VStack(spacing: AppTheme.paddingSmall) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            Text("\(current)")
                .font(AppTheme.headlineFont)
                .foregroundColor(color)
            
            Text("of \(goal) \(unit)")
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.warmGray)
            
            AnimatedProgressBar(
                progress: min(progress, 1.0),
                color: color,
                backgroundColor: AppTheme.lightGray
            )
            .frame(height: 4)
        }
        .cardStyle()
        .frame(maxWidth: .infinity)
    }
    
    private var mealBreakdownSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Meals Today")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            if todaysFoodLogs.isEmpty {
                VStack(spacing: AppTheme.paddingMedium) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 50))
                        .foregroundColor(AppTheme.warmGray)
                    
                    Text("No meals logged today")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    Text("Tap the + button to add your first meal")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                .cardStyle()
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.paddingLarge)
            } else {
                LazyVStack(spacing: AppTheme.paddingSmall) {
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        let mealLogs = todaysFoodLogs.filter { $0.mealType == mealType.rawValue }
                        if !mealLogs.isEmpty {
                            mealSection(mealType: mealType, logs: Array(mealLogs))
                        }
                    }
                }
            }
        }
    }
    
    private func mealSection(mealType: MealType, logs: [FoodLog]) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
            HStack {
                Text("\(mealType.emoji) \(mealType.rawValue)")
                    .font(AppTheme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.navy)
                
                Spacer()
                
                let totalCalories = logs.reduce(0) { $0 + Int($1.calories) }
                Text("\(totalCalories) cal")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
            }
            
            ForEach(logs, id: \.id) { log in
                foodLogRow(log: log)
            }
        }
        .cardStyle()
    }
    
    private func foodLogRow(log: FoodLog) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(log.foodName)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.navy)
                
                Text("\(log.quantity, specifier: "%.1f") \(log.unit)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(log.calories) cal")
                    .font(AppTheme.captionFont)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.forestGreen)
                
                Text("\(log.protein, specifier: "%.1f")p • \(log.fiber, specifier: "%.1f")f")
                    .font(AppTheme.smallFont)
                    .foregroundColor(AppTheme.warmGray)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var recentFoodsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Quick Add")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.paddingMedium) {
                    ForEach(TamilFoodDatabase.shared.getAllFoods().prefix(6), id: \.name) { food in
                        quickAddFoodCard(food: food)
                    }
                }
                .padding(.horizontal, AppTheme.paddingMedium)
            }
        }
    }
    
    private func quickAddFoodCard(food: TamilFood) -> some View {
        VStack(spacing: AppTheme.paddingSmall) {
            Text(food.name)
                .font(AppTheme.captionFont)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.navy)
                .multilineTextAlignment(.center)
            
            Text("\(food.caloriesPer100g) cal/100g")
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.warmGray)
            
            Button("Add") {
                // Quick add functionality
                addQuickFood(food: food)
            }
            .font(AppTheme.smallFont)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppTheme.forestGreen)
            .cornerRadius(AppTheme.cornerRadiusSmall)
        }
        .cardStyle()
        .frame(width: 100)
    }
    
    private func addQuickFood(food: TamilFood) {
        let foodLog = FoodLog(context: viewContext)
        foodLog.id = UUID()
        foodLog.foodName = food.name
        foodLog.quantity = 1.0
        foodLog.unit = "serving"
        foodLog.calories = food.caloriesPer100g
        foodLog.protein = food.proteinPer100g
        foodLog.carbs = food.carbsPer100g
        foodLog.fat = food.fatPer100g
        foodLog.fiber = food.fiberPer100g
        foodLog.mealType = getCurrentMealType()
        foodLog.loggedAt = Date()
        foodLog.createdAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Error adding quick food: \(error)")
        }
    }
    
    private func getCurrentMealType() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<11:
            return MealType.breakfast.rawValue
        case 11..<16:
            return MealType.lunch.rawValue
        case 16..<20:
            return MealType.dinner.rawValue
        default:
            return MealType.snack.rawValue
        }
    }
    
    private func calculateDailySummary(profile: UserProfile) -> DailyNutritionSummary {
        let totalCalories = todaysFoodLogs.reduce(0) { $0 + Int($1.calories) }
        let totalProtein = todaysFoodLogs.reduce(0.0) { $0 + $1.protein }
        let totalCarbs = todaysFoodLogs.reduce(0.0) { $0 + $1.carbs }
        let totalFat = todaysFoodLogs.reduce(0.0) { $0 + $1.fat }
        let totalFiber = todaysFoodLogs.reduce(0.0) { $0 + $1.fiber }
        
        var mealBreakdown: [String: NutritionData] = [:]
        for mealType in MealType.allCases {
            let mealLogs = todaysFoodLogs.filter { $0.mealType == mealType.rawValue }
            let mealCalories = mealLogs.reduce(0) { $0 + Int($1.calories) }
            let mealProtein = mealLogs.reduce(0.0) { $0 + $1.protein }
            let mealCarbs = mealLogs.reduce(0.0) { $0 + $1.carbs }
            let mealFat = mealLogs.reduce(0.0) { $0 + $1.fat }
            let mealFiber = mealLogs.reduce(0.0) { $0 + $1.fiber }
            
            mealBreakdown[mealType.rawValue] = NutritionData(
                calories: mealCalories,
                protein: mealProtein,
                carbs: mealCarbs,
                fat: mealFat,
                fiber: mealFiber
            )
        }
        
        return DailyNutritionSummary(
            date: Date(),
            totalCalories: totalCalories,
            totalProtein: totalProtein,
            totalCarbs: totalCarbs,
            totalFat: totalFat,
            totalFiber: totalFiber,
            goalCalories: Int(profile.dailyCalorieGoal),
            mealBreakdown: mealBreakdown
        )
    }
}

#Preview {
    DailyIntakeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
