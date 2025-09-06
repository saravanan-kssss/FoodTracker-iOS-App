import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserProfile.createdAt, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<UserProfile>
    
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    if let profile = profiles.first {
                        profileHeaderSection(profile: profile)
                        statsSection(profile: profile)
                        goalSection(profile: profile)
                        settingsSection
                    } else {
                        Text("No profile found")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.warmGray)
                    }
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if profiles.first != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit") {
                            showingEditProfile = true
                        }
                        .foregroundColor(AppTheme.forestGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            if let profile = profiles.first {
                EditProfileView(profile: profile)
            }
        }
    }
    
    private func profileHeaderSection(profile: UserProfile) -> some View {
        VStack(spacing: AppTheme.paddingMedium) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.forestGreen)
            
            Text(profile.name)
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.navy)
            
            Text("Member since \(profile.createdAt, style: .date)")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
        }
        .cardStyle()
        .padding(.vertical, AppTheme.paddingMedium)
    }
    
    private func statsSection(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Personal Information")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.paddingMedium) {
                statCard(title: "Height", value: "\(Int(profile.height)) cm", icon: "ruler.fill", color: .blue)
                statCard(title: "Weight", value: "\(Int(profile.weight)) kg", icon: "scalemass.fill", color: .green)
                statCard(title: "Age", value: "\(profile.age) years", icon: "calendar.circle.fill", color: .orange)
                statCard(title: "Gender", value: profile.gender, icon: "person.fill", color: .purple)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Activity Level")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    Text(profile.activityLevel)
                        .font(AppTheme.bodyFont)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.navy)
                    
                    Text(ActivityLevel(rawValue: profile.activityLevel)?.description ?? "")
                        .font(AppTheme.smallFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                
                Spacer()
                
                Image(systemName: "figure.run")
                    .font(.title)
                    .foregroundColor(AppTheme.forestGreen)
            }
            .padding(AppTheme.paddingMedium)
            .background(AppTheme.cream)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
        .cardStyle()
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: AppTheme.paddingSmall) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
            
            Text(value)
                .font(AppTheme.bodyFont)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.navy)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.paddingMedium)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private func goalSection(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Daily Goals")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            VStack(spacing: AppTheme.paddingMedium) {
                goalRow(
                    title: "Calorie Goal",
                    value: "\(profile.dailyCalorieGoal) cal",
                    description: "Based on your BMR: \(Int(profile.bmr)) cal",
                    icon: "flame.fill",
                    color: AppTheme.forestGreen
                )
                
                goalRow(
                    title: "Protein Goal",
                    value: "\(Int(Double(profile.dailyCalorieGoal) * 0.175 / 4.0)) g",
                    description: "15-20% of total calories",
                    icon: "figure.strengthtraining.traditional",
                    color: .blue
                )
                
                goalRow(
                    title: "Fiber Goal",
                    value: "30 g",
                    description: "Recommended daily intake",
                    icon: "heart.fill",
                    color: .green
                )
            }
        }
        .cardStyle()
    }
    
    private func goalRow(title: String, value: String, description: String, icon: String, color: Color) -> some View {
        HStack(spacing: AppTheme.paddingMedium) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.bodyFont)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.navy)
                
                Text(description)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
            }
            
            Spacer()
            
            Text(value)
                .font(AppTheme.bodyFont)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(AppTheme.paddingMedium)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Settings")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            VStack(spacing: 0) {
                settingRow(
                    title: "Notifications",
                    subtitle: "Meal reminders and achievements",
                    icon: "bell.fill",
                    action: { }
                )
                
                Divider()
                    .padding(.horizontal, AppTheme.paddingMedium)
                
                settingRow(
                    title: "Export Data",
                    subtitle: "Download your food log data",
                    icon: "square.and.arrow.up.fill",
                    action: { }
                )
                
                Divider()
                    .padding(.horizontal, AppTheme.paddingMedium)
                
                settingRow(
                    title: "About",
                    subtitle: "App version and information",
                    icon: "info.circle.fill",
                    action: { }
                )
            }
        }
        .cardStyle()
    }
    
    private func settingRow(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppTheme.paddingMedium) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppTheme.forestGreen)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.navy)
                    
                    Text(subtitle)
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.warmGray)
            }
            .padding(AppTheme.paddingMedium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    let profile: UserProfile
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var height: String
    @State private var weight: String
    @State private var age: String
    @State private var gender: String
    @State private var activityLevel: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let genders = ["Male", "Female", "Other"]
    let activityLevels = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
    
    init(profile: UserProfile) {
        self.profile = profile
        _name = State(initialValue: profile.name)
        _height = State(initialValue: "\(Int(profile.height))")
        _weight = State(initialValue: "\(Int(profile.weight))")
        _age = State(initialValue: "\(profile.age)")
        _gender = State(initialValue: profile.gender)
        _activityLevel = State(initialValue: profile.activityLevel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.paddingLarge) {
                    profileForm
                    calculateBMRSection
                    updateButton
                }
                .padding(AppTheme.paddingLarge)
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Edit Profile")
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
        .alert("Profile Updated", isPresented: $showingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
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
                        .keyboardType(.numberPad)
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: AppTheme.paddingSmall) {
                    Text("Weight (kg)")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.navy)
                    
                    TextField("70", text: $weight)
                        .keyboardType(.numberPad)
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
    }
    
    private var calculateBMRSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            if let heightValue = Double(height),
               let weightValue = Double(weight),
               let ageValue = Int(age) {
                
                let bmr = calculateBMR(height: heightValue, weight: weightValue, age: ageValue, gender: gender, activityLevel: activityLevel)
                
                VStack(spacing: AppTheme.paddingSmall) {
                    Text("Updated Daily Calorie Goal")
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.navy)
                    
                    Text("\(Int(bmr)) calories")
                        .font(AppTheme.titleFont)
                        .foregroundColor(AppTheme.forestGreen)
                    
                    Text("Based on your updated BMR and activity level")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                }
                .cardStyle()
            }
        }
    }
    
    private var updateButton: some View {
        Button("Update Profile") {
            updateProfile()
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
    
    private func updateProfile() {
        guard let heightValue = Double(height),
              let weightValue = Double(weight),
              let ageValue = Int(age) else {
            alertMessage = "Please enter valid numeric values."
            showingAlert = true
            return
        }
        
        profile.name = name
        profile.height = heightValue
        profile.weight = weightValue
        profile.age = Int16(ageValue)
        profile.gender = gender
        profile.activityLevel = activityLevel
        profile.dailyCalorieGoal = Int32(calculateBMR(height: heightValue, weight: weightValue, age: ageValue, gender: gender, activityLevel: activityLevel))
        profile.updatedAt = Date()
        
        do {
            try viewContext.save()
            alertMessage = "Profile updated successfully! Your new daily calorie goal is \(profile.dailyCalorieGoal) calories."
            showingAlert = true
        } catch {
            alertMessage = "Error updating profile: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

#Preview {
    ProfileView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
