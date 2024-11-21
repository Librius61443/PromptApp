//
//  FontStyles.swift
//  PromptApp
//
//  Created by librius on 2024-01-08.
//

import Foundation
import SwiftUI

extension Font{
    
    static var PromptFont: Font{
        return Font.custom("Inter-Bold", size: 27)
    }
    
    static var HeadlineFont: Font{
        return Font.custom("Inter-Medium", size: 23)
    }
    
    static var FeedFont: Font{
        return Font.custom("Inter-Medium", size: 15)
    }
    
    static var ButtonFont: Font{
        return Font.custom("Inter-SemiBold", size: 25)
    }
    
    static var UserBioFont: Font{
        return Font.custom("Inter-Medium", size: 20)
    }
    
    static var TabFont: Font{
        return Font.custom("Inter-Medium", size: 12)
    }
}
