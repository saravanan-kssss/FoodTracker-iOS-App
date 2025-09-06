import SwiftUI
import CoreData

struct FoodAnalysisResultView: View {
    let result: FoodAnalysisResult
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var portionSize: String = "150"
    @State private var selectedMealType = MealType.breakfast
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.largePadding) {
                    // Header
                    headerView
                    
                    // Food Information Card
                    foodInfoCard
                    
                    // Portion Size Adjustment
                    portionSizeSection
                    
                    // Meal Type Selection
                    mealTypeSelection
                    
                    // Notes Section
                    notesSection
                    
                    // Add to Log Button
                    addToLogButton
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, AppTheme.mediumPadding)
            }
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(AppTheme.bodyFont)
            .foregroundColor(AppTheme.darkGray)
            
            Spacer()
            
            Text("Food Analysis")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.darkGray)
            
            Spacer()
            
            Button("Add") {
                addToFoodLog()
            }
            .font(AppTheme.bodyFont)
            .foregroundColor(AppTheme.forestGreen)
        }
        .padding(.top, AppTheme.mediumPadding)
    }
    
    private var foodInfoCard: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            // Food Name and Category
            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                HStack {
                    Text(result.foodName)
                        .font(AppTheme.titleFont)
                        .foregroundColor(AppTheme.darkGray)
                    
                    Spacer()
                    
                    if result.isTamil {
                        Text("Tamil")
                            .font(AppTheme.captionFont)
                            .foregroundColor(.white)
                            .padding(.horizontal, AppTheme.smallPadding)
                            .padding(.vertical, 2)
                            .background(AppTheme.forestGreen)
                            .cornerRadius(AppTheme.smallRadius)
                    }
                }
                
                Text(result.category)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                
                // Confidence Score
                HStack {
                    Text("Confidence:")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    
                    Text("\(Int(result.confidence * 100))%")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.forestGreen)
                        .fontWeight(.medium)
                }
            }
            
            Divider()
                .background(AppTheme.lightGray)
            
            // Nutrition Information
            VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
                Text("Estimated Nutrition (per 100g)")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                HStack(spacing: AppTheme.largePadding) {
                    nutritionItem(title: "Calories", value: "\(Int(result.calories))", unit: "")
                    nutritionItem(title: "Protein", value: "\(Int(result.protein))", unit: "g")
                    nutritionItem(title: "Fiber", value: "\(Int(result.fiber))", unit: "g")
                }
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func nutritionItem(title: String, value: String, unit: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.darkGray)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                        .padding(.bottom, 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var portionSizeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            Text("Portion Size")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            HStack {
                TextField("150", text: $portionSize)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(CustomTextFieldStyle())
                    .frame(width: 100)
                
                Text("grams")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                
                Spacer()
                
                // Quick portion buttons
                HStack(spacing: AppTheme.smallPadding) {
                    portionButton("50g", value: "50")
                    portionButton("100g", value: "100")
                    portionButton("200g", value: "200")
                }
            }
            
            // Adjusted nutrition display
            if let portion = Double(portionSize) {
                adjustedNutritionView(portion: portion)
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func portionButton(_ title: String, value: String) -> some View {
        Button(action: {
            portionSize = value
        }) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.forestGreen)
                .padding(.horizontal, AppTheme.smallPadding)
                .padding(.vertical, 4)
                .background(AppTheme.cream)
                .cornerRadius(AppTheme.smallRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                        .stroke(AppTheme.forestGreen, lineWidth: 1)
                )
        }
    }
    
    private func adjustedNutritionView(portion: Double) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text("Your portion will contain:")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
            
            HStack(spacing: AppTheme.largePadding) {
                HStack {
                    Text("\(Int(result.calories * portion / 100))")
                        .font(AppTheme.bodyFont)
                        .fontWeight(.medium)
                    Text("cal")
                        .font(AppTheme.captionFont)
                }
                .foregroundColor(AppTheme.darkGray)
                
                HStack {
                    Text("\(Int(result.protein * portion / 100))")
                        .font(AppTheme.bodyFont)
                        .fontWeight(.medium)
                    Text("g protein")
                        .font(AppTheme.captionFont)
                }
                .foregroundColor(AppTheme.darkGray)
                
                HStack {
                    Text("\(Int(result.fiber * portion / 100))")
                        .font(AppTheme.bodyFont)
                        .fontWeight(.medium)
                    Text("g fiber")
                        .font(AppTheme.captionFont)
                }
                .foregroundColor(AppTheme.darkGray)
            }
        }
        .padding(AppTheme.smallPadding)
        .background(AppTheme.beige.opacity(0.5))
        .cornerRadius(AppTheme.smallRadius)
    }
    
    private var mealTypeSelection: some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            Text("Meal Type")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            HStack(spacing: AppTheme.smallPadding) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    Button(action: {
                        selectedMealType = mealType
                    }) {
                        VStack(spacing: AppTheme.smallPadding) {
                            Image(systemName: mealType.icon)
                                .font(.title2)
                                .foregroundColor(selectedMealType == mealType ? .white : AppTheme.forestGreen)
                            
                            Text(mealType.displayName)
                                .font(AppTheme.captionFont)
                                .foregroundColor(selectedMealType == mealType ? .white : AppTheme.darkGray)
                        }
                        .padding(.vertical, AppTheme.smallPadding)
                        .frame(maxWidth: .infinity)
                        .background(selectedMealType == mealType ? AppTheme.forestGreen : AppTheme.cream)
                        .cornerRadius(AppTheme.smallRadius)
                    }
                }
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text("Notes (Optional)")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
            
            TextField("Add any notes about this meal...", text: $notes, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(CustomTextFieldStyle())
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private var addToLogButton: some View {
        Button(action: addToFoodLog) {
            Text("Add to Food Log")
                .font(AppTheme.bodyFont)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppTheme.forestGreen)
                .cornerRadius(AppTheme.smallRadius)
        }
    }
    
    private func addToFoodLog() {
        guard let portionValue = Double(portionSize) else { return }
        
        // Create food item
        let foodItem = FoodItem(context: viewContext)
        foodItem.id = UUID()
        foodItem.name = result.foodName
        foodItem.category = result.category
        foodItem.caloriesPerGram = result.calories / 100
        foodItem.proteinPerGram = result.protein / 100
        foodItem.fiberPerGram = result.fiber / 100
        foodItem.isIndian = result.category.contains("Indian")
        foodItem.isTamil = result.isTamil
        foodItem.createdAt = Date()
        
        // Create food log
        let foodLog = FoodLog(context: viewContext)
        foodLog.id = UUID()
        foodLog.portionSize = portionValue
        foodLog.totalCalories = result.calories * portionValue / 100
        foodLog.totalProtein = result.protein * portionValue / 100
        foodLog.totalFiber = result.fiber * portionValue / 100
        foodLog.mealType = selectedMealType.rawValue
        foodLog.loggedAt = Date()
        foodLog.notes = notes.isEmpty ? nil : notes
        foodLog.foodItem = foodItem
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving food log: \(error)")
        }
    }
}

#Preview {
    FoodAnalysisResultView(result: FoodAnalysisResult(
        foodName: "Idli",
        category: "South Indian",
        calories: 150,
        protein: 6,
        fiber: 2,
        confidence: 0.92,
        isTamil: true
    ))
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
