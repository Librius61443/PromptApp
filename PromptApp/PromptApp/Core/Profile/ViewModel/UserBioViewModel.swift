//
//  UserBioViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-02-18.
//

import PhotosUI
import Firebase
import SwiftUI

@MainActor
class UserBioViewModel: ObservableObject{
    @Published var user: User
    
    @Published var uiImage: UIImage?
    
    @Published var fullname = ""
    @Published var username = ""
    @Published var infoStatus = false
    
    @Published private var data = [String: Any]()
    
    init(user: User){
        self.user = user
        
        if let fullname = user.fullname{
            self.fullname = fullname
        }
        
        self.username = user.username
    }
    
    func updateUserData() async throws {
        
        if !data.isEmpty {
            try await Firestore.firestore().collection("user").document(user.id).updateData(data)
            try await fetchCurrentUser(userID: user.id)
            infoStatus = false
        }
        
    }
    
    func fetchCurrentUser(userID: String) async throws{
        self.user = try await UserService.fetchUser(withUid: userID)
    }
    
    func UpdateProfileImage(uiImage: UIImage?) async throws{
        self.uiImage = uiImage
        
        if let uiImage = self.uiImage{
            let imageUrl = try? await ImageUpLoader.uploadImage(image: uiImage)
            data["profileImageURL"] = imageUrl
        }
    }
    
    func CheckProfilPic(uiImage: UIImage?) -> Bool{
        if(self.uiImage == uiImage){
            return false
        }
        else if(uiImage?.size.width == 0 || uiImage?.size.height == 0){
            return false
        }
        return true
    }
    
    func CheckFullname(){
        
        if user.fullname != fullname {
            data["fullname"] = fullname
            infoStatus = true
            
        }
        else{
            infoStatus = false
        }
        
    }
    
    func CheckUsername(){
                
        if !username.isEmpty && user.username != username {
            data["username"] = username
            infoStatus = true
        }
        else{
            infoStatus = false
        }
        
    }
    
    func getInfoStatus() -> Bool{
        return infoStatus
    }
}
