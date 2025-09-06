import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserProfile.createdAt, ascending: false)],
        animation: .default)
    private var userProfiles: FetchedResults<UserProfile>
    
    @State private var showingProfileSetup = false
    @State private var showingEditProfile = false
    
    var currentUser: UserProfile? {
        userProfiles.first
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.largePadding) {
                    // Header
                    headerView
                    
                    if let user = currentUser {
                        // Profile Card
                        profileCard(user: user)
                        
                        // Daily Goal Card
                        dailyGoalCard(user: user)
                        
                        // Stats Overview
                        statsOverview(user: user)
                        
                        // Settings Section
                        settingsSection
                    } else {
                        // Setup Profile
                        setupProfileView
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, AppTheme.mediumPadding)
            }
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView()
        }
        .sheet(isPresented: $showingEditProfile) {
            if let user = currentUser {
                EditProfileView(user: user)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Profile")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.darkGray)
            
            Spacer()
            
            if currentUser != nil {
                Button("Edit") {
                    showingEditProfile = true
                }
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.forestGreen)
            }
        }
        .padding(.top, AppTheme.largePadding)
    }
    
    private func profileCard(user: UserProfile) -> some View {
        VStack(spacing: AppTheme.mediumPadding) {
            // Profile Picture Placeholder
            Circle()
                .fill(AppTheme.beige)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.forestGreen)
                )
            
            // User Info
            VStack(spacing: AppTheme.smallPadding) {
                Text("User Profile")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.darkGray)
                
                HStack(spacing: AppTheme.largePadding) {
                    profileInfoItem(title: "Height", value: "\(Int(user.height)) cm")
                    profileInfoItem(title: "Weight", value: "\(Int(user.weight)) kg")
                    profileInfoItem(title: "Age", value: "\(user.age)")
                }
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func profileInfoItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
            
            Text(value)
                .font(AppTheme.bodyFont)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.darkGray)
        }
    }
    
    private func dailyGoalCard(user: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            HStack {
                Text("Daily Calorie Goal")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Spacer()
                
                Text("AI Recommended")
                    .font(AppTheme.captionFont)
                    .foregroundColor(.white)
                    .padding(.horizontal, AppTheme.smallPadding)
                    .padding(.vertical, 2)
                    .background(AppTheme.forestGreen)
                    .cornerRadius(AppTheme.smallRadius)
            }
            
            HStack(alignment: .bottom) {
                Text("\(Int(user.dailyCalorieGoal))")
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.darkGray)
                
                Text("calories")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .padding(.bottom, 6)
                
                Spacer()
            }
            
            // BMR Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Based on your BMR and activity level")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                
                Text("BMR: \(Int(user.calculateBMR() / 1.4)) cal/day")
                    .font(AppTheme.smallFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.6))
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func statsOverview(user: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            Text("This Week")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            HStack(spacing: AppTheme.mediumPadding) {
                statCard(title: "Meals Logged", value: "\(user.foodLogsArray.count)", icon: "fork.knife")
                statCard(title: "Avg Calories", value: "1420", icon: "flame")
                statCard(title: "Days Active", value: "5", icon: "calendar")
            }
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: AppTheme.smallPadding) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppTheme.forestGreen)
            
            Text(value)
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.darkGray)
            
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.smallPadding)
    }
    
    private var settingsSection: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            settingRow(title: "Notifications", icon: "bell", action: {})
            settingRow(title: "Export Data", icon: "square.and.arrow.up", action: {})
            settingRow(title: "Privacy Policy", icon: "lock.shield", action: {})
            settingRow(title: "About", icon: "info.circle", action: {})
        }
        .padding(AppTheme.mediumPadding)
        .cardStyle()
    }
    
    private func settingRow(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppTheme.forestGreen)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.darkGray.opacity(0.5))
            }
            .padding(.vertical, AppTheme.smallPadding)
        }
    }
    
    private var setupProfileView: some View {
        VStack(spacing: AppTheme.largePadding) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.forestGreen)
            
            VStack(spacing: AppTheme.smallPadding) {
                Text("Set Up Your Profile")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.darkGray)
                
                Text("Tell us about yourself to get personalized calorie recommendations")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button("Get Started") {
                showingProfileSetup = true
            }
            .font(AppTheme.bodyFont)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.forestGreen)
            .cornerRadius(AppTheme.smallRadius)
        }
        .padding(AppTheme.extraLargePadding)
        .cardStyle()
    }
}

#Preview {
    ProfileView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
