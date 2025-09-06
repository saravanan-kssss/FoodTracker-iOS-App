import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let sampleUser = UserProfile(context: viewContext)
        sampleUser.id = UUID()
        sampleUser.height = 172
        sampleUser.weight = 63
        sampleUser.age = 30
        sampleUser.gender = "female"
        sampleUser.dailyCalorieGoal = 1650
        sampleUser.createdAt = Date()
        sampleUser.updatedAt = Date()
        
        // Sample Tamil foods
        let idli = FoodItem(context: viewContext)
        idli.id = UUID()
        idli.name = "Idli"
        idli.category = "South Indian"
        idli.caloriesPerGram = 0.58
        idli.proteinPerGram = 0.042
        idli.fiberPerGram = 0.01
        idli.isIndian = true
        idli.isTamil = true
        idli.createdAt = Date()
        
        let dosa = FoodItem(context: viewContext)
        dosa.id = UUID()
        dosa.name = "Masala Dosa"
        dosa.category = "South Indian"
        dosa.caloriesPerGram = 1.5
        dosa.proteinPerGram = 0.03
        dosa.fiberPerGram = 0.01
        dosa.isIndian = true
        dosa.isTamil = true
        dosa.createdAt = Date()
        
        // Sample food log
        let foodLog = FoodLog(context: viewContext)
        foodLog.id = UUID()
        foodLog.portionSize = 150
        foodLog.totalCalories = 150
        foodLog.totalProtein = 3
        foodLog.totalFiber = 1
        foodLog.mealType = "breakfast"
        foodLog.loggedAt = Date()
        foodLog.user = sampleUser
        foodLog.foodItem = idli
        
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
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Core Data Helper Methods
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
    
    func createUser(height: Double, weight: Double, age: Int, gender: String) -> UserProfile {
        let context = container.viewContext
        let user = UserProfile(context: context)
        user.id = UUID()
        user.height = height
        user.weight = weight
        user.age = Int16(age)
        user.gender = gender
        user.dailyCalorieGoal = user.calculateBMR()
        user.createdAt = Date()
        user.updatedAt = Date()
        
        save()
        return user
    }
    
    func logFood(user: UserProfile, foodItem: FoodItem, portionSize: Double, mealType: String) -> FoodLog {
        let context = container.viewContext
        let foodLog = FoodLog(context: context)
        foodLog.id = UUID()
        foodLog.portionSize = portionSize
        foodLog.totalCalories = foodItem.caloriesPerGram * portionSize
        foodLog.totalProtein = foodItem.proteinPerGram * portionSize
        foodLog.totalFiber = foodItem.fiberPerGram * portionSize
        foodLog.mealType = mealType
        foodLog.loggedAt = Date()
        foodLog.user = user
        foodLog.foodItem = foodItem
        
        save()
        return foodLog
    }
}
