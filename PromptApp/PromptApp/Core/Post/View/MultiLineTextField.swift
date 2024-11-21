//
//  TestingMessageBar.swift
//  PromptApp
//
//  Created by librius on 2024-07-18.
//

import Foundation
import SwiftUI

struct MultiLineTextField: View {
    @Binding var inputText: String

    var body: some View {
        VStack(alignment: .leading) {

            HStack(alignment: .bottom) {
                TextField("Comment smth", text: $inputText, axis: .vertical)
                    .lineLimit(1...4)
                    .foregroundColor(.black)
                    .font(Font.FeedFont)
                    .frame(width: 230)
                    .frame(minHeight: 30)
                    .padding([.top], 5)
                    .padding([.leading], 10)
                    .padding([.trailing], 5)
                    .padding([.bottom], 5)
                    .multilineTextAlignment(.leading)




                if !inputText.isEmpty {
                    Button(action: {
                        inputText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("IconPink"))
                            .padding(.trailing, 8)
                            .frame(width: 15, height: 15)
                    }
                    .padding(.leading, 5)
                    .padding(.bottom, 12)
                    .padding(.trailing, 7)

                }
                    
            }
            .background(Color.gray)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            

        }
        .padding(.leading, 25)
        .frame(width: 230)
        .frame(minHeight: 30)

    }
}

//#Preview {
//    TestingMessageBar(inputText: "LOL")
//}
