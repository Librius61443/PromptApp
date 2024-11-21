//
//  PreviewPostView.swift
//  PromptApp
//
//  Created by librius on 2024-01-30.
//

import SwiftUI
import UIKit


struct PreviewPostView: View {
    @ObservedObject var viewModel = CameraViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) var displayScale
    
    @State private var currentPosition: CGSize = .zero
    @State private var initialPosition: CGSize = .zero
    @State private var uiImage: UIImage?
    
    @State private var isLoading = false

    var body: some View {


        ZStack(alignment: .top){
                Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack(){
                    HStack(){
                        Button{
                            viewModel.deleteImage()
                            viewModel.retakePic = true
                            dismiss()
                        }label: {
                            Image("Back icon")
                                .aspectFill()
                                .frame(width: 35, height: 35)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 15)
                    Spacer()

                    let imageContent = PhotoThumbnail(viewModel: viewModel)
                    imageContent
                    
                    Spacer()
                                                
                        Button{
                            Task{
                                let image = ImageRenderer(content: imageContent)
                                image.scale = displayScale

                                if let uiImage = image.uiImage{
                                    try await UploadPostViewModel().uploadPost(uiImage: uiImage)
                                }
                                viewModel.retakePic = false
                                isLoading = false
                                dismiss()
                            }
                            isLoading = true
                        } label: {
                            
                                Circle()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color(.white))
                                    .opacity(0.9)
                                    .overlay(
                                        Image(systemName: "paperplane")
                                            .aspectFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color("IconPink"))
                                            .padding(.top, 5)
                                            .padding(.trailing, 5)
                                    )
                        }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            
            if isLoading{
                LoadingView()
            }
        }
    }
}

struct PhotoThumbnail: View {
    @ObservedObject var viewModel = CameraViewModel()
    @State private var rotation: Double = 0
    
    @State private var currentPosition: CGSize = .zero
    @State private var initialPosition: CGSize = .zero

    var body: some View {
        Group {
                if let image = viewModel.capturedImage {
                    if viewModel.flipImageCheck() == 2{
                        Image(uiImage: image)
                            .aspectFill()
                            .rotation3DEffect(.degrees(180), axis: (x: -10, y: 0, z: 0))
                            .rotationEffect(.radians(.pi))
                    }
                    else{
                        Image(uiImage: image)
                            .aspectFill()
                    }
                } else {
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color("IconPink"), lineWidth: 5)
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: rotation))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                        }
            }
        }
        .offset(x: 0, y: min(max(currentPosition.height, -60), 60))
        .gesture(
            DragGesture()
                .onChanged { value in
                    currentPosition = CGSize(width: 0, height: initialPosition.height + value.translation.height)
                }
                .onEnded { value in
                    initialPosition = currentPosition
                }
        )
        .frame(width: 330, height: 330)
        .clipped()
        
    }
    
}

#Preview {
    PreviewPostView()
}

