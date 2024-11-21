//
//  UploadPostViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-02-21.
//

import PhotosUI
import Firebase
import SwiftUI

@MainActor
class UploadPostViewModel: ObservableObject{
    
    func uploadPost(uiImage: UIImage?) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uiImage = uiImage else {return}
        
        let user = try await UserService.fetchUser(withUid: uid)
        let prompt = user.currentPrompt
        
        let postRef = Firestore.firestore().collection("PromptPosts").document()
        guard let imageUrl = try await ImageUpLoader.uploadImage(image: uiImage) else {return }

        let post = Post(id: postRef.documentID, ownerUID: uid, caption: "", imageURL: imageUrl, promt: prompt, likes: 0, timeStamp: Timestamp())
        guard let encodedPost = try? Firestore.Encoder().encode(post) else {return}
        
        
        try await postRef.setData(encodedPost)
        
    }
    
}
