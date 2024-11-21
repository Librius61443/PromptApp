//
//  ClearableTextField.swift
//  PromptApp
//
//  Created by librius on 2024-03-12.
//

import Foundation
import SwiftUI

struct ClearableTextField: UIViewRepresentable {
    @Binding var text: String
    var onClear: () -> Void
    
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.delegate = context.coordinator
        textField.textColor = .black
        textField.minimumFontSize = 15
        textField.tintColor = UIColor(Color("IconPink"))
        
//        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
//                    clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//                    clearButton.tintColor = UIColor(Color("IconPink"))
//                    clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//                }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onClear: onClear)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onClear: () -> Void
        
        init(text: Binding<String>, onClear: @escaping () -> Void) {
            _text = text
            self.onClear = onClear
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//                    textField.resignFirstResponder()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    return true
                }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            onClear()
            return true
        }
    }
}
