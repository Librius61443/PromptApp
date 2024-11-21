//
//  PostViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-06-05.
//

import Foundation
import SwiftUI
import Firebase


class PostViewModel: ObservableObject{
    
    @Published var post : Post
    @Published private var commentData = [String: Any]()    
    @Published var comments = [Comment]()
    @Published var uid = String()


    @MainActor
    init(post: Post){
        self.post = post
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        self.uid = uid
        updateComment()
    }
    
    @MainActor
    func addAComment(stringComment: String) async throws{
        let cmtRef = Firestore.firestore().collection("PromptPosts").document(post.id).collection("Comments").document()

        let comment = Comment(id: cmtRef.documentID, ownerUID: uid, comment: stringComment)
        guard let encodedComment = try? Firestore.Encoder().encode(comment) else {return}
        
        try await cmtRef.setData(encodedComment)
    }
    
    @MainActor
    func addAReply(stringReply: String, cmtID: String) async throws{
        let replyRef = Firestore.firestore().collection("PromptPosts").document(post.id).collection("Comments").document(cmtID).collection("Replies").document()

        let reply = Comment(id: replyRef.documentID, ownerUID: uid, comment: stringReply)
        guard let encodedCReply = try? Firestore.Encoder().encode(reply) else {return}
        
        try await replyRef.setData(encodedCReply)
    }
    
    @MainActor
    func fetchComments() async throws -> [Comment]{
        var commentList = [Comment]()
        
        let querySnapshot = try await Firestore.firestore().collection("PromptPosts").document(post.id).collection("Comments").getDocuments()
        
        if querySnapshot.isEmpty{
            commentList = []
        }
        else{
            let commentsData = try querySnapshot.documents.compactMap({ try $0.data(as: Comment.self)})
            commentList += commentsData
        }
        
        for x in 0 ..< commentList.count {
            let comment = commentList[x]
            let ownerUid = comment.ownerUID
            let cmtUser = try await UserService.fetchUser(withUid: ownerUid)
            commentList[x].owner = cmtUser
            commentList[x].replies = try await fetchReplies(cmtID: comment.id)
        }
        
        return commentList
    }
    
    func fetchReplies(cmtID: String) async throws -> [Comment]{
        var replies = [Comment]()
        
        let querySnapshot = try await Firestore.firestore().collection("PromptPosts").document(post.id).collection("Comments").document(cmtID).collection("Replies").getDocuments()
        
        if querySnapshot.isEmpty{
            replies = []
        }
        else{
            let repliesData = try querySnapshot.documents.compactMap({ try $0.data(as: Comment.self)})
            replies += repliesData
        }
        
        for x in 0 ..< replies.count {
            let reply = replies[x]
            let ownerUid = reply.ownerUID
            let replyUser = try await UserService.fetchUser(withUid: ownerUid)
            replies[x].owner = replyUser
        }
        
        return replies
    }
    
    @MainActor
    private func updateComment() {
        
        Firestore.firestore().collection("PromptPosts").document(post.id).collection("Comments").addSnapshotListener { querySnapshot, error in
            if let error = error {
                  print("Error retreiving posts collection: \(error)")
                }
            else{
                Task{
                    self.comments = try await self.fetchComments()
                }
            }
          }
    }
}
