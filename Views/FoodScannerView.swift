import SwiftUI
import AVFoundation

struct FoodScannerView: View {
    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var analysisResult: FoodAnalysisResult?
    @State private var isAnalyzing = false
    @State private var showingResultView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.paddingLarge) {
                headerSection
                scanningOptionsSection
                recentScansSection
                Spacer()
            }
            .padding(AppTheme.paddingLarge)
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Food Scanner")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView { image in
                selectedImage = image
                analyzeFood(image: image)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker { image in
                selectedImage = image
                analyzeFood(image: image)
            }
        }
        .sheet(isPresented: $showingResultView) {
            if let result = analysisResult {
                FoodAnalysisResultView(result: result)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.forestGreen)
            
            Text("AI Food Scanner")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.navy)
            
            Text("Point your camera at food to get instant nutrition analysis")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.warmGray)
                .multilineTextAlignment(.center)
        }
        .cardStyle()
        .padding(.vertical, AppTheme.paddingLarge)
    }
    
    private var scanningOptionsSection: some View {
        VStack(spacing: AppTheme.paddingMedium) {
            Text("Scan Your Food")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            HStack(spacing: AppTheme.paddingMedium) {
                scanOptionButton(
                    title: "Take Photo",
                    icon: "camera.fill",
                    description: "Use camera to scan",
                    action: { showingCamera = true }
                )
                
                scanOptionButton(
                    title: "Choose Photo",
                    icon: "photo.fill",
                    description: "Select from gallery",
                    action: { showingImagePicker = true }
                )
            }
            
            if isAnalyzing {
                VStack(spacing: AppTheme.paddingMedium) {
                    ProgressView()
                        .scaleEffect(1.2)
                    
                    Text("Analyzing food...")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.warmGray)
                    
                    Text("AI is identifying ingredients and calculating nutrition")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.warmGray)
                        .multilineTextAlignment(.center)
                }
                .cardStyle()
                .padding(.top, AppTheme.paddingMedium)
            }
        }
    }
    
    private func scanOptionButton(title: String, icon: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: AppTheme.paddingMedium) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.forestGreen)
                
                Text(title)
                    .font(AppTheme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.navy)
                
                Text(description)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.warmGray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.paddingLarge)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var recentScansSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            Text("Popular Tamil Foods")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.navy)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.paddingMedium) {
                    ForEach(TamilFoodDatabase.shared.getAllFoods().prefix(8), id: \.name) { food in
                        popularFoodCard(food: food)
                    }
                }
                .padding(.horizontal, AppTheme.paddingMedium)
            }
            
            Text("Try scanning these popular Tamil dishes for best results")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.warmGray)
        }
    }
    
    private func popularFoodCard(food: TamilFood) -> some View {
        VStack(spacing: AppTheme.paddingSmall) {
            // Food category icon
            Image(systemName: foodIcon(for: food.category))
                .font(.system(size: 30))
                .foregroundColor(AppTheme.forestGreen)
            
            Text(food.name)
                .font(AppTheme.captionFont)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.navy)
                .multilineTextAlignment(.center)
            
            Text(food.category)
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.warmGray)
            
            Text("\(food.caloriesPer100g) cal/100g")
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.forestGreen)
        }
        .frame(width: 100, height: 120)
        .cardStyle()
    }
    
    private func foodIcon(for category: String) -> String {
        switch category.lowercased() {
        case "breakfast":
            return "sunrise.fill"
        case "rice":
            return "leaf.fill"
        case "curry":
            return "drop.fill"
        case "snack":
            return "circle.fill"
        case "sweet":
            return "heart.fill"
        case "non-veg":
            return "flame.fill"
        case "beverage":
            return "cup.and.saucer.fill"
        case "bread":
            return "circle.grid.2x2.fill"
        default:
            return "fork.knife"
        }
    }
    
    private func analyzeFood(image: UIImage) {
        isAnalyzing = true
        
        AIFoodRecognition.shared.analyzeFood(image: image) { result in
            DispatchQueue.main.async {
                isAnalyzing = false
                
                switch result {
                case .success(let analysis):
                    analysisResult = analysis
                    showingResultView = true
                case .failure(let error):
                    print("Analysis failed: \(error)")
                    // Show error alert
                }
            }
        }
    }
}

#Preview {
    FoodScannerView()
}
