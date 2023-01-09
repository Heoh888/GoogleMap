//
//  RealmService.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 18.12.2022.
//

import RealmSwift

class RealmService {
    
    func add<T: Object>(object: T) throws {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try Realm(configuration: config)
        print(realm.configuration.fileURL)
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T>? {
        guard let realm = try? Realm() else { return nil }
        return realm.objects(T.self)
    }
    
    func deleteAll() throws {
        let realm = try! Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}
