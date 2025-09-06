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
    
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.largePadding) {
                    // Header
                    headerView
                    
                    // Today's Meal Card
                    todaysMealCard
                    
                    // Nutrition Summary
                    nutritionSummaryCards
                    
                    // Add Food Button
                    addFoodButton
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, AppTheme.mediumPadding)
            }
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddFood) {
            AddFoodView()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Your Daily")
                        .font(AppTheme.titleFont)
                        .foregroundColor(AppTheme.darkGray)
                    Text("Intake")
                        .font(AppTheme.titleFont)
                        .foregroundColor(AppTheme.darkGray)
                }
                Spacer()
                
                // Date
                Text(Date(), style: .date)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
            }
        }
        .padding(.top, AppTheme.largePadding)
    }
    
    private var todaysMealCard: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            if let latestMeal = todaysFoodLogs.first {
                HStack {
                    // Food Image Placeholder
                    Circle()
                        .fill(AppTheme.beige)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.title2)
                                .foregroundColor(AppTheme.forestGreen)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(latestMeal.displayName)
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.darkGray)
                        
                        Text(latestMeal.mealType.capitalized)
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.darkGray.opacity(0.7))
                        
                        Text("\(Int(latestMeal.portionSize))g")
                            .font(AppTheme.smallFont)
                            .foregroundColor(AppTheme.darkGray.opacity(0.6))
                    }
                    
                    Spacer()
                }
            } else {
                VStack(spacing: AppTheme.mediumPadding) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.forestGreen)
                    
                    Text("No meals logged today")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    
                    Text("Tap + Add Food to get started")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.5))
                }
                .padding(.vertical, AppTheme.largePadding)
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private var nutritionSummaryCards: some View {
        let totalNutrition = calculateTotalNutrition()
        
        return VStack(spacing: AppTheme.mediumPadding) {
            // Calories Card
            nutritionCard(
                title: "Calories",
                value: Int(totalNutrition.calories),
                unit: "",
                progress: totalNutrition.calories / 1650, // Default goal
                color: AppTheme.forestGreen
            )
            
            HStack(spacing: AppTheme.mediumPadding) {
                // Protein Card
                nutritionCard(
                    title: "Protein",
                    value: Int(totalNutrition.protein),
                    unit: "g",
                    progress: totalNutrition.protein / 80, // Default goal
                    color: AppTheme.primaryGreen
                )
                
                // Fiber Card
                nutritionCard(
                    title: "Fibre",
                    value: Int(totalNutrition.fiber),
                    unit: "g",
                    progress: totalNutrition.fiber / 25, // Default goal
                    color: AppTheme.navy
                )
            }
        }
    }
    
    private func nutritionCard(title: String, value: Int, unit: String, progress: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
            
            HStack(alignment: .bottom) {
                Text("\(value)")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.darkGray)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                        .padding(.bottom, 2)
                }
                
                Spacer()
            }
            
            // Progress Bar
            AnimatedProgressBar(
                progress: progress,
                color: color,
                height: 4
            )
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private var addFoodButton: some View {
        Button(action: {
            showingAddFood = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.title3)
                Text("Add Food")
                    .font(AppTheme.bodyFont)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.forestGreen)
            .cornerRadius(AppTheme.smallRadius)
        }
    }
    
    private func calculateTotalNutrition() -> NutritionData {
        return todaysFoodLogs.reduce(NutritionData.zero) { result, log in
            NutritionData(
                calories: result.calories + log.totalCalories,
                protein: result.protein + log.totalProtein,
                fiber: result.fiber + log.totalFiber
            )
        }
    }
}

#Preview {
    DailyIntakeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
