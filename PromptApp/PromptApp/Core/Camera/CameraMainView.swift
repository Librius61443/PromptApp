//
//  ContentView.swift
//  CustomCameraApp
//
//  Created by Amisha Italiya on 03/10/23.
//

import SwiftUI

struct CameraMainView: View {
	
	@ObservedObject var viewModel = CameraViewModel()

	
	@State private var isFocused = false
	@State private var isScaled = false
	@State private var focusLocation: CGPoint = .zero
	@State private var currentZoomFactor: CGFloat = 1.0
    @State private var switchview = false
    
    @Environment(\.dismiss) var dismiss

	
	var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Image("promptlogo")
                        .aspectFill()
                        .frame(width: 175, height: 70)
                    
                    //					Button(action: {
                    //						viewModel.switchFlash()
                    //					}, label: {
                    //						Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                    //							.font(.system(size: 20, weight: .medium, design: .default))
                    //					})
                    //					.accentColor(viewModel.isFlashOn ? .yellow : .white)
                    
                        ZStack {
                            CameraPreview(session: viewModel.session) { tapPoint in
                                isFocused = true
                                focusLocation = tapPoint
                                viewModel.setFocus(point: tapPoint)
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                            .gesture(MagnificationGesture()
                                .onChanged { value in
                                    self.currentZoomFactor += value - 1.0 // Calculate the zoom factor change
                                    self.currentZoomFactor = min(max(self.currentZoomFactor, 0.5), 10)
                                    self.viewModel.zoom(with: currentZoomFactor)
                                })
                            .animation(.easeInOut, value: 0.5)
                            .aspectRatio(3/4, contentMode: .fit)
//                            .frame(width: 350, height: 350)
                            
                            if isFocused {
                                FocusView(position: $focusLocation)
                                    .scaleEffect(isScaled ? 0.8 : 1)
                                    .onAppear {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                            self.isScaled = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                self.isFocused = false
                                                self.isScaled = false
                                            }
                                        }
                                    }
                            }
                        }
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image("Back icon")
                                    .aspectFit()
                                    .frame(width: 30, height: 30)
                            }
                            Spacer()
                            CaptureButton (viewModel: viewModel)
                            Spacer()
                            CameraSwitchButton { viewModel.switchCamera() }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)

                    }
            }
            .alert(isPresented: $viewModel.showAlertError) {
                Alert(title: Text(viewModel.alertError.title), message: Text(viewModel.alertError.message), dismissButton: .default(Text(viewModel.alertError.primaryButtonTitle), action: {
                    viewModel.alertError.primaryAction?()
                }))
            }
            .alert(isPresented: $viewModel.showSettingAlert) {
                Alert(title: Text("Warning"), message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."), dismissButton: .default(Text("Go to settings"), action: {
                    self.openSettings()
                }))
            }
            .onAppear {
                viewModel.setupBindings()
                viewModel.requestCameraPermission()
            }
        }
	}
	
	func openSettings() {
		let settingsUrl = URL(string: UIApplication.openSettingsURLString)
		if let url = settingsUrl {
			UIApplication.shared.open(url, options: [:])
		}
	}
}


struct CaptureButton: View {
    @ObservedObject var viewModel = CameraViewModel()
    
    @State private var showAuthView = false
    @Environment(\.dismiss) var dismiss


	var body: some View {
            Button{
                viewModel.captureImage()
                    showAuthView.toggle()
                
            }label: {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 70, height: 70, alignment: .center)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.8), lineWidth: 2)
                            .frame(width: 59, height: 59, alignment: .center)
                    )
            }
            .fullScreenCover(isPresented: $showAuthView, onDismiss: dismissView) {
                PreviewPostView(viewModel: viewModel)
                    }
	}
    
    func dismissView(){
        if viewModel.retakePic{
            
        }
        else{
            dismiss()
        }
    }
}

struct CameraSwitchButton: View {
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Circle()
				.foregroundColor(Color.gray.opacity(0.2))
				.frame(width: 50, height: 50, alignment: .center)
				.overlay(
					Image(systemName: "camera.rotate.fill")
						.foregroundColor(.white))
		}
	}
}

struct FocusView: View {
	
	@Binding var position: CGPoint
	
	var body: some View {
		Circle()
			.frame(width: 70, height: 70)
			.foregroundColor(.clear)
			.border(Color.yellow, width: 1.5)
			.position(x: position.x, y: position.y)
	}
}

#Preview {
    CameraMainView()
}
