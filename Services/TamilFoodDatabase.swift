import Foundation
import CoreData

class TamilFoodDatabase {
    static let shared = TamilFoodDatabase()
    
    private init() {}
    
    // Comprehensive Tamil and South Indian food database
    let tamilFoods: [TamilFoodItem] = [
        // Rice dishes
        TamilFoodItem(name: "Plain Rice", category: "Rice", caloriesPerGram: 1.3, proteinPerGram: 0.026, fiberPerGram: 0.004),
        TamilFoodItem(name: "Sambar Rice", category: "Rice", caloriesPerGram: 1.1, proteinPerGram: 0.035, fiberPerGram: 0.02),
        TamilFoodItem(name: "Rasam Rice", category: "Rice", caloriesPerGram: 1.0, proteinPerGram: 0.025, fiberPerGram: 0.015),
        TamilFoodItem(name: "Curd Rice", category: "Rice", caloriesPerGram: 0.9, proteinPerGram: 0.04, fiberPerGram: 0.005),
        TamilFoodItem(name: "Lemon Rice", category: "Rice", caloriesPerGram: 1.4, proteinPerGram: 0.028, fiberPerGram: 0.008),
        TamilFoodItem(name: "Coconut Rice", category: "Rice", caloriesPerGram: 1.6, proteinPerGram: 0.03, fiberPerGram: 0.012),
        TamilFoodItem(name: "Tamarind Rice", category: "Rice", caloriesPerGram: 1.3, proteinPerGram: 0.025, fiberPerGram: 0.01),
        
        // Breakfast items
        TamilFoodItem(name: "Idli", category: "Breakfast", caloriesPerGram: 0.58, proteinPerGram: 0.042, fiberPerGram: 0.01),
        TamilFoodItem(name: "Dosa", category: "Breakfast", caloriesPerGram: 1.33, proteinPerGram: 0.04, fiberPerGram: 0.02),
        TamilFoodItem(name: "Masala Dosa", category: "Breakfast", caloriesPerGram: 1.5, proteinPerGram: 0.035, fiberPerGram: 0.025),
        TamilFoodItem(name: "Rava Dosa", category: "Breakfast", caloriesPerGram: 1.4, proteinPerGram: 0.038, fiberPerGram: 0.015),
        TamilFoodItem(name: "Uttapam", category: "Breakfast", caloriesPerGram: 1.2, proteinPerGram: 0.045, fiberPerGram: 0.02),
        TamilFoodItem(name: "Appam", category: "Breakfast", caloriesPerGram: 1.1, proteinPerGram: 0.03, fiberPerGram: 0.008),
        TamilFoodItem(name: "Puttu", category: "Breakfast", caloriesPerGram: 0.9, proteinPerGram: 0.025, fiberPerGram: 0.015),
        TamilFoodItem(name: "Idiyappam", category: "Breakfast", caloriesPerGram: 1.0, proteinPerGram: 0.022, fiberPerGram: 0.01),
        TamilFoodItem(name: "Pongal", category: "Breakfast", caloriesPerGram: 1.3, proteinPerGram: 0.05, fiberPerGram: 0.012),
        TamilFoodItem(name: "Upma", category: "Breakfast", caloriesPerGram: 1.1, proteinPerGram: 0.035, fiberPerGram: 0.02),
        
        // Curries and gravies
        TamilFoodItem(name: "Sambar", category: "Curry", caloriesPerGram: 0.4, proteinPerGram: 0.025, fiberPerGram: 0.03),
        TamilFoodItem(name: "Rasam", category: "Curry", caloriesPerGram: 0.2, proteinPerGram: 0.015, fiberPerGram: 0.02),
        TamilFoodItem(name: "Kuzhambu", category: "Curry", caloriesPerGram: 0.6, proteinPerGram: 0.02, fiberPerGram: 0.025),
        TamilFoodItem(name: "Mor Kuzhambu", category: "Curry", caloriesPerGram: 0.5, proteinPerGram: 0.03, fiberPerGram: 0.015),
        TamilFoodItem(name: "Kootu", category: "Curry", caloriesPerGram: 0.8, proteinPerGram: 0.04, fiberPerGram: 0.035),
        TamilFoodItem(name: "Poriyal", category: "Curry", caloriesPerGram: 0.6, proteinPerGram: 0.025, fiberPerGram: 0.04),
        TamilFoodItem(name: "Aviyal", category: "Curry", caloriesPerGram: 0.7, proteinPerGram: 0.03, fiberPerGram: 0.045),
        TamilFoodItem(name: "Thoran", category: "Curry", caloriesPerGram: 0.5, proteinPerGram: 0.02, fiberPerGram: 0.05),
        
        // Non-vegetarian dishes
        TamilFoodItem(name: "Chicken Curry", category: "Non-Veg", caloriesPerGram: 1.2, proteinPerGram: 0.18, fiberPerGram: 0.01),
        TamilFoodItem(name: "Fish Curry", category: "Non-Veg", caloriesPerGram: 1.0, proteinPerGram: 0.15, fiberPerGram: 0.008),
        TamilFoodItem(name: "Mutton Curry", category: "Non-Veg", caloriesPerGram: 1.8, proteinPerGram: 0.2, fiberPerGram: 0.005),
        TamilFoodItem(name: "Prawn Curry", category: "Non-Veg", caloriesPerGram: 0.9, proteinPerGram: 0.16, fiberPerGram: 0.01),
        TamilFoodItem(name: "Chettinad Chicken", category: "Non-Veg", caloriesPerGram: 1.5, proteinPerGram: 0.19, fiberPerGram: 0.012),
        
        // Snacks and street food
        TamilFoodItem(name: "Vadai", category: "Snacks", caloriesPerGram: 2.1, proteinPerGram: 0.08, fiberPerGram: 0.025),
        TamilFoodItem(name: "Bajji", category: "Snacks", caloriesPerGram: 1.8, proteinPerGram: 0.04, fiberPerGram: 0.02),
        TamilFoodItem(name: "Bonda", category: "Snacks", caloriesPerGram: 1.9, proteinPerGram: 0.045, fiberPerGram: 0.015),
        TamilFoodItem(name: "Murukku", category: "Snacks", caloriesPerGram: 4.5, proteinPerGram: 0.12, fiberPerGram: 0.03),
        TamilFoodItem(name: "Sundal", category: "Snacks", caloriesPerGram: 1.2, proteinPerGram: 0.08, fiberPerGram: 0.06),
        TamilFoodItem(name: "Paniyaram", category: "Snacks", caloriesPerGram: 1.4, proteinPerGram: 0.05, fiberPerGram: 0.02),
        
        // Sweets
        TamilFoodItem(name: "Payasam", category: "Sweets", caloriesPerGram: 1.8, proteinPerGram: 0.04, fiberPerGram: 0.008),
        TamilFoodItem(name: "Laddu", category: "Sweets", caloriesPerGram: 4.2, proteinPerGram: 0.08, fiberPerGram: 0.015),
        TamilFoodItem(name: "Halwa", category: "Sweets", caloriesPerGram: 3.5, proteinPerGram: 0.06, fiberPerGram: 0.01),
        TamilFoodItem(name: "Mysore Pak", category: "Sweets", caloriesPerGram: 4.8, proteinPerGram: 0.07, fiberPerGram: 0.005),
        TamilFoodItem(name: "Jangiri", category: "Sweets", caloriesPerGram: 4.0, proteinPerGram: 0.05, fiberPerGram: 0.008)
    ]
    
