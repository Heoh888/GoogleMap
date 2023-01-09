//
//  LoginView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 09.01.2023.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var userName: String
    @Binding var password: String
    
    var body: some View {
        VStack {
            CustomTextField(text: $userName, label: "Name", identifier: "Registration Name")
            CustomTextField(text: $password, label: "Password", identifier: "Login Password", securityOption: true)
        }
    }
}

