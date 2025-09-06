import Foundation
import CoreData

// MARK: - Core Data Models

@objc(UserProfile)
public class UserProfile: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var height: Double // in cm
    @NSManaged public var weight: Double // in kg
    @NSManaged public var age: Int16
    @NSManaged public var gender: String
    @NSManaged public var activityLevel: String
    @NSManaged public var dailyCalorieGoal: Int32
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    
    // Computed property for BMR calculation
    var bmr: Double {
        // Mifflin-St Jeor Equation
        let baseBMR: Double
        if gender.lowercased() == "male" {
            baseBMR = 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            baseBMR = 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
        
        // Activity level multiplier
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
}

extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }
}

@objc(FoodItem)
public class FoodItem: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var category: String
    @NSManaged public var caloriesPer100g: Int32
    @NSManaged public var proteinPer100g: Double
    @NSManaged public var carbsPer100g: Double
    @NSManaged public var fatPer100g: Double
    @NSManaged public var fiberPer100g: Double
    @NSManaged public var isCustom: Bool
    @NSManaged public var createdAt: Date
}

extension FoodItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }
}

@objc(FoodLog)
public class FoodLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var foodName: String
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String
    @NSManaged public var calories: Int32
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var fiber: Double
    @NSManaged public var mealType: String
    @NSManaged public var notes: String?
    @NSManaged public var loggedAt: Date
    @NSManaged public var createdAt: Date
}

extension FoodLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodLog> {
        return NSFetchRequest<FoodLog>(entityName: "FoodLog")
    }
}

// MARK: - Data Transfer Objects

struct FoodAnalysisResult {
    let foodName: String
    let confidence: Double
    let nutrition: NutritionData
    let suggestions: [String]
}

struct NutritionData {
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double
    
    static let zero = NutritionData(calories: 0, protein: 0, carbs: 0, fat: 0, fiber: 0)
}

struct DailyNutritionSummary {
    let date: Date
    let totalCalories: Int
    let totalProtein: Double
    let totalCarbs: Double
    let totalFat: Double
    let totalFiber: Double
    let goalCalories: Int
    let mealBreakdown: [String: NutritionData]
    
    var calorieProgress: Double {
        return Double(totalCalories) / Double(goalCalories)
    }
    
    var proteinGoal: Double {
        // 15-20% of total calories from protein (4 calories per gram)
        return Double(goalCalories) * 0.175 / 4.0
    }
    
    var fiberGoal: Double {
        // Recommended 25-35g per day
        return 30.0
    }
    
    var proteinProgress: Double {
        return totalProtein / proteinGoal
    }
    
    var fiberProgress: Double {
        return totalFiber / fiberGoal
    }
}

// MARK: - Enums

enum MealType: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var emoji: String {
        switch self {
        case .breakfast: return "🌅"
        case .lunch: return "☀️"
        case .dinner: return "🌙"
        case .snack: return "🍎"
        }
    }
}

enum ActivityLevel: String, CaseIterable {
    case sedentary = "Sedentary"
    case light = "Light"
    case moderate = "Moderate"
    case active = "Active"
    case veryActive = "Very Active"
    
    var description: String {
        switch self {
        case .sedentary: return "Little to no exercise"
        case .light: return "Light exercise 1-3 days/week"
        case .moderate: return "Moderate exercise 3-5 days/week"
        case .active: return "Heavy exercise 6-7 days/week"
        case .veryActive: return "Very heavy exercise, physical job"
        }
    }
}
