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
                let size = proxy.frame(in: .global)
                DispatchQueue.main.async {
                    if model.rect == .zero{
                        model.rect = size
                    }
                }
                return AnyView(
            //            UIKIT Pencil Kit Drawing View...
                    ZStack {
                        CanvasView(canvas: $model.canvas, imageData: $model.imageData, toolPicker: $model.toolPicker, rect: size.size)
//                        Custom Texts
//                        disply text boxes....
                        ForEach(model.textBoxes){ box in
                            Text(model.textBoxes[model.currentIndex].id == box.id && model.addnewBox ? "" :  box.text)
//                                you can also include text size in model
//                                and can use those text siezes in there text boxes..
                                .font(.system(size:30))
                                .fontWeight(box.isbold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
//                            drag gesture...
                                .gesture(DragGesture().onChanged({ (value) in
                                    let current = value.translation
//                                    Adding with last Offset...
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                    model.textBoxes[getIndex(textBox: box)].offset = newTranslation
                                    
                                }).onEnded({ (value) in
//                                    saving the last offset for exact drag postion....
                                    model.textBoxes[getIndex(textBox: box)].lastOffset = value.translation
                                }))
//                            editing the typed one...
                                .onLongPressGesture {
//                                    closing the toolbar...
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(textBox: box)
                                    withAnimation{
                                        model.addnewBox = true
                                    }
                                }
                        }
                    })
            }

        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    model.saveImage()
                }, label: {
                    Text("Save")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
//                    creazione One New Box...
                    model.textBoxes.append(Textbox())
//                    updating index...
                    model.currentIndex = model.textBoxes.count - 1
                    withAnimation{
                        model.addnewBox.toggle()
                    }
//                    closng the tool bar...
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
    }
    func getIndex(textBox : Textbox) -> Int {
        let index = model.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        return index
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
