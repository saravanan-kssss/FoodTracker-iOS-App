import Foundation
import CoreData

// MARK: - User Profile Model
@objc(UserProfile)
public class UserProfile: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var height: Double // in cm
    @NSManaged public var weight: Double // in kg
    @NSManaged public var age: Int16
    @NSManaged public var gender: String
    @NSManaged public var dailyCalorieGoal: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    
    // Relationships
    @NSManaged public var foodLogs: NSSet?
}

// MARK: - Food Item Model
@objc(FoodItem)
public class FoodItem: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var category: String
    @NSManaged public var caloriesPerGram: Double
    @NSManaged public var proteinPerGram: Double
    @NSManaged public var fiberPerGram: Double
    @NSManaged public var isIndian: Bool
    @NSManaged public var isTamil: Bool
    @NSManaged public var createdAt: Date
    
    // Relationships
    @NSManaged public var foodLogs: NSSet?
}

// MARK: - Food Log Model
@objc(FoodLog)
public class FoodLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var portionSize: Double // in grams
    @NSManaged public var totalCalories: Double
    @NSManaged public var totalProtein: Double
    @NSManaged public var totalFiber: Double
    @NSManaged public var mealType: String // breakfast, lunch, dinner, snack
    @NSManaged public var loggedAt: Date
    @NSManaged public var notes: String?
    
    // Relationships
    @NSManaged public var user: UserProfile?
    @NSManaged public var foodItem: FoodItem?
}

// MARK: - Core Data Extensions
extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }
    
    var foodLogsArray: [FoodLog] {
        let set = foodLogs as? Set<FoodLog> ?? []
        return set.sorted { $0.loggedAt > $1.loggedAt }
    }
    
    func calculateBMR() -> Double {
        // Mifflin-St Jeor Equation
        let bmr: Double
        if gender.lowercased() == "male" {
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
        return bmr * 1.4 // Assuming light activity level
    }
}

extension FoodItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }
    
    var foodLogsArray: [FoodLog] {
        let set = foodLogs as? Set<FoodLog> ?? []
        return set.sorted { $0.loggedAt > $1.loggedAt }
    }
}

extension FoodLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodLog> {
        return NSFetchRequest<FoodLog>(entityName: "FoodLog")
    }
    
    var displayName: String {
        return foodItem?.name ?? "Unknown Food"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: loggedAt)
    }
}

// MARK: - Nutrition Data Structure
struct NutritionData {
    let calories: Double
    let protein: Double
    let fiber: Double
    
    static let zero = NutritionData(calories: 0, protein: 0, fiber: 0)
    
    static func + (lhs: NutritionData, rhs: NutritionData) -> NutritionData {
        return NutritionData(
            calories: lhs.calories + rhs.calories,
            protein: lhs.protein + rhs.protein,
            fiber: lhs.fiber + rhs.fiber
        )
    }
}

// MARK: - Meal Type Enum
enum MealType: String, CaseIterable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"
    
    var displayName: String {
        return rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .breakfast: return "sun.rise"
        case .lunch: return "sun.max"
        case .dinner: return "moon"
        case .snack: return "leaf"
        }
    }
}
