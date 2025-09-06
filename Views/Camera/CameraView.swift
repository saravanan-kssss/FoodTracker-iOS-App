import SwiftUI
import AVFoundation
import UIKit

struct CameraView: UIViewControllerRepresentable {
    let onImageCaptured: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// Fallback view for simulator or when camera is not available
struct CameraSimulatorView: View {
    let onImageCaptured: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.paddingLarge) {
                Spacer()
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.warmGray)
                
                Text("Camera Not Available")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.navy)
                
                Text("Camera is not available in the simulator. Use a physical device for food scanning.")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.warmGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.paddingLarge)
                
                Button("Simulate Food Scan") {
                    // Create a placeholder image for simulation
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
                    let image = renderer.image { context in
                        AppTheme.lightGray.setFill()
                        context.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
                        
                        let text = "Sample Food"
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 24),
                            .foregroundColor: UIColor.gray
                        ]
                        let textSize = text.size(withAttributes: attributes)
                        let textRect = CGRect(
                            x: (300 - textSize.width) / 2,
                            y: (300 - textSize.height) / 2,
                            width: textSize.width,
                            height: textSize.height
                        )
                        text.draw(in: textRect, withAttributes: attributes)
                    }
                    
                    onImageCaptured(image)
                    dismiss()
                }
                .primaryButtonStyle()
                
                Spacer()
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.forestGreen)
                }
            }
        }
    }
}

// Check if camera is available
extension CameraView {
    static var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}

#Preview {
    CameraSimulatorView { _ in }
}
