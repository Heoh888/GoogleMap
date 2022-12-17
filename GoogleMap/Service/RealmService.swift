//
//  RealmService.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 18.12.2022.
//

import RealmSwift

class RealmService {
    enum ErrorsFromCache: Error {
        case noRealmObjct(String)
        case noPrimaryKeys(String)
        case failedToReads(String)
    }
    
    func add<T: Object>(object: T) throws {
        let realm = try! Realm()
//        print(realm.configuration.fileURL)
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func add<T: Object>(object: [T]) throws {
        let realm = try! Realm()
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
}
