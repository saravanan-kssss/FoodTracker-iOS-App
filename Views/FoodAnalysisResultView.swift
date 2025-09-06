import SwiftUI
import CoreData

struct FoodAnalysisResultView: View {
    let result: FoodAnalysisResult
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var quantity = 1.0
    @State private var unit = "serving"
    @State private var mealType = MealType.breakfast
    @State private var notes = ""
    @State private var showingSuccessAlert = false
    
    let units = ["serving", "piece", "cup", "bowl", "50g", "100g", "150g", "200g"]
    
    var adjustedNutrition: NutritionData {
        let multiplier = calculateMultiplier()
        return NutritionData(
            calories: Int(Double(result.nutrition.calories) * multiplier),
            protein: result.nutrition.protein * multiplier,
            carbs: result.nutrition.carbs * multiplier,
            fat: result.nutrition.fat * multiplier,
            fiber: result.nutrition.fiber * multiplier
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    analysisHeaderSection
                    nutritionDisplaySection
                    portionAdjustmentSection
                    aiSuggestionsSection
                    mealDetailsSection
                    addToLogButton
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Analysis Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.forestGreen)
                }
            }
        }
        .alert("Food Added!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your food has been added to today's log.")
        }
    }
    
    private var analysisHeaderSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Food Identified!")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.navy)
            
            Text(result.foodName)
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.forestGreen)
            
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(AppTheme.forestGreen)
                
                Text("Confidence: \(Int(result.confidence * 100))%")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
            }
        }
        .cardStyle()
        .padding(.vertical, AppTheme.paddingMedium)
    }
    
    private var nutritionDisplaySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Nutrition Information")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            Text("Per \(quantity, specifier: "%.1f") \(unit)")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.paddingMedium) {
                nutritionCard(
                    title: "Calories",
                    value: "\(adjustedNutrition.calories)",
                    unit: "cal",
                    color: AppTheme.forestGreen,
                    icon: "flame.fill"
                )
                
                nutritionCard(
                    title: "Protein",
                    value: "\(adjustedNutrition.protein, specifier: "%.1f")",
                    unit: "g",
                    color: .blue,
                    icon: "figure.strengthtraining.traditional"
                )
                
                nutritionCard(
                    title: "Carbs",
                    value: "\(adjustedNutrition.carbs, specifier: "%.1f")",
                    unit: "g",
                    color: .orange,
                    icon: "leaf.fill"
                )
                
                nutritionCard(
                    title: "Fiber",
                    value: "\(adjustedNutrition.fiber, specifier: "%.1f")",
                    unit: "g",
                    color: .green,
                    icon: "heart.fill"
                )
            }
        }
        .cardStyle()
    }
    
    private func nutritionCard(title: String, value: String, unit: String, color: Color, icon: String) -> some View {
        VStack(spacing: AppTheme.paddingSmall) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(AppTheme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(AppTheme.smallFont)
                    .foregroundColor(AppTheme.warmGray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.paddingMedium)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private var portionAdjustmentSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Adjust Portion Size")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            HStack(spacing: AppTheme.paddingMedium) {
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Quantity")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    TextField("1.0", value: $quantity, format: .number)
                        .keyboardType(.decimalPad)
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Unit")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    Picker("Unit", selection: $unit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .customTextFieldStyle()
                }
            }
        }
        .cardStyle()
    }
    
    private var aiSuggestionsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                
                Text("AI Suggestions")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.navy)
            }
            
            ForEach(result.suggestions, id: \.self) { suggestion in
                HStack(alignment: .top, spacing: AppTheme.paddingSmall) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                        .padding(.top, 2)
                    
                    Text(suggestion)
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
            }
        }
        .cardStyle()
    }
    
    private var mealDetailsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Meal Details")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                Text("Meal Type")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
                
                Picker("Meal Type", selection: $mealType) {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Text("\(meal.emoji) \(meal.rawValue)").tag(meal)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                Text("Notes (Optional)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
                
                TextField("Add any notes about this meal", text: $notes)
                    .customTextFieldStyle()
            }
        }
        .cardStyle()
    }
    
    private var addToLogButton: some View {
        Button("Add to Food Log") {
            addToFoodLog()
        }
        .primaryButtonStyle()
    }
    
    private func calculateMultiplier() -> Double {
        switch unit.lowercased() {
        case "piece", "pieces":
            return quantity * 0.5
        case "cup", "cups":
            return quantity * 1.5
        case "bowl", "bowls":
            return quantity * 2.0
        case "50g":
            return quantity * 0.5
        case "100g":
            return quantity * 1.0
        case "150g":
            return quantity * 1.5
        case "200g":
            return quantity * 2.0
        case "serving":
            return quantity * 1.0
        default:
            return quantity * 1.0
        }
    }
    
    private func addToFoodLog() {
        let nutrition = adjustedNutrition
        
        let foodLog = FoodLog(context: viewContext)
        foodLog.id = UUID()
        foodLog.foodName = result.foodName
        foodLog.quantity = quantity
        foodLog.unit = unit
        foodLog.calories = Int32(nutrition.calories)
        foodLog.protein = nutrition.protein
        foodLog.carbs = nutrition.carbs
        foodLog.fat = nutrition.fat
        foodLog.fiber = nutrition.fiber
        foodLog.mealType = mealType.rawValue
        foodLog.notes = notes.isEmpty ? nil : notes
        foodLog.loggedAt = Date()
        foodLog.createdAt = Date()
        
        do {
            try viewContext.save()
            showingSuccessAlert = true
        } catch {
            print("Error saving food log: \(error)")
        }
    }
}

#Preview {
    let sampleResult = FoodAnalysisResult(
        foodName: "Idli",
        confidence: 0.92,
        nutrition: NutritionData(calories: 58, protein: 2.0, carbs: 12.0, fat: 0.1, fiber: 0.6),
        suggestions: [
            "Great source of probiotics from fermentation",
            "Pair with sambar for complete protein",
            "Low in fat and easy to digest"
        ]
    )
    
    return FoodAnalysisResultView(result: sampleResult)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
