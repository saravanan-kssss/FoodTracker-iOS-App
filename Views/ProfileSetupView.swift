import SwiftUI
import CoreData

struct ProfileSetupView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var selectedGender = "female"
    @State private var currentStep = 0
    
    private let genders = ["male", "female", "other"]
    private let totalSteps = 4
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.largePadding) {
                // Progress Bar
                progressBar
                
                // Content
                Group {
                    switch currentStep {
                    case 0:
                        welcomeStep
                    case 1:
                        heightStep
                    case 2:
                        weightStep
                    case 3:
                        ageGenderStep
                    default:
                        welcomeStep
                    }
                }
                
                Spacer()
                
                // Navigation Buttons
                navigationButtons
            }
            .padding(.horizontal, AppTheme.mediumPadding)
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: AppTheme.smallPadding) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
                
                Spacer()
                
                Text("Step \(currentStep + 1) of \(totalSteps)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
            }
            .padding(.top, AppTheme.mediumPadding)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppTheme.lightGray)
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(AppTheme.forestGreen)
                        .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .frame(height: 4)
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: AppTheme.largePadding) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.forestGreen)
            
            VStack(spacing: AppTheme.mediumPadding) {
                Text("Welcome to FoodTracker")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.darkGray)
                    .multilineTextAlignment(.center)
                
                Text("Let's set up your profile to provide personalized nutrition recommendations based on your body metrics.")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(AppTheme.largePadding)
    }
    
    private var heightStep: some View {
        VStack(spacing: AppTheme.largePadding) {
            Image(systemName: "ruler")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.forestGreen)
            
            VStack(spacing: AppTheme.mediumPadding) {
                Text("What's your height?")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Text("This helps us calculate your daily calorie needs")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: AppTheme.smallPadding) {
                TextField("172", text: $height)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .textFieldStyle(CustomTextFieldStyle())
                
                Text("centimeters")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
            }
        }
        .padding(AppTheme.largePadding)
    }
    
    private var weightStep: some View {
        VStack(spacing: AppTheme.largePadding) {
            Image(systemName: "scalemass")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.forestGreen)
            
            VStack(spacing: AppTheme.mediumPadding) {
                Text("What's your weight?")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Text("We use this to calculate your BMR and daily calorie goals")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: AppTheme.smallPadding) {
                TextField("63", text: $weight)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .textFieldStyle(CustomTextFieldStyle())
                
                Text("kilograms")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
            }
        }
        .padding(AppTheme.largePadding)
    }
    
    private var ageGenderStep: some View {
        VStack(spacing: AppTheme.largePadding) {
            Image(systemName: "person.2")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.forestGreen)
            
            VStack(spacing: AppTheme.mediumPadding) {
                Text("A few more details")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Text("Age and gender help us provide more accurate calorie recommendations")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: AppTheme.largePadding) {
                // Age Input
                VStack(spacing: AppTheme.smallPadding) {
                    Text("Age")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray)
                    
                    TextField("30", text: $age)
                        .keyboardType(.numberPad)
                        .font(.system(size: 20, weight: .medium))
                        .multilineTextAlignment(.center)
                        .textFieldStyle(CustomTextFieldStyle())
                        .frame(width: 100)
                }
                
                // Gender Selection
                VStack(spacing: AppTheme.mediumPadding) {
                    Text("Gender")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray)
                    
                    HStack(spacing: AppTheme.mediumPadding) {
                        ForEach(genders, id: \.self) { gender in
                            Button(action: {
                                selectedGender = gender
                            }) {
                                Text(gender.capitalized)
                                    .font(AppTheme.bodyFont)
                                    .foregroundColor(selectedGender == gender ? .white : AppTheme.forestGreen)
                                    .padding(.horizontal, AppTheme.mediumPadding)
                                    .padding(.vertical, AppTheme.smallPadding)
                                    .background(selectedGender == gender ? AppTheme.forestGreen : AppTheme.cream)
                                    .cornerRadius(AppTheme.smallRadius)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                                            .stroke(AppTheme.forestGreen, lineWidth: selectedGender == gender ? 0 : 1)
                                    )
                            }
                        }
                    }
                }
            }
        }
        .padding(AppTheme.largePadding)
    }
    
    private var navigationButtons: some View {
        HStack(spacing: AppTheme.mediumPadding) {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation {
                        currentStep -= 1
                    }
                }
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppTheme.lightGray)
                .cornerRadius(AppTheme.smallRadius)
            }
            
            Button(currentStep == totalSteps - 1 ? "Complete Setup" : "Next") {
                if currentStep == totalSteps - 1 {
                    completeSetup()
                } else {
                    withAnimation {
                        currentStep += 1
                    }
                }
            }
            .font(AppTheme.bodyFont)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(canProceed ? AppTheme.forestGreen : AppTheme.lightGray)
            .cornerRadius(AppTheme.smallRadius)
            .disabled(!canProceed)
        }
        .padding(.bottom, AppTheme.largePadding)
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return true
        case 1:
            return !height.isEmpty && Double(height) != nil
        case 2:
            return !weight.isEmpty && Double(weight) != nil
        case 3:
            return !age.isEmpty && Int(age) != nil
        default:
            return false
        }
    }
    
    private func completeSetup() {
        guard let heightValue = Double(height),
              let weightValue = Double(weight),
              let ageValue = Int(age) else { return }
        
        let user = UserProfile(context: viewContext)
        user.id = UUID()
        user.height = heightValue
        user.weight = weightValue
        user.age = Int16(ageValue)
        user.gender = selectedGender
        user.dailyCalorieGoal = user.calculateBMR()
        user.createdAt = Date()
        user.updatedAt = Date()
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving user profile: \(error)")
        }
    }
}

