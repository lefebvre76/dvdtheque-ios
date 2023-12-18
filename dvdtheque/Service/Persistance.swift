//
//  Persistance.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import Foundation

class Persistance {
    enum Key: String {
        case email = "user.email"
        case token = "user.token"
    }

    func persiste(key: Key, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    func clear(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    func get(key: Key) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
        if let value = UserDefaults.standard.value(forKey: key.rawValue) {
            return value
        } else {
            return nil
        }
    }
}
