//
//  CommentView.swift
//  PromptApp
//
//  Created by librius on 2024-05-13.
//

import SwiftUI

struct BackPostView: View{
    @Binding var degree : Double
    var namespace: Namespace.ID

    var body: some View{

            ZStack(){
                Color(.white)
            }
            .background(){
                Rectangle()
                    .matchedGeometryEffect(id: "cmtView", in: namespace)
                    .transition(.scale(scale: 1))
            }
            .frame(width: 340, height: 385)
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }

}
