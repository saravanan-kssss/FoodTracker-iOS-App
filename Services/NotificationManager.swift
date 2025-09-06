import Foundation
import UserNotifications
import UIKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
    
    func scheduleMealReminders() {
        // Clear existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Breakfast reminder - 8:00 AM
        scheduleNotification(
            identifier: "breakfast_reminder",
            title: "🌅 Good Morning!",
            body: "Time for a healthy breakfast. Don't forget to log your meal!",
            hour: 8,
            minute: 0
        )
        
        // Lunch reminder - 1:00 PM
        scheduleNotification(
            identifier: "lunch_reminder",
            title: "☀️ Lunch Time!",
            body: "Ready for lunch? Remember to track your nutrition goals.",
            hour: 13,
            minute: 0
        )
        
        // Dinner reminder - 7:00 PM
        scheduleNotification(
            identifier: "dinner_reminder",
            title: "🌙 Dinner Time!",
            body: "Time for dinner. Keep up with your healthy eating habits!",
            hour: 19,
            minute: 0
        )
        
        // Evening motivation - 9:00 PM
        scheduleMotivationalNotification()
    }
    
    private func scheduleNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) {
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
    
    private func scheduleMotivationalNotification() {
        let motivationalMessages = [
            "🎉 Great job staying consistent with your nutrition tracking!",
            "💪 You're building healthy habits one meal at a time!",
            "🌟 Keep up the excellent work with your food logging!",
            "🏆 Your dedication to health is inspiring!",
            "✨ Every healthy choice counts towards your goals!"
        ]
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Motivation"
        content.body = motivationalMessages.randomElement() ?? "Keep up the great work!"
        content.sound = .default
        content.categoryIdentifier = "MOTIVATION"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_motivation", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling motivational notification: \(error)")
            }
        }
    }
    
    func scheduleGoalAchievementNotification(goalType: String, progress: Double) {
        guard progress >= 1.0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🎯 Goal Achieved!"
        content.body = "Congratulations! You've reached your \(goalType) goal for today!"
        content.sound = .default
        content.categoryIdentifier = "ACHIEVEMENT"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "goal_\(goalType)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling achievement notification: \(error)")
            }
        }
    }
    
    func scheduleCustomReminder(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "custom_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling custom reminder: \(error)")
            }
        }
    }
    
    func setupNotificationCategories() {
        // Meal reminder actions
        let logMealAction = UNNotificationAction(
            identifier: "LOG_MEAL",
            title: "Log Meal",
            options: [.foreground]
        )
        
        let remindLaterAction = UNNotificationAction(
            identifier: "REMIND_LATER",
            title: "Remind Later",
            options: []
        )
        
        let mealCategory = UNNotificationCategory(
            identifier: "MEAL_REMINDER",
            actions: [logMealAction, remindLaterAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Achievement actions
        let viewProgressAction = UNNotificationAction(
            identifier: "VIEW_PROGRESS",
            title: "View Progress",
            options: [.foreground]
        )
        
        let achievementCategory = UNNotificationCategory(
            identifier: "ACHIEVEMENT",
            actions: [viewProgressAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Motivation actions
        let motivationCategory = UNNotificationCategory(
            identifier: "MOTIVATION",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            mealCategory,
            achievementCategory,
            motivationCategory
        ])
    }
    
    func handleNotificationResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case "LOG_MEAL":
            // Navigate to food logging screen
            NotificationCenter.default.post(name: .navigateToFoodLogging, object: nil)
            
        case "REMIND_LATER":
            // Schedule reminder for 30 minutes later
            let laterDate = Date().addingTimeInterval(30 * 60)
            scheduleCustomReminder(
                title: "Meal Reminder",
                body: "Don't forget to log your meal!",
                date: laterDate
            )
            
        case "VIEW_PROGRESS":
            // Navigate to analytics screen
            NotificationCenter.default.post(name: .navigateToAnalytics, object: nil)
            
        default:
            break
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let navigateToFoodLogging = Notification.Name("navigateToFoodLogging")
    static let navigateToAnalytics = Notification.Name("navigateToAnalytics")
}