    func searchFood(query: String) -> [TamilFoodItem] {
        let lowercaseQuery = query.lowercased()
        return tamilFoods.filter { food in
            food.name.lowercased().contains(lowercaseQuery) ||
            food.category.lowercased().contains(lowercaseQuery)
        }
    }
    
    func getFoodByName(_ name: String) -> TamilFoodItem? {
        return tamilFoods.first { $0.name.lowercased() == name.lowercased() }
    }
    
    func getFoodsByCategory(_ category: String) -> [TamilFoodItem] {
        return tamilFoods.filter { $0.category.lowercased() == category.lowercased() }
    }
    
    func getRandomTamilFood() -> TamilFoodItem {
        return tamilFoods.randomElement() ?? tamilFoods[0]
    }
    
    func populateDatabase(context: NSManagedObjectContext) {
        // Check if database is already populated
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        request.predicate = NSPredicate(format: "isTamil == YES")
        
        do {
            let existingTamilFoods = try context.fetch(request)
            if !existingTamilFoods.isEmpty {
                return // Already populated
            }
        } catch {
            print("Error checking existing Tamil foods: \(error)")
        }
        
        // Populate with Tamil foods
        for tamilFood in tamilFoods {
            let foodItem = FoodItem(context: context)
            foodItem.id = UUID()
            foodItem.name = tamilFood.name
            foodItem.category = tamilFood.category
            foodItem.caloriesPerGram = tamilFood.caloriesPerGram
            foodItem.proteinPerGram = tamilFood.proteinPerGram
            foodItem.fiberPerGram = tamilFood.fiberPerGram
            foodItem.isIndian = true
            foodItem.isTamil = true
            foodItem.createdAt = Date()
        }
        
        do {
            try context.save()
            print("Tamil food database populated successfully")
        } catch {
            print("Error populating Tamil food database: \(error)")
        }
    }
}

struct TamilFoodItem {
    let name: String
    let category: String
    let caloriesPerGram: Double
    let proteinPerGram: Double
    let fiberPerGram: Double
}
