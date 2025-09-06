import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    let onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageSelected(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// Modern PhotosPicker for iOS 16+
@available(iOS 16.0, *)
struct ModernImagePicker: View {
    let onImageSelected: (UIImage) -> Void
    @State private var selectedItem: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.paddingLarge) {
                Spacer()
                
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.forestGreen)
                
                Text("Select Food Photo")
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.navy)
                
                Text("Choose a photo from your gallery to analyze")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.warmGray)
                    .multilineTextAlignment(.center)
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Choose Photo")
                        .primaryButtonStyle()
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            onImageSelected(image)
                            dismiss()
                        }
                    }
                }
                
                Spacer()
            }
            .background(AppTheme.beige.ignoresSafeArea())
            .navigationTitle("Photo Library")
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

#Preview {
    ImagePicker { _ in }
}
