//
//  AuthorizationsViewModel.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 09.01.2023.
//

import Foundation

class AuthorizationsViewModel: ObservableObject {
    @Published var userLoggedIn = false
    
    let service = RealmService()
    
    func registration(userName: String, email: String, password: String) {
        do {
            let user = UserModel()
            user.login = userName
            user.email = email
            user.password = password
            try self.service.add(object: user)
        } catch {
            print(error)
        }
    }
    
    func login(userName: String, password: String) {
        guard let result = service.read(UserModel.self) else { return }
        print(result)
        result.forEach {
            if $0.login == userName && $0.password == password {
                userLoggedIn = true
            }
        }
    }
}
