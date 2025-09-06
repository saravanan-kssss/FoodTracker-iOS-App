import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
            }
            
            if granted {
                self.scheduleDefaultReminders()
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleDefaultReminders() {
        // Clear existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Breakfast reminder
        scheduleMealReminder(
            identifier: "breakfast",
            title: "Good Morning! 🌅",
            body: "Time to fuel your day with a nutritious breakfast",
            hour: 8,
            minute: 0
        )
        
        // Lunch reminder
        scheduleMealReminder(
            identifier: "lunch",
            title: "Lunch Time! 🍽️",
            body: "Don't forget to log your midday meal",
            hour: 13,
            minute: 0
        )
        
        // Dinner reminder
        scheduleMealReminder(
            identifier: "dinner",
            title: "Dinner Time! 🌙",
            body: "End your day with a balanced dinner",
            hour: 19,
            minute: 30
        )
        
        // Evening log reminder
        scheduleMealReminder(
            identifier: "evening_log",
            title: "Daily Check-in 📊",
            body: "How did your nutrition goals go today?",
            hour: 21,
            minute: 0
        )
    }
    
    private func scheduleMealReminder(identifier: String, title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "MEAL_REMINDER"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func scheduleMotivationalNotification() {
        let motivationalMessages = [
            "You're doing great! Keep up the healthy eating! 💪",
            "Small steps lead to big changes. Log your next meal! 🌟",
            "Your body is your temple. Nourish it well! 🏛️",
            "Consistency is key to reaching your goals! 🎯",
            "Every healthy choice counts. You've got this! ✨"
        ]
        
        let content = UNMutableNotificationContent()
        content.title = "Stay Motivated! 🎉"
        content.body = motivationalMessages.randomElement() ?? "Keep tracking your nutrition!"
        content.sound = .default
        
        // Schedule for random time between 10 AM and 6 PM
        let randomHour = Int.random(in: 10...18)
        let randomMinute = Int.random(in: 0...59)
        
        var dateComponents = DateComponents()
        dateComponents.hour = randomHour
        dateComponents.minute = randomMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "motivation_\(UUID())", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleGoalAchievementNotification(goalType: String, achieved: Bool) {
        let content = UNMutableNotificationContent()
        
        if achieved {
            content.title = "Goal Achieved! 🎉"
            content.body = "Congratulations! You've reached your \(goalType) goal today!"
        } else {
            content.title = "Almost There! 💪"
            content.body = "You're close to your \(goalType) goal. Keep going!"
        }
        
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "goal_\(UUID())", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// MARK: - Notification Categories and Actions
extension NotificationManager {
    func setupNotificationCategories() {
        let logMealAction = UNNotificationAction(
            identifier: "LOG_MEAL",
            title: "Log Meal",
            options: [.foreground]
        )
        
        let viewProgressAction = UNNotificationAction(
            identifier: "VIEW_PROGRESS",
            title: "View Progress",
            options: [.foreground]
        )
        
        let mealReminderCategory = UNNotificationCategory(
            identifier: "MEAL_REMINDER",
            actions: [logMealAction, viewProgressAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([mealReminderCategory])
    }
}
