//
//  StorageManager.swift
//  StorageManagerAdvance
//
//  Created by wei-tsung-cheng on 2019/5/29.
//  Copyright © 2019 wei-tsung cheng. All rights reserved.
//

import Foundation

final class StorageManager {

    static let shared: StorageManager = StorageManager()

    /// Storage Key
    enum StorageKeys: String {
        // Portal
        case generalUser
        
        // Language Setting
        case languageIsSelected
        case selectedLanguageKey
        
        // Region Setting
        case regionIsSelected
        case selectedRegionKey
        
        // ServerType
        case serverType
    }

    private init() {

    }

    /// Load value from UserDefault
    ///
    /// - Parameter key: UserDefault key
    /// - Returns: return UserDefault value
    func load<T>(for key: StorageKeys) -> T? {

        let value: T? = UserDefaults.standard.value(forKey: key.rawValue) as? T

        print("\(#function) \(String(describing: value))")
        return value
    }

    /// Load codable object from UserDefault
    ///
    /// - Parameter key: UserDefault key
    /// - Returns: return UserDefault value
    func loadObject<T: Codable>(for key: StorageKeys) -> T? {

        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data else {
            return nil
        }

        guard let object: T = data.toObject() else {
            return nil
        }

        return object
    }

    /// Load codable object array from UserDefault
    ///
    /// - Parameter key: UserDefault key
    /// - Returns: return UserDefault value
    func loadObjectArray<T: Codable>(for key: StorageKeys) -> [T]? {

        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? [Data] else {
            return nil
        }

        let objectArray = data.map { (data) -> T? in

            guard let object: T = data.toObject() else {
                return nil
            }

            return object
            }.compactMap { $0 }

        print("\(#function) \(objectArray)")
        return objectArray
    }

    /// Save value in UserDefault
    ///
    /// - Parameters:
    ///   - key: UserDefault key
    ///   - value: UserDefault value
    func save(for key: StorageKeys, value: Any?) {

        print("\(#function) \(value ?? "")")
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    /// Save codable object in UserDefault
    ///
    /// - Parameters:
    ///   - key: UserDefault key
    ///   - value: UserDefault value
    func saveObject(for key: StorageKeys, value: Codable?) {

        if let value = value,
            let data = value.toJSONData() {

            print("\(#function) \(value)")
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }

    /// Save codable object array in UserDefault
    ///
    /// - Parameters:
    ///   - key: UserDefault key
    ///   - value: UserDefault value
    func saveObjectArray(for key: StorageKeys, value: [Codable]?) {

        if let value = value {

            let dataArray: [Data] = value.map { object -> Data? in
                return object.toJSONData()
                }.compactMap { $0 }

            print("\(#function) \(value)")
            UserDefaults.standard.set(dataArray, forKey: key.rawValue)
        }
    }

    /// Delete single key-value pair
    ///
    /// - Parameter key: UserDefault key
    func remove(for key: StorageKeys) {

        print("\(#function) \(key)")
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    /// Delete key-value pairs which key contain certain text
    ///
    /// - Parameter key: UserDefault key
    func removeAll(containsKey: String) {

        let dictionary: [String: Any] = UserDefaults.standard.dictionaryRepresentation()

        for (key, _) in dictionary where key.contains(containsKey) {

            print("\(#function) \(containsKey)")
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    /// Delete all key-value pairs
    func removeAll() {

        let dictionary: [String: Any] = UserDefaults.standard.dictionaryRepresentation()

        for (key, _) in dictionary {
            UserDefaults.standard.removeObject(forKey: key)
        }

        guard let id: String = Bundle.main.bundleIdentifier else {
            return
        }

        print("\(#function)")
        UserDefaults.standard.removePersistentDomain(forName: id)
    }
}


extension Encodable {

    func toJSONData() -> Data? {

        do {
            let data = try JSONEncoder().encode(self)
            return data

        } catch {
            print("Save \(self) failed")
        }
        return nil
    }
}

extension Data {

    func toObject<Ｔ: Decodable>() -> Ｔ? {
        do {
            let object = try JSONDecoder().decode(Ｔ.self, from: self)
            print("\(#function) \(object)")

            return object
        } catch {

            print("Decode \(self) failed")
            return nil
        }
    }
}
