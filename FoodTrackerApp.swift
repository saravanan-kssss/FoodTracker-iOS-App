import SwiftUI
import CoreData

@main
struct FoodTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationManager)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Setup notifications
        notificationManager.setupNotificationCategories()
        notificationManager.requestPermission()
        
        // Populate Tamil food database
        TamilFoodDatabase.shared.populateDatabase(context: persistenceController.container.viewContext)
    }
}
