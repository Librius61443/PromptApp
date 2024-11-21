//
//  Comment.swift
//  PromptApp
//
//  Created by librius on 2024-07-14.
//

import Foundation
import Firebase

struct Comment: Identifiable, Hashable, Codable{
    let id: String
    var ownerUID: String
    var comment: String
    var owner: User?
    var replies: [Comment]?
}

extension Comment {
    static var Mock_Comment: [Comment] = [
        .init(
            id: NSUUID().uuidString,
            ownerUID: NSUUID().uuidString,
            comment: "mock comment",
            owner: User.Mock_User[0]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUID: NSUUID().uuidString,
            comment: "mock comment",
            owner: User.Mock_User[0]
        )]
}