struct EditProfileView: View {
    let user: UserProfile
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var height: String
    @State private var weight: String
    @State private var age: String
    @State private var selectedGender: String
    
    init(user: UserProfile) {
        self.user = user
        self._height = State(initialValue: String(Int(user.height)))
        self._weight = State(initialValue: String(Int(user.weight)))
        self._age = State(initialValue: String(user.age))
        self._selectedGender = State(initialValue: user.gender)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.largePadding) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray)
                        
                        Spacer()
                        
                        Text("Edit Profile")
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.darkGray)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveChanges()
                        }
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.forestGreen)
                    }
                    .padding(.top, AppTheme.mediumPadding)
                    
                    // Form Fields
                    VStack(spacing: AppTheme.largePadding) {
                        formField(title: "Height (cm)", value: $height, keyboardType: .decimalPad)
                        formField(title: "Weight (kg)", value: $weight, keyboardType: .decimalPad)
                        formField(title: "Age", value: $age, keyboardType: .numberPad)
                        
                        // Gender Selection
                        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
                            Text("Gender")
                                .font(AppTheme.bodyFont)
                                .foregroundColor(AppTheme.darkGray)
                            
                            HStack(spacing: AppTheme.mediumPadding) {
                                ForEach(["male", "female", "other"], id: \.self) { gender in
                                    Button(action: {
                                        selectedGender = gender
                                    }) {
                                        Text(gender.capitalized)
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(selectedGender == gender ? .white : AppTheme.forestGreen)
                                            .padding(.horizontal, AppTheme.mediumPadding)
                                            .padding(.vertical, AppTheme.smallPadding)
                                            .background(selectedGender == gender ? AppTheme.forestGreen : AppTheme.cream)
                                            .cornerRadius(AppTheme.smallRadius)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                                                    .stroke(AppTheme.forestGreen, lineWidth: selectedGender == gender ? 0 : 1)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(AppTheme.mediumPadding)
                        .cardStyle()
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, AppTheme.mediumPadding)
            }
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private func formField(title: String, value: Binding<String>, keyboardType: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text(title)
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            TextField("", text: value)
                .keyboardType(keyboardType)
                .textFieldStyle(CustomTextFieldStyle())
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func saveChanges() {
        guard let heightValue = Double(height),
              let weightValue = Double(weight),
              let ageValue = Int(age) else { return }
        
        user.height = heightValue
        user.weight = weightValue
        user.age = Int16(ageValue)
        user.gender = selectedGender
        user.dailyCalorieGoal = user.calculateBMR()
        user.updatedAt = Date()
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error updating user profile: \(error)")
        }
    }
}

#Preview {
    ProfileSetupView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
