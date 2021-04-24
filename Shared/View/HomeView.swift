//
//  HomeView.swift
//  ImageDrawing (iOS)
//
//  Created by Michele Manniello on 23/04/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var model = DrawingViewModel()
    var body: some View {
//       home Screen
        ZStack {
            NavigationView{
                VStack{
                    if let _ = UIImage(data: model.imageData){
                        DrawingScreen()
                            .environmentObject(model)
    //                    Setting cancel button if image selected...
                            .toolbar(content: {
                                
                                ToolbarItem(placement: .navigationBarLeading){
                                Button(action: {
                                    model.cancelImageEditing()
                                }, label: {
                                    Image(systemName: "xmark")
                                    
                                })
                                }
                            })
                    }else{
    //                    Show Image picker Button...
                        Button(action: {
                            model.showImagePicker.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 70, height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: -5)
                        })
                    }
                }
                .navigationTitle("Imge Editor")
            }
            if model.addnewBox{
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
//                TextField....
                TextField("Type Here",text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35,weight: model.textBoxes[model.currentIndex].isbold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBoxes[model.currentIndex].textColor)
                    .padding()
                
//                add and cancel button...
                HStack{
                    Button(action: {
//                        tolling the isAdded
                        model.textBoxes[model.currentIndex].isAdded = true
//                        closing the view
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        withAnimation{
                            model.addnewBox = false
                        }
                    }, label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    Spacer()
                    Button(action: {
                        model.cancelTextView()
                    }, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                .overlay(
//                    Color Picker...
                    HStack(spacing: 15) {
                        ColorPicker("",selection: $model.textBoxes[model.currentIndex].textColor)
                            .labelsHidden()
                        Button(action: {
                            model.textBoxes[model.currentIndex].isbold.toggle()
                        }, label: {
                            Text(model.textBoxes[model.currentIndex].isbold ? "Normal": "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    //        Showing Image Picker to pick Image...
            .sheet(isPresented: $model.showImagePicker, content: {
                ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("OK")))
        })
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
