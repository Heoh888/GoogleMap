//
//  RegistrationView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 09.01.2023.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var userName: String
    @Binding var password: String
    @Binding var email: String
    
    var body: some View {
        VStack {
            CustomTextField(text: $userName, label: "Name", identifier: "Registration Name")
            CustomTextField(text: $email, label: "Email address", identifier: "Registration Email address")
            CustomTextField(text: $password, label: "Password", identifier: "Registration Password", securityOption: true)
        }
    }
}
