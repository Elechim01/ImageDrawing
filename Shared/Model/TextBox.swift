//
//  TextBox.swift
//  ImageDrawing (iOS)
//
//  Created by Michele Manniello on 24/04/21.
//

import SwiftUI
import PencilKit
struct Textbox: Identifiable {
    var id = UUID().uuidString
    var text : String = ""
    var isbold : Bool = false
    //    For Dragging the view over the screen
    var offset : CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor : Color = .white
//    you can add what ever property here....
//    im simply stopping on this...
    var isAdded : Bool = false
    
}
