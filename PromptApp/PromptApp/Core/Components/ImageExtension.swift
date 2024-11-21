//
//  ImageExtension.swift
//  PromptApp
//
//  Created by librius on 2024-01-25.
//

import Foundation
import SwiftUI

extension Image {
    func aspectFill() -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .scaledToFill()
    }
    
    func aspectFit() -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .scaledToFit()
    }
}
