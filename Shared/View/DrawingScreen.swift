//
//  DrawingScreen.swift
//  ImageDrawing (iOS)
//
//  Created by Michele Manniello on 23/04/21.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model : DrawingViewModel
    var body: some View {
        ZStack{
            GeometryReader{ proxy -> AnyView in
                let size = proxy.frame(in: .global).size
                return AnyView(
            //            UIKIT Pencil Kit Drawing View...
                    ZStack {
                        CanvasView(canvas: $model.canvas, imageData: $model.imageData, toolPicker: $model.toolPicker, rect: size)
//                        Custom Texts
                        
                    })
                
            }

        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Text("Save")
                })
               
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
    }
}

struct DrawingScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
struct CanvasView: UIViewRepresentable {
    // since we need to get the drawing so were binding....
    @Binding var canvas : PKCanvasView
    @Binding var imageData : Data
    @Binding var toolPicker : PKToolPicker
//    View Size...
    var rect : CGSize
    
    
    func makeUIView(context: Context) ->  PKCanvasView{
        
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        //        appending the image in canvas subview....
        if let image = UIImage(data: imageData){
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            //            basically were settings image to the back of the canvas...
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            //        showing tool picker...
            //            were settings it as first responder and making it as visible
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
            
            
        }
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        Update Ui will update for each actions...

        }
    
}
