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
        NavigationView{
            VStack{
                if let ImageFile = UIImage(data: model.imageData){
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
//        Showing Image Picker to pick Image...
        .sheet(isPresented: $model.showImagePicker, content: {
            ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
