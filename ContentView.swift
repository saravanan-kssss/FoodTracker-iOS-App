import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserProfile.createdAt, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<UserProfile>
    
    @State private var showingProfileSetup = false
    
    var body: some View {
        Group {
            if profiles.isEmpty {
                ProfileSetupView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            if profiles.isEmpty {
                showingProfileSetup = true
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DailyIntakeView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Daily")
                }
            
            FoodScannerView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Scanner")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
        }
        .accentColor(AppTheme.primaryColor)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
