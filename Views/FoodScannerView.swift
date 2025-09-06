import SwiftUI
import AVFoundation
import Vision
import CoreML

struct FoodScannerView: View {
    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var analysisResult: FoodAnalysisResult?
    @State private var showingResults = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.largePadding) {
                // Header
                headerView
                
                // Scanner Interface
                if let image = selectedImage {
                    analyzedImageView(image: image)
                } else {
                    scannerPlaceholder
                }
                
                // Action Buttons
                actionButtons
                
                // Recent Scans
                recentScansSection
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.mediumPadding)
            .background(AppTheme.lightBeige.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(selectedImage: $selectedImage, isAnalyzing: $isAnalyzing)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showingResults) {
            if let result = analysisResult {
                FoodAnalysisResultView(result: result)
            }
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                analyzeFood(image: image)
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text("Food Scanner")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.darkGray)
            
            Text("Point your camera at food to get instant nutrition info")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppTheme.largePadding)
    }
    
    private var scannerPlaceholder: some View {
        VStack(spacing: AppTheme.largePadding) {
            // Camera Viewfinder Style
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.mediumRadius)
                    .fill(AppTheme.cream)
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.mediumRadius)
                            .stroke(AppTheme.forestGreen, lineWidth: 2)
                            .opacity(0.3)
                    )
                
                VStack(spacing: AppTheme.mediumPadding) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.forestGreen.opacity(0.6))
                    
                    Text("Tap to scan food")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    
                    Text("Supports Tamil & International cuisine")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.5))
                }
            }
            .onTapGesture {
                showingCamera = true
            }
        }
    }
    
    private func analyzedImageView(image: UIImage) -> some View {
        VStack(spacing: AppTheme.mediumPadding) {
            // Image Display
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .cornerRadius(AppTheme.mediumRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.mediumRadius)
                        .stroke(AppTheme.forestGreen, lineWidth: 2)
                )
            
            // Analysis Status
            if isAnalyzing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Analyzing food...")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                }
                .padding()
                .background(AppTheme.cream)
                .cornerRadius(AppTheme.smallRadius)
            } else if let result = analysisResult {
                analysisResultPreview(result: result)
            }
        }
    }
    
    private func analysisResultPreview(result: FoodAnalysisResult) -> some View {
        VStack(spacing: AppTheme.smallPadding) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.foodName)
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.darkGray)
                    
                    Text(result.category)
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.darkGray.opacity(0.7))
                    
                    HStack {
                        Text("\(Int(result.calories)) cal")
                        Text("•")
                        Text("\(Int(result.protein))g protein")
                        Text("•")
                        Text("\(Int(result.fiber))g fiber")
                    }
                    .font(AppTheme.smallFont)
                    .foregroundColor(AppTheme.darkGray.opacity(0.6))
                }
                
                Spacer()
                
                Button("Add to Log") {
                    showingResults = true
                }
                .font(AppTheme.captionFont)
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.mediumPadding)
                .padding(.vertical, AppTheme.smallPadding)
                .background(AppTheme.forestGreen)
                .cornerRadius(AppTheme.smallRadius)
            }
        }
        .padding(AppTheme.mediumPadding)
        .background(AppTheme.cream)
        .cornerRadius(AppTheme.mediumRadius)
    }
    
    private var actionButtons: some View {
        HStack(spacing: AppTheme.mediumPadding) {
            Button(action: {
                showingCamera = true
            }) {
                VStack(spacing: AppTheme.smallPadding) {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                    Text("Camera")
                        .font(AppTheme.captionFont)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppTheme.forestGreen)
                .cornerRadius(AppTheme.smallRadius)
            }
            
            Button(action: {
                showingImagePicker = true
            }) {
                VStack(spacing: AppTheme.smallPadding) {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                    Text("Gallery")
                        .font(AppTheme.captionFont)
                }
                .foregroundColor(AppTheme.forestGreen)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppTheme.cream)
                .cornerRadius(AppTheme.smallRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                        .stroke(AppTheme.forestGreen, lineWidth: 1)
                )
            }
            
            Button(action: {
                selectedImage = nil
                analysisResult = nil
            }) {
                VStack(spacing: AppTheme.smallPadding) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                    Text("Reset")
                        .font(AppTheme.captionFont)
                }
                .foregroundColor(AppTheme.darkGray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppTheme.lightGray)
                .cornerRadius(AppTheme.smallRadius)
            }
        }
    }
    
    private var recentScansSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.mediumPadding) {
            Text("Recent Scans")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.darkGray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.mediumPadding) {
                    ForEach(sampleRecentScans, id: \.id) { scan in
                        recentScanCard(scan: scan)
                    }
                }
                .padding(.horizontal, AppTheme.smallPadding)
            }
        }
    }
    
    private func recentScanCard(scan: RecentScan) -> some View {
        VStack(spacing: AppTheme.smallPadding) {
            RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                .fill(AppTheme.beige)
                .frame(width: 80, height: 60)
                .overlay(
                    Image(systemName: "fork.knife")
                        .foregroundColor(AppTheme.forestGreen)
                )
            
            Text(scan.name)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.darkGray)
                .lineLimit(1)
            
            Text("\(scan.calories) cal")
                .font(AppTheme.smallFont)
                .foregroundColor(AppTheme.darkGray.opacity(0.7))
        }
        .frame(width: 80)
    }
    
    private func analyzeFood(image: UIImage) {
        isAnalyzing = true
        
        AIFoodRecognition.shared.analyzeFood(image: image) { result in
            switch result {
            case .success(let analysisResult):
                self.analysisResult = analysisResult
            case .failure(let error):
                print("Food analysis failed: \(error)")
                // Fallback to mock result
                self.analysisResult = FoodAnalysisResult(
                    foodName: "Unknown Food",
                    category: "General",
                    calories: 150,
                    protein: 5,
                    fiber: 2,
                    confidence: 0.5,
                    isTamil: false
                )
            }
            self.isAnalyzing = false
        }
    }
}

// MARK: - Supporting Models
struct FoodAnalysisResult {
    let foodName: String
    let category: String
    let calories: Double
    let protein: Double
    let fiber: Double
    let confidence: Double
    let isTamil: Bool
}

struct RecentScan {
    let id = UUID()
    let name: String
    let calories: Int
}

private let sampleRecentScans = [
    RecentScan(name: "Idli", calories: 150),
    RecentScan(name: "Dosa", calories: 300),
    RecentScan(name: "Rice", calories: 200),
    RecentScan(name: "Curry", calories: 180)
]

#Preview {
    FoodScannerView()
}
