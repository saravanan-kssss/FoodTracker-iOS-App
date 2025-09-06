import Foundation

struct TamilFood {
    let name: String
    let category: String
    let caloriesPer100g: Int32
    let proteinPer100g: Double
    let carbsPer100g: Double
    let fatPer100g: Double
    let fiberPer100g: Double
    let description: String
}

class TamilFoodDatabase {
    static let shared = TamilFoodDatabase()
    
    private let foods: [TamilFood] = [
        // Breakfast Items
        TamilFood(name: "Idli", category: "Breakfast", caloriesPer100g: 58, proteinPer100g: 2.0, carbsPer100g: 12.0, fatPer100g: 0.1, fiberPer100g: 0.6, description: "Steamed rice and lentil cakes"),
        TamilFood(name: "Dosa", category: "Breakfast", caloriesPer100g: 168, proteinPer100g: 4.0, carbsPer100g: 28.0, fatPer100g: 4.0, fiberPer100g: 1.2, description: "Fermented crepe made from rice and lentils"),
        TamilFood(name: "Uttapam", category: "Breakfast", caloriesPer100g: 188, proteinPer100g: 5.0, carbsPer100g: 32.0, fatPer100g: 4.5, fiberPer100g: 1.8, description: "Thick pancake with vegetables"),
        TamilFood(name: "Appam", category: "Breakfast", caloriesPer100g: 120, proteinPer100g: 2.5, carbsPer100g: 25.0, fatPer100g: 1.0, fiberPer100g: 0.8, description: "Bowl-shaped fermented rice pancake"),
        TamilFood(name: "Puttu", category: "Breakfast", caloriesPer100g: 112, proteinPer100g: 2.8, carbsPer100g: 23.0, fatPer100g: 0.5, fiberPer100g: 2.0, description: "Steamed rice flour with coconut"),
        TamilFood(name: "Pongal", category: "Breakfast", caloriesPer100g: 150, proteinPer100g: 4.5, carbsPer100g: 28.0, fatPer100g: 2.5, fiberPer100g: 1.5, description: "Rice and lentil porridge"),
        TamilFood(name: "Upma", category: "Breakfast", caloriesPer100g: 85, proteinPer100g: 2.5, carbsPer100g: 16.0, fatPer100g: 1.5, fiberPer100g: 1.0, description: "Semolina porridge with vegetables"),
        
        // Rice Dishes
        TamilFood(name: "Plain Rice", category: "Rice", caloriesPer100g: 130, proteinPer100g: 2.7, carbsPer100g: 28.0, fatPer100g: 0.3, fiberPer100g: 0.4, description: "Steamed white rice"),
        TamilFood(name: "Sambar Rice", category: "Rice", caloriesPer100g: 145, proteinPer100g: 5.0, carbsPer100g: 30.0, fatPer100g: 1.5, fiberPer100g: 3.0, description: "Rice mixed with lentil curry"),
        TamilFood(name: "Rasam Rice", category: "Rice", caloriesPer100g: 135, proteinPer100g: 3.0, carbsPer100g: 29.0, fatPer100g: 0.8, fiberPer100g: 1.5, description: "Rice with tangy tomato broth"),
        TamilFood(name: "Curd Rice", category: "Rice", caloriesPer100g: 98, proteinPer100g: 3.5, carbsPer100g: 18.0, fatPer100g: 1.2, fiberPer100g: 0.5, description: "Rice mixed with yogurt"),
        TamilFood(name: "Lemon Rice", category: "Rice", caloriesPer100g: 155, proteinPer100g: 3.0, carbsPer100g: 32.0, fatPer100g: 2.0, fiberPer100g: 1.0, description: "Rice flavored with lemon and spices"),
        TamilFood(name: "Coconut Rice", category: "Rice", caloriesPer100g: 180, proteinPer100g: 3.5, carbsPer100g: 35.0, fatPer100g: 3.5, fiberPer100g: 2.0, description: "Rice cooked with coconut"),
        TamilFood(name: "Tamarind Rice", category: "Rice", caloriesPer100g: 165, proteinPer100g: 3.2, carbsPer100g: 34.0, fatPer100g: 2.2, fiberPer100g: 1.8, description: "Rice with tangy tamarind sauce"),
        
        // Curries & Gravies
        TamilFood(name: "Sambar", category: "Curry", caloriesPer100g: 85, proteinPer100g: 4.5, carbsPer100g: 15.0, fatPer100g: 1.0, fiberPer100g: 4.0, description: "Lentil curry with vegetables"),
        TamilFood(name: "Rasam", category: "Curry", caloriesPer100g: 45, proteinPer100g: 2.0, carbsPer100g: 8.0, fatPer100g: 0.5, fiberPer100g: 1.5, description: "Tangy tomato and tamarind broth"),
        TamilFood(name: "Kuzhambu", category: "Curry", caloriesPer100g: 95, proteinPer100g: 3.0, carbsPer100g: 18.0, fatPer100g: 1.5, fiberPer100g: 3.5, description: "Tamarind-based vegetable curry"),
        TamilFood(name: "Kootu", category: "Curry", caloriesPer100g: 75, proteinPer100g: 3.5, carbsPer100g: 12.0, fatPer100g: 2.0, fiberPer100g: 4.0, description: "Lentil and vegetable stew"),
        TamilFood(name: "Poriyal", category: "Curry", caloriesPer100g: 65, proteinPer100g: 2.5, carbsPer100g: 10.0, fatPer100g: 2.5, fiberPer100g: 3.5, description: "Dry vegetable stir-fry"),
        TamilFood(name: "Aviyal", category: "Curry", caloriesPer100g: 88, proteinPer100g: 2.8, carbsPer100g: 14.0, fatPer100g: 3.0, fiberPer100g: 4.5, description: "Mixed vegetables in coconut gravy"),
        
        // Snacks & Street Food
        TamilFood(name: "Vadai", category: "Snack", caloriesPer100g: 245, proteinPer100g: 8.0, carbsPer100g: 25.0, fatPer100g: 12.0, fiberPer100g: 5.0, description: "Deep-fried lentil donuts"),
        TamilFood(name: "Bajji", category: "Snack", caloriesPer100g: 180, proteinPer100g: 4.0, carbsPer100g: 22.0, fatPer100g: 8.0, fiberPer100g: 2.5, description: "Batter-fried vegetables"),
        TamilFood(name: "Bonda", category: "Snack", caloriesPer100g: 195, proteinPer100g: 5.0, carbsPer100g: 28.0, fatPer100g: 7.0, fiberPer100g: 2.0, description: "Deep-fried potato balls"),
        TamilFood(name: "Murukku", category: "Snack", caloriesPer100g: 520, proteinPer100g: 12.0, carbsPer100g: 55.0, fatPer100g: 28.0, fiberPer100g: 3.0, description: "Spiral-shaped rice flour snack"),
        TamilFood(name: "Sundal", category: "Snack", caloriesPer100g: 125, proteinPer100g: 6.0, carbsPer100g: 20.0, fatPer100g: 2.5, fiberPer100g: 6.0, description: "Spiced boiled legumes"),
        TamilFood(name: "Paniyaram", category: "Snack", caloriesPer100g: 165, proteinPer100g: 4.5, carbsPer100g: 28.0, fatPer100g: 4.0, fiberPer100g: 1.5, description: "Round fermented rice balls"),
        
        // Traditional Sweets
        TamilFood(name: "Payasam", category: "Sweet", caloriesPer100g: 185, proteinPer100g: 4.0, carbsPer100g: 35.0, fatPer100g: 4.5, fiberPer100g: 1.0, description: "Sweet rice pudding"),
        TamilFood(name: "Laddu", category: "Sweet", caloriesPer100g: 425, proteinPer100g: 8.0, carbsPer100g: 65.0, fatPer100g: 15.0, fiberPer100g: 2.5, description: "Round sweet balls"),
        TamilFood(name: "Halwa", category: "Sweet", caloriesPer100g: 385, proteinPer100g: 6.0, carbsPer100g: 55.0, fatPer100g: 16.0, fiberPer100g: 3.0, description: "Dense sweet pudding"),
        TamilFood(name: "Mysore Pak", category: "Sweet", caloriesPer100g: 518, proteinPer100g: 7.0, carbsPer100g: 45.0, fatPer100g: 35.0, fiberPer100g: 1.5, description: "Ghee-rich gram flour sweet"),
        TamilFood(name: "Jangiri", category: "Sweet", caloriesPer100g: 445, proteinPer100g: 5.5, carbsPer100g: 68.0, fatPer100g: 18.0, fiberPer100g: 2.0, description: "Spiral-shaped syrup-soaked sweet"),
        
        // Non-Vegetarian
        TamilFood(name: "Chicken Curry", category: "Non-Veg", caloriesPer100g: 165, proteinPer100g: 25.0, carbsPer100g: 5.0, fatPer100g: 5.5, fiberPer100g: 1.0, description: "Spiced chicken in gravy"),
        TamilFood(name: "Fish Curry", category: "Non-Veg", caloriesPer100g: 145, proteinPer100g: 22.0, carbsPer100g: 3.0, fatPer100g: 5.0, fiberPer100g: 0.5, description: "Fish cooked in spicy gravy"),
        TamilFood(name: "Mutton Curry", category: "Non-Veg", caloriesPer100g: 195, proteinPer100g: 26.0, carbsPer100g: 4.0, fatPer100g: 8.5, fiberPer100g: 1.0, description: "Goat meat in rich gravy"),
        TamilFood(name: "Prawn Curry", category: "Non-Veg", caloriesPer100g: 125, proteinPer100g: 20.0, carbsPer100g: 3.5, fatPer100g: 3.5, fiberPer100g: 0.5, description: "Prawns in coconut curry"),
        
        // Beverages
        TamilFood(name: "Filter Coffee", category: "Beverage", caloriesPer100g: 25, proteinPer100g: 1.5, carbsPer100g: 3.0, fatPer100g: 1.0, fiberPer100g: 0.0, description: "Traditional South Indian coffee"),
        TamilFood(name: "Buttermilk", category: "Beverage", caloriesPer100g: 40, proteinPer100g: 3.1, carbsPer100g: 4.8, fatPer100g: 0.9, fiberPer100g: 0.0, description: "Spiced yogurt drink"),
        TamilFood(name: "Tender Coconut", category: "Beverage", caloriesPer100g: 19, proteinPer100g: 0.7, carbsPer100g: 3.7, fatPer100g: 0.2, fiberPer100g: 1.1, description: "Fresh coconut water"),
        
        // Additional Popular Items
        TamilFood(name: "Biryani", category: "Rice", caloriesPer100g: 185, proteinPer100g: 8.0, carbsPer100g: 35.0, fatPer100g: 2.5, fiberPer100g: 1.5, description: "Fragrant spiced rice with meat/vegetables"),
        TamilFood(name: "Parotta", category: "Bread", caloriesPer100g: 300, proteinPer100g: 8.0, carbsPer100g: 45.0, fatPer100g: 10.0, fiberPer100g: 2.0, description: "Layered flatbread"),
        TamilFood(name: "Chapati", category: "Bread", caloriesPer100g: 265, proteinPer100g: 9.0, carbsPer100g: 49.0, fatPer100g: 4.0, fiberPer100g: 3.0, description: "Whole wheat flatbread")
    ]
    
    private init() {}
    
    func getAllFoods() -> [TamilFood] {
        return foods
    }
    
    func getFood(name: String) -> TamilFood? {
        return foods.first { $0.name.lowercased() == name.lowercased() }
    }
    
    func getFoodsByCategory(_ category: String) -> [TamilFood] {
        return foods.filter { $0.category.lowercased() == category.lowercased() }
    }
    
    func searchFoods(query: String) -> [TamilFood] {
        return foods.filter { food in
            food.name.lowercased().contains(query.lowercased()) ||
            food.description.lowercased().contains(query.lowercased())
        }
    }
    
    func getRandomFood() -> TamilFood {
        return foods.randomElement() ?? foods[0]
    }
    
    func getFoodCategories() -> [String] {
        return Array(Set(foods.map { $0.category })).sorted()
    }
}
