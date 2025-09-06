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
            // Simulate processing time
            Thread.sleep(forTimeInterval: 1.5)
            
            // Mock AI analysis - in production, this would use Vision + CoreML
            let result = self.mockFoodRecognition(for: image)
            
            DispatchQueue.main.async {
                completion(.success(result))
            }
        }
    }
    
    private func mockFoodRecognition(for image: UIImage) -> FoodAnalysisResult {
        // Simulate AI recognition by randomly selecting from Tamil foods
        // In production, this would analyze the actual image
        
        let tamilDatabase = TamilFoodDatabase.shared
        let possibleFoods = [
            // Common Tamil breakfast items
            ("Idli", "South Indian", 58, 4.2, 1.0, 0.95, true),
            ("Masala Dosa", "South Indian", 150, 3.5, 2.5, 0.88, true),
            ("Uttapam", "South Indian", 120, 4.5, 2.0, 0.92, true),
            ("Appam", "South Indian", 110, 3.0, 0.8, 0.85, true),
            ("Pongal", "South Indian", 130, 5.0, 1.2, 0.90, true),
            
            // Rice dishes
            ("Sambar Rice", "South Indian", 110, 3.5, 2.0, 0.87, true),
            ("Curd Rice", "South Indian", 90, 4.0, 0.5, 0.93, true),
            ("Lemon Rice", "South Indian", 140, 2.8, 0.8, 0.89, true),
            
            // Curries
            ("Sambar", "South Indian", 40, 2.5, 3.0, 0.91, true),
            ("Rasam", "South Indian", 20, 1.5, 2.0, 0.88, true),
            ("Kootu", "South Indian", 80, 4.0, 3.5, 0.86, true),
            
            // Snacks
            ("Vadai", "South Indian", 210, 8.0, 2.5, 0.84, true),
            ("Bajji", "South Indian", 180, 4.0, 2.0, 0.82, true),
            ("Sundal", "South Indian", 120, 8.0, 6.0, 0.90, true),
            
            // International foods for variety
            ("Pasta", "Italian", 220, 8.0, 2.5, 0.75, false),
            ("Fried Rice", "Chinese", 190, 4.0, 1.0, 0.80, false),
            ("Sandwich", "Western", 250, 12.0, 3.0, 0.78, false),
            ("Salad", "Western", 50, 3.0, 4.0, 0.85, false)
        ]
        
        let randomFood = possibleFoods.randomElement()!
        
        return FoodAnalysisResult(
            foodName: randomFood.0,
            category: randomFood.1,
            calories: randomFood.2,
            protein: randomFood.3,
            fiber: randomFood.4,
            confidence: randomFood.5,
            isTamil: randomFood.6
        )
    }
    
    // MARK: - Vision Framework Integration (for future implementation)
    
    private func performVisionRequest(on image: UIImage, completion: @escaping (Result<[VNClassificationObservation], Error>) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(.failure(AIError.imageProcessingFailed))
            return
        }
        
        // This would use a custom trained CoreML model for Tamil food recognition
        // For now, we'll use a placeholder
        
        let request = VNImageClassificationRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let observations = request.results as? [VNClassificationObservation] else {
                completion(.failure(AIError.noResultsFound))
                return
            }
            
            completion(.success(observations))
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Tamil Food Specific Recognition
    
    func recognizeTamilFood(from observations: [VNClassificationObservation]) -> FoodAnalysisResult? {
        // Map Vision results to Tamil food database
        let tamilDatabase = TamilFoodDatabase.shared
        
        for observation in observations {
            let identifier = observation.identifier.lowercased()
            
            // Try to match with Tamil foods first
            if let tamilFood = tamilDatabase.searchFood(query: identifier).first {
                return FoodAnalysisResult(
                    foodName: tamilFood.name,
                    category: tamilFood.category,
                    calories: tamilFood.caloriesPerGram * 100, // per 100g
                    protein: tamilFood.proteinPerGram * 100,
                    fiber: tamilFood.fiberPerGram * 100,
                    confidence: Double(observation.confidence),
                    isTamil: true
                )
            }
        }
        
        return nil
    }
    
    // MARK: - Nutrition Estimation
    
    func estimateNutrition(for foodName: String, portionSize: Double = 100) -> NutritionData {
        let tamilDatabase = TamilFoodDatabase.shared
        
        if let tamilFood = tamilDatabase.getFoodByName(foodName) {
            return NutritionData(
                calories: tamilFood.caloriesPerGram * portionSize,
                protein: tamilFood.proteinPerGram * portionSize,
                fiber: tamilFood.fiberPerGram * portionSize
            )
        }
        
        // Fallback to generic estimation
        return NutritionData(
            calories: 150, // Default calories per 100g
            protein: 5,    // Default protein per 100g
            fiber: 2       // Default fiber per 100g
        )
    }
}

// MARK: - Error Types

enum AIError: Error, LocalizedError {
    case imageProcessingFailed
    case noResultsFound
    case modelLoadingFailed
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed:
            return "Failed to process the image"
        case .noResultsFound:
            return "No food items detected in the image"
        case .modelLoadingFailed:
            return "Failed to load the AI model"
        case .networkError:
            return "Network connection required for analysis"
        }
    }
}

// MARK: - Food Recognition Confidence Levels

extension AIFoodRecognition {
    func getConfidenceLevel(for confidence: Double) -> String {
        switch confidence {
        case 0.9...1.0:
            return "Very High"
        case 0.8..<0.9:
            return "High"
        case 0.7..<0.8:
            return "Medium"
        case 0.6..<0.7:
            return "Low"
        default:
            return "Very Low"
        }
    }
    
    func shouldShowConfidenceWarning(for confidence: Double) -> Bool {
        return confidence < 0.7
    }
}
