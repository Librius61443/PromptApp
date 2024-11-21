//
//  CircularProfileView.swift
//  PromptApp
//
//  Created by librius on 2024-02-20.
//

import SwiftUI
import Kingfisher

enum ProfileImageSize{
    case xLarge
    case large
    case small
    case xSmall

    
    var dimension: CGFloat{
        switch self {
        case .xLarge:
            return 165
        case .large:
            return 50
        case .small:
            return 45
        case .xSmall:
            return 30
        }
    }
}
struct CircularProfileView: View{
    let user: User
    let size: ProfileImageSize
    
    var body: some View {
        if let imgUrl = user.profileImageURL{
            KFImage(URL (string: imgUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
        else{
            Image("Default profile pic")
                .aspectFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
}
