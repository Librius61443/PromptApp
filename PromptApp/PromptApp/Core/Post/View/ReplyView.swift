//
//  ReplyView.swift
//  PromptApp
//
//  Created by librius on 2024-07-27.
//

import SwiftUI

struct ReplyView: View {
    @State var comment: Comment
    @State var replying: Bool = false
    @Binding var reply: Comment

    var body: some View {
        VStack(spacing: 20) {
            ForEach(Array(comment.replies!.enumerated()), id: \.element) { (x, reply) in
                CommentView(comment: reply, replying: $replying, reply: $reply)
            }
        }
        .padding(.leading, 50)
    }
}

//#Preview {
//    ReplyView()
//}
