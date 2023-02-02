//
//  RouteModel.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 18.12.2022.
//

import Foundation
import RealmSwift

final class RouteModel: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var routeTime: String = ""
    
    let latitude = List<Double>()
    let longitude = List<Double>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
