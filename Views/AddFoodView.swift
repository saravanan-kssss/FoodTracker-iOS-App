import SwiftUI
import CoreData

struct AddFoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var foodName = ""
    @State private var portionSize = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var fiber = ""
    @State private var selectedMealType = MealType.breakfast
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.largePadding) {
                    // Header
                    headerView
                    
                    // Food Details Form
                    foodDetailsForm
                    
                    // Meal Type Selection
                    mealTypeSelection
                    
                    // Notes Section
                    notesSection
                    
                    // Save Button
                    saveButton
                    
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
            
            Text("Add Food")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.darkGray)
            
            Spacer()
            
            Button("Save") {
                saveFood()
            }
            .font(AppTheme.bodyFont)
            .foregroundColor(AppTheme.forestGreen)
            .disabled(!isFormValid)
        }
        .padding(.top, AppTheme.mediumPadding)
    }
    
    private var foodDetailsForm: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            // Food Name
            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Food Name")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                
                TextField("Enter food name", text: $foodName)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Portion Size
            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Portion Size (grams)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                
                TextField("150", text: $portionSize)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Nutrition Information
            VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
                Text("Nutrition Information")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                HStack(spacing: AppTheme.mediumPadding) {
                    VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                        Text("Calories")
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.darkGray.opacity(0.7))
                        
                        TextField("150", text: $calories)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                        Text("Protein (g)")
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.darkGray.opacity(0.7))
                        
                        TextField("3", text: $protein)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                        Text("Fiber (g)")
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.darkGray.opacity(0.7))
                        
                        TextField("1", text: $fiber)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                }
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
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
    
    private var saveButton: some View {
        Button(action: saveFood) {
            Text("Save Food Log")
                .font(AppTheme.bodyFont)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isFormValid ? AppTheme.forestGreen : AppTheme.lightGray)
                .cornerRadius(AppTheme.smallRadius)
        }
        .disabled(!isFormValid)
    }
    
    private var isFormValid: Bool {
        !foodName.isEmpty &&
        !portionSize.isEmpty &&
        !calories.isEmpty &&
        Double(portionSize) != nil &&
        Double(calories) != nil
    }
    
    private func saveFood() {
        guard let portionValue = Double(portionSize),
              let caloriesValue = Double(calories) else { return }
        
        let proteinValue = Double(protein) ?? 0
        let fiberValue = Double(fiber) ?? 0
        
        // Create or find food item
        let foodItem = FoodItem(context: viewContext)
        foodItem.id = UUID()
        foodItem.name = foodName
        foodItem.category = "User Added"
        foodItem.caloriesPerGram = caloriesValue / portionValue
        foodItem.proteinPerGram = proteinValue / portionValue
        foodItem.fiberPerGram = fiberValue / portionValue
        foodItem.isIndian = false
        foodItem.isTamil = false
        foodItem.createdAt = Date()
        
        // Create food log
        let foodLog = FoodLog(context: viewContext)
        foodLog.id = UUID()
        foodLog.portionSize = portionValue
        foodLog.totalCalories = caloriesValue
        foodLog.totalProtein = proteinValue
        foodLog.totalFiber = fiberValue
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

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(AppTheme.smallPadding)
            .background(AppTheme.cream)
            .cornerRadius(AppTheme.smallRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                    .stroke(AppTheme.lightGray, lineWidth: 1)
            )
    }
}

#Preview {
    AddFoodView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
