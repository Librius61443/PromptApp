//
//  CustomMessageBar.swift
//  PromptApp
//
//  Created by librius on 2024-05-06.
//

import SwiftUI

struct CustomMessageBar: View {
    
    @Binding var message: String
//    @Binding var searchResults: [String]
    var placeholderText: String
    
    var onClear: () -> Void
    var body: some View {
        ZStack(alignment: .leading) {
            HStack{
                if message.isEmpty{
                    Text("\(placeholderText)")
                        .foregroundColor(Color("PlaceholderColor"))
                        .font(Font.FeedFont)
                }
                Spacer()
            }
            ClearableTextField(text: $message, onClear: onClear)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.vertical, 10)
                .frame(width: 200)
                .lineLimit(5)
        }
        .frame(width: 260, height: 15)
        .modifier(TextFieldMod())
    }
}
