//
//  ContentViewModel.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 16.12.2022.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var routeTime = ""
    
    let service = RealmService()
    let testEntity = RouteModel()
    
    func timer(seconds: Int) {
        routeTime = "\(seconds / 3600):\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
    }
    
    func saveResult() {
        testEntity.routeTime = routeTime
        DispatchQueue.main.async {
            try! self.service.add(object: self.testEntity)
        }
    }
}
