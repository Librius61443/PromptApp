//
//  LeftSideTransition.swift
//  PromptApp
//
//  Created by librius on 2024-03-11.
//

import Foundation
import SwiftUI

struct LeftSlideTransition: ViewModifier {
    var isActive: Bool
    var geometry: GeometryProxy
    
    func body(content: Content) -> some View {
        content
            .offset(x: isActive ? 0 : -geometry.size.width)
//            .animation(.easeInOut(duration: 0.5))
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: 0.5)
    }
}
