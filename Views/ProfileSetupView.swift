import SwiftUI
import CoreData

struct ProfileSetupView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var gender = "Male"
    @State private var activityLevel = "Moderate"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let genders = ["Male", "Female", "Other"]
    let activityLevels = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    headerSection
                    profileForm
                    calculateBMRSection
                    createProfileButton
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Profile Setup")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Profile Setup", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.forestGreen)
            
            Text("Welcome to FoodTracker")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.navy)
            
            Text("Let's set up your profile to calculate personalized nutrition goals")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.warmGray)
                .multilineTextAlignment(.center)
        }
        .cardStyle()
        .padding(.vertical, AppTheme.paddingLarge)
    }
    
    private var profileForm: some View {
        VStack(spacing: AppTheme.paddingLarge) {
            VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                Text("Name")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.navy)
                
                TextField("Enter your name", text: $name)
                    .customTextFieldStyle()
            }
            
            HStack(spacing: AppTheme.paddingMedium) {
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Height (cm)")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.navy)
                    
                    TextField("170", text: $height)
                        .keyboardType(.decimalPad)
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Weight (kg)")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.navy)
                    
                    TextField("70", text: $weight)
                        .keyboardType(.decimalPad)
                        .customTextFieldStyle()
                }
            }
            
            HStack(spacing: AppTheme.paddingMedium) {
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Age")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.navy)
                    
                    TextField("25", text: $age)
                        .keyboardType(.numberPad)
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Gender")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.navy)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .customTextFieldStyle()
                }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                Text("Activity Level")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.navy)
                
                Picker("Activity Level", selection: $activityLevel) {
                    ForEach(activityLevels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .customTextFieldStyle()
                
                Text(ActivityLevel(rawValue: activityLevel)?.description ?? "")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
            }
        }
        .cardStyle()
        .padding(.vertical, AppTheme.paddingMedium)
    }
    
    private var calculateBMRSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            if let heightValue = Double(height),
               let weightValue = Double(weight),
               let ageValue = Int(age) {
                
                let bmr = calculateBMR(height: heightValue, weight: weightValue, age: ageValue, gender: gender, activityLevel: activityLevel)
                
                VStack(spacing: AppTheme.paddingSmall) {
                    Text("Your Daily Calorie Goal")
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.navy)
                    
                    Text("\(Int(bmr)) calories")
                        .font(AppTheme.titleFont)
                        .foregroundColor(AppTheme.forestGreen)
                    
                    Text("Based on your BMR and activity level")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                .cardStyle()
                .padding(.vertical, AppTheme.paddingMedium)
            }
        }
    }
    
    private var createProfileButton: some View {
        Button("Create Profile") {
            createProfile()
        }
        .primaryButtonStyle(isEnabled: isFormValid)
        .disabled(!isFormValid)
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !height.isEmpty &&
        !weight.isEmpty &&
        !age.isEmpty &&
        Double(height) != nil &&
        Double(weight) != nil &&
        Int(age) != nil
    }
    
    private func calculateBMR(height: Double, weight: Double, age: Int, gender: String, activityLevel: String) -> Double {
        let baseBMR: Double
        if gender.lowercased() == "male" {
            baseBMR = 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            baseBMR = 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
        
        let multiplier: Double
        switch activityLevel.lowercased() {
        case "sedentary":
            multiplier = 1.2
        case "light":
            multiplier = 1.375
        case "moderate":
            multiplier = 1.55
        case "active":
            multiplier = 1.725
        case "very active":
            multiplier = 1.9
        default:
            multiplier = 1.375
        }
        
        return baseBMR * multiplier
    }
    
    private func createProfile() {
        guard let heightValue = Double(height),
              let weightValue = Double(weight),
              let ageValue = Int(age) else {
            alertMessage = "Please enter valid numeric values for height, weight, and age."
            showingAlert = true
            return
        }
        
        let profile = UserProfile(context: viewContext)
        profile.id = UUID()
        profile.name = name
        profile.height = heightValue
        profile.weight = weightValue
        profile.age = Int16(ageValue)
        profile.gender = gender
        profile.activityLevel = activityLevel
        profile.dailyCalorieGoal = Int32(calculateBMR(height: heightValue, weight: weightValue, age: ageValue, gender: gender, activityLevel: activityLevel))
        profile.createdAt = Date()
        profile.updatedAt = Date()
        
        do {
            try viewContext.save()
            
            // Schedule notifications after profile creation
            NotificationManager.shared.scheduleMealReminders()
            
            alertMessage = "Profile created successfully! Your daily calorie goal is \(profile.dailyCalorieGoal) calories."
            showingAlert = true
        } catch {
            alertMessage = "Error creating profile: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

#Preview {
    ProfileSetupView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
