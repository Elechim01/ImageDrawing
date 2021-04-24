//
//  DrawingViewModel.swift
//  ImageDrawing (iOS)
//
//  Created by Michele Manniello on 23/04/21.
//

import SwiftUI
import PencilKit
// It holds all our drawing data...

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData : Data = Data(count: 0)
    
//    Canvas for drawing..
    @Published var canvas = PKCanvasView()
//    tool picker....
    @Published var toolPicker = PKToolPicker()
//    List Of Textboxes...
    @Published var textBoxes : [Textbox] = []
    @Published var addnewBox = false
//    Current Index...
    @Published var currentIndex : Int = 0
    
//    Saving the view Frame Size...
    @Published var rect : CGRect = .zero
//    alert
    @Published var showAlert = false
    @Published var message = ""
    
//    cancel function...
    func cancelImageEditing(){
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
//    cancel the text view
    func cancelTextView(){
//        showing again the tool bar
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        withAnimation{
            addnewBox = false
        }
//        Rimuovo l'elemento se è stato cancellato
//        avoiding the remove of already added...
        if !textBoxes[currentIndex].isAdded{
            textBoxes.removeLast() 
        }
       
    }
    func saveImage (){
//        generationf Image form both  canvas and our textboxes View...
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
//        drawing text boxes...
        let SwiftUIView = ZStack{
            ForEach(textBoxes){[self] box in
                Text(textBoxes[currentIndex].id == box.id && addnewBox ? "" :  box.text)
//                                you can also include text size in model
//                                and can use those text siezes in there text boxes..
                    .font(.system(size:30))
                    .fontWeight(box.isbold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
            }
        }
        let controller = UIHostingController(rootView: SwiftUIView).view!
        controller.frame = rect
//        clearing bg...
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
//        canvas...
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
//        Getting image...
      let generateImage = UIGraphicsGetImageFromCurrentImageContext()
//        ending render....
        UIGraphicsEndImageContext()
        
        if let image = generateImage?.pngData(){
//            saving image as PNG ...
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            print("success....")
            self.message = "Salvataggio avvenuto con successo!!!"
            self.showAlert.toggle()
            
        }
    }
    
}
