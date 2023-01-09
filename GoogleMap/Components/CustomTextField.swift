//
//  CustomTextField.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 09.01.2023.
//

import SwiftUI

struct CustomTextField: View {
    
    // MARK: - Properties
    @Binding var text: String
    
    var label: String = ""
    var identifier: String
    var securityOption: Bool = false
    
    // MARK: - Views
    var body: some View {
        VStack(alignment: .leading) {
            if securityOption {
                SecureField(label, text: $text)
                    .accessibility(identifier: identifier)
            } else {
                TextField(label, text: $text)
                    .accessibility(identifier: identifier)
            }
        }
        .padding(.leading)
        .padding(.vertical)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.top, 30)
        .padding(.horizontal, 50)
    }
}
