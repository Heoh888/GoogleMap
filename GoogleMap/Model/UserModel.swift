//
//  User.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 09.01.2023.
//

import Foundation
import RealmSwift

final class UserModel: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var login: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""

    override class func primaryKey() -> String? {
        return "login"
    }
}
