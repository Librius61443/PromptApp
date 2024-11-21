//
//  SearchBar.swift
//  PromptApp
//
//  Created by librius on 2024-03-11.
//

import Foundation
import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
//    @Binding var searchResults: [String]
    var onClear: () -> Void
    
    var body: some View {
        ZStack {
            HStack{
                if searchText.isEmpty{
                    Text("Enter username")
                        .foregroundColor(Color("PlaceholderColor"))
                }
                Spacer()
            }
            ClearableTextField(text: $searchText, onClear: onClear)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.vertical, 10)
        }
        .frame(width: 300, height: 30)
        .modifier(TextFieldMod())
    }
}

