//
//  TextFieldMod.swift
//  PromptApp
//
//  Created by librius on 2024-01-26.
//

import Foundation
import SwiftUI

struct TextFieldMod: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 25)
            .foregroundColor(Color.black)
    }
}
