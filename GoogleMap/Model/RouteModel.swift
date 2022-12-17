//
//  RouteModel.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 18.12.2022.
//

import Foundation
import RealmSwift


class RouteModel: Object {
    @objc dynamic var routeTime: String = ""
    
    override class func primaryKey() -> String? {
        return "routeTime"
    }
}
