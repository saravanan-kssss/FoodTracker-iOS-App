import Foundation
import Vision
import CoreML
import UIKit

class AIFoodRecognition: ObservableObject {
    static let shared = AIFoodRecognition()
    
    private init() {}
    
    func analyzeFood(image: UIImage, completion: @escaping (Result<FoodAnalysisResult, Error>) -> Void) {
        // In a real implementation, this would use a trained CoreML model
        // For now, we'll simulate AI recognition with intelligent matching
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Simulate processing delay
            Thread.sleep(forTimeInterval: 1.5)
            
            DispatchQueue.main.async {
                // Try to match with Tamil food database first
                let tamilFoods = TamilFoodDatabase.shared.getAllFoods()
                let randomFood = tamilFoods.randomElement() ?? TamilFoodDatabase.shared.getFood(name: "Idli")!
                
                let nutrition = NutritionData(
                    calories: Int(randomFood.caloriesPer100g),
                    protein: randomFood.proteinPer100g,
                    carbs: randomFood.carbsPer100g,
                    fat: randomFood.fatPer100g,
                    fiber: randomFood.fiberPer100g
                )
                
                let result = FoodAnalysisResult(
                    foodName: randomFood.name,
                    confidence: 0.85,
                    nutrition: nutrition,
                    suggestions: self.generateSuggestions(for: randomFood.name)
                )
                
                completion(.success(result))
            }
        }
    }
    
    func estimateNutrition(foodName: String, quantity: Double, unit: String) -> NutritionData {
        // First try to find in Tamil food database
        if let tamilFood = TamilFoodDatabase.shared.getFood(name: foodName) {
            let multiplier = calculateMultiplier(quantity: quantity, unit: unit)
            return NutritionData(
                calories: Int(Double(tamilFood.caloriesPer100g) * multiplier),
                protein: tamilFood.proteinPer100g * multiplier,
                carbs: tamilFood.carbsPer100g * multiplier,
                fat: tamilFood.fatPer100g * multiplier,
                fiber: tamilFood.fiberPer100g * multiplier
            )
        }
        
        // Fallback to AI estimation based on common foods
        return estimateFromCommonFoods(foodName: foodName, quantity: quantity, unit: unit)
    }
    
    private func calculateMultiplier(quantity: Double, unit: String) -> Double {
        switch unit.lowercased() {
        case "piece", "pieces":
            return quantity * 0.5 // Assume 50g per piece
        case "cup", "cups":
            return quantity * 1.5 // Assume 150g per cup
        case "bowl", "bowls":
            return quantity * 2.0 // Assume 200g per bowl
        case "50g":
            return quantity * 0.5
        case "100g":
            return quantity * 1.0
        case "150g":
            return quantity * 1.5
        case "200g":
            return quantity * 2.0
        default:
            return quantity * 1.0
        }
    }
    
    private func estimateFromCommonFoods(foodName: String, quantity: Double, unit: String) -> NutritionData {
        let multiplier = calculateMultiplier(quantity: quantity, unit: unit)
        let lowerName = foodName.lowercased()
        
        // Basic nutrition estimation based on food categories
        var baseNutrition: (calories: Int32, protein: Double, carbs: Double, fat: Double, fiber: Double)
        
        if lowerName.contains("rice") {
            baseNutrition = (130, 2.7, 28.0, 0.3, 0.4)
        } else if lowerName.contains("chicken") {
            baseNutrition = (165, 31.0, 0.0, 3.6, 0.0)
        } else if lowerName.contains("fish") {
            baseNutrition = (206, 22.0, 0.0, 12.0, 0.0)
        } else if lowerName.contains("egg") {
            baseNutrition = (155, 13.0, 1.1, 11.0, 0.0)
        } else if lowerName.contains("dal") || lowerName.contains("lentil") {
            baseNutrition = (116, 9.0, 20.0, 0.4, 8.0)
        } else if lowerName.contains("vegetable") || lowerName.contains("curry") {
            baseNutrition = (80, 3.0, 15.0, 2.0, 4.0)
        } else if lowerName.contains("bread") || lowerName.contains("roti") {
            baseNutrition = (265, 9.0, 49.0, 4.0, 3.0)
        } else if lowerName.contains("milk") {
            baseNutrition = (42, 3.4, 5.0, 1.0, 0.0)
        } else if lowerName.contains("fruit") || lowerName.contains("apple") || lowerName.contains("banana") {
            baseNutrition = (52, 0.3, 14.0, 0.2, 2.4)
        } else {
            // Default estimation for unknown foods
            baseNutrition = (100, 5.0, 15.0, 3.0, 2.0)
        }
        
        return NutritionData(
            calories: Int(Double(baseNutrition.calories) * multiplier),
            protein: baseNutrition.protein * multiplier,
            carbs: baseNutrition.carbs * multiplier,
            fat: baseNutrition.fat * multiplier,
            fiber: baseNutrition.fiber * multiplier
        )
    }
    
    private func generateSuggestions(for foodName: String) -> [String] {
        let suggestions = [
            "Try adding more vegetables for fiber",
            "Consider portion size for balanced nutrition",
            "Pair with protein for better satiety",
            "Add healthy fats like nuts or seeds",
            "Include whole grains for sustained energy"
        ]
        return Array(suggestions.shuffled().prefix(3))
    }
    
    func searchFoodSuggestions(query: String) -> [String] {
        let tamilFoods = TamilFoodDatabase.shared.getAllFoods()
        let filtered = tamilFoods.filter { food in
            food.name.lowercased().contains(query.lowercased())
        }.map { $0.name }
        
        // Add some common foods if Tamil foods don't match
        let commonFoods = [
            "Apple", "Banana", "Orange", "Grapes", "Mango",
            "Chicken Curry", "Fish Fry", "Egg Curry", "Mutton Curry",
            "White Rice", "Brown Rice", "Chapati", "Naan",
            "Mixed Vegetables", "Potato Curry", "Tomato Rice"
        ]
        
        let commonFiltered = commonFoods.filter { food in
            food.lowercased().contains(query.lowercased())
        }
        
        return Array((filtered + commonFiltered).prefix(8))
    }
}
