import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let sampleProfile = UserProfile(context: viewContext)
        sampleProfile.id = UUID()
        sampleProfile.name = "Sample User"
        sampleProfile.height = 170
        sampleProfile.weight = 70
        sampleProfile.age = 25
        sampleProfile.gender = "Male"
        sampleProfile.activityLevel = "Moderate"
        sampleProfile.dailyCalorieGoal = Int32(sampleProfile.bmr)
        sampleProfile.createdAt = Date()
        sampleProfile.updatedAt = Date()
        
        // Sample food log entries
        let sampleLog1 = FoodLog(context: viewContext)
        sampleLog1.id = UUID()
        sampleLog1.foodName = "Idli"
        sampleLog1.quantity = 3
        sampleLog1.unit = "pieces"
        sampleLog1.calories = 174
        sampleLog1.protein = 6.0
        sampleLog1.carbs = 36.0
        sampleLog1.fat = 0.3
        sampleLog1.fiber = 1.8
        sampleLog1.mealType = "Breakfast"
        sampleLog1.loggedAt = Date()
        sampleLog1.createdAt = Date()
        
        let sampleLog2 = FoodLog(context: viewContext)
        sampleLog2.id = UUID()
        sampleLog2.foodName = "Sambar Rice"
        sampleLog2.quantity = 1
        sampleLog2.unit = "bowl"
        sampleLog2.calories = 290
        sampleLog2.protein = 10.0
        sampleLog2.carbs = 60.0
        sampleLog2.fat = 3.0
        sampleLog2.fiber = 6.0
        sampleLog2.mealType = "Lunch"
        sampleLog2.loggedAt = Date()
        sampleLog2.createdAt = Date()

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FoodTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Core Data Operations
extension PersistenceController {
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        save()
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
}
