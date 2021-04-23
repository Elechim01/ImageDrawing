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
    
//    cancel function...
    func cancelImageEditing(){
        imageData = Data(count: 0)
        canvas = PKCanvasView()
    }
}
