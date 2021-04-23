//
//  ImpagePicker.swift
//  ImageDrawing (iOS)
//
//  Created by Michele Manniello on 23/04/21.
//

import SwiftUI
//Bulding Image Picker Using UIKit...
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    class Coordinator: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        Getting Parent view context to update image data...
        var parent: ImagePicker
        init(parent : ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            getting image and closing
            if let imageData = (info[.originalImage] as? UIImage)?.pngData(){
                parent.imageData = imageData
                parent.showPicker.toggle()
            }
            
            
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            closing the view if cancelled....
            parent.showPicker.toggle()
        }
    }
}
