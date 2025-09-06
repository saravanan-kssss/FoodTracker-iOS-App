import SwiftUI
import CoreData

struct AddFoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var foodName = ""
    @State private var quantity = 1.0
    @State private var unit = "piece"
    @State private var mealType = MealType.breakfast
    @State private var notes = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var fiber = ""
    @State private var showingNutritionPreview = false
    @State private var estimatedNutrition: NutritionData = .zero
    @State private var foodSuggestions: [String] = []
    @State private var isCalculating = false
    
    let units = ["piece", "cup", "bowl", "50g", "100g", "150g", "200g"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    foodInputSection
                    quantitySection
                    aiCalculationSection
                    if showingNutritionPreview {
                        nutritionPreviewSection
                    }
                    manualNutritionSection
                    mealDetailsSection
                    addFoodButton
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.forestGreen)
                }
            }
        }
    }
    
    private var foodInputSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
            Text("Food Name")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.navy)
            
            TextField("Enter food name (e.g., Idli, Dosa, Rice)", text: $foodName)
                .customTextFieldStyle()
                .onChange(of: foodName) { newValue in
                    if newValue.count > 2 {
                        foodSuggestions = AIFoodRecognition.shared.searchFoodSuggestions(query: newValue)
                    } else {
                        foodSuggestions = []
                    }
                }
            
            if !foodSuggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.paddingSmall) {
                        ForEach(foodSuggestions, id: \.self) { suggestion in
                            Button(suggestion) {
                                foodName = suggestion
                                foodSuggestions = []
                                calculateNutritionAI()
                            }
                            .font(AppTheme.captionFont)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppTheme.lightGray)
                            .foregroundColor(AppTheme.navy)
                            .cornerRadius(AppTheme.cornerRadiusSmall)
                        }
                    }
                    .padding(.horizontal, AppTheme.paddingSmall)
                }
            }
        }
        .cardStyle()
    }
    
    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Quantity")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.navy)
            
            HStack(spacing: AppTheme.paddingMedium) {
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Amount")
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
    
    private var aiCalculationSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            HStack {
                VStack(alignment: .leading) {
                    Text("AI Nutrition Calculator")
                        .font(AppTheme.bodyFont)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.navy)
                    
                    Text("Get instant nutrition estimates")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                
                Spacer()
                
                Button {
                    calculateNutritionAI()
                } label: {
                    HStack {
                        if isCalculating {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "brain.head.profile")
                        }
                        Text(isCalculating ? "Calculating..." : "Calculate")
                    }
                }
                .primaryButtonStyle(isEnabled: !foodName.isEmpty && !isCalculating)
                .disabled(foodName.isEmpty || isCalculating)
            }
        }
        .cardStyle()
    }
    
    private var nutritionPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            HStack {
                Text("Nutrition Preview")
                    .font(AppTheme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.navy)
                
                Spacer()
                
                Text("Per \(quantity, specifier: "%.1f") \(unit)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
            }
            
            HStack(spacing: AppTheme.paddingLarge) {
                nutritionItem(title: "Calories", value: "\(estimatedNutrition.calories)", unit: "cal", color: AppTheme.forestGreen)
                nutritionItem(title: "Protein", value: "\(estimatedNutrition.protein, specifier: "%.1f")", unit: "g", color: .blue)
                nutritionItem(title: "Fiber", value: "\(estimatedNutrition.fiber, specifier: "%.1f")", unit: "g", color: .green)
                nutritionItem(title: "Carbs", value: "\(estimatedNutrition.carbs, specifier: "%.1f")", unit: "g", color: .orange)
            }
            
            Button("Use These Values") {
                calories = "\(estimatedNutrition.calories)"
                protein = "\(estimatedNutrition.protein)"
                fiber = "\(estimatedNutrition.fiber)"
            }
            .secondaryButtonStyle()
        }
        .cardStyle()
        .slideInFromBottom()
    }
    
    private func nutritionItem(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            Text(value)
                .font(AppTheme.bodyFont)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(unit)
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.warmGray)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var manualNutritionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Nutrition Information")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.navy)
            
            HStack(spacing: AppTheme.paddingMedium) {
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Calories")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    TextField("0", text: $calories)
                        .keyboardType(.numberPad)
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Protein (g)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    TextField("0.0", text: $protein)
                        .keyboardType(.decimalPad)
                        .customTextFieldStyle()
                }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                Text("Fiber (g)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
                
                TextField("0.0", text: $fiber)
                    .keyboardType(.decimalPad)
                    .customTextFieldStyle()
            }
        }
        .cardStyle()
    }
    
    private var mealDetailsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Meal Details")
                .font(AppTheme.bodyFont)
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
    
    private var addFoodButton: some View {
        Button("Add Food to Log") {
            addFood()
        }
        .primaryButtonStyle(isEnabled: isFormValid)
        .disabled(!isFormValid)
    }
    
    private var isFormValid: Bool {
        !foodName.isEmpty &&
        !calories.isEmpty &&
        !protein.isEmpty &&
        !fiber.isEmpty &&
        Int(calories) != nil &&
        Double(protein) != nil &&
        Double(fiber) != nil
    }
    
    private func calculateNutritionAI() {
        guard !foodName.isEmpty else { return }
        
        isCalculating = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let nutrition = AIFoodRecognition.shared.estimateNutrition(
                foodName: foodName,
                quantity: quantity,
                unit: unit
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(AppTheme.springAnimation) {
                    estimatedNutrition = nutrition
                    showingNutritionPreview = true
                    isCalculating = false
                }
            }
        }
    }
    
    private func addFood() {
        guard let caloriesValue = Int(calories),
              let proteinValue = Double(protein),
              let fiberValue = Double(fiber) else {
            return
        }
        
        let foodLog = FoodLog(context: viewContext)
        foodLog.id = UUID()
        foodLog.foodName = foodName
        foodLog.quantity = quantity
        foodLog.unit = unit
        foodLog.calories = Int32(caloriesValue)
        foodLog.protein = proteinValue
        foodLog.carbs = estimatedNutrition.carbs
        foodLog.fat = estimatedNutrition.fat
        foodLog.fiber = fiberValue
        foodLog.mealType = mealType.rawValue
        foodLog.notes = notes.isEmpty ? nil : notes
        foodLog.loggedAt = Date()
        foodLog.createdAt = Date()
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving food log: \(error)")
        }
    }
}

#Preview {
    AddFoodView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
