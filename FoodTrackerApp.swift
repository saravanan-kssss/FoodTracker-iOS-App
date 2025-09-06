import SwiftUI

@main
struct FoodTrackerApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Request notification permissions on app launch
        NotificationManager.shared.requestPermission()
        
        // Schedule default meal reminders
        NotificationManager.shared.scheduleMealReminders()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
