//
//  UserDefaultsExtension.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 18.10.23.
//

import Foundation

//MARK: DEPRECATED

@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue

        if UserDefaults.standard.object(forKey: key) == nil {
            wrappedValue = defaultValue
        }
    }
    var wrappedValue: T {
        get {
            if let val = UserDefaults.standard.object(forKey: key) as? T {
                return val
            } else {
                UserDefaults.standard.set(defaultValue, forKey: key)
                return defaultValue
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
extension UserDefaults {
    @Persist(key: "defaultStock", defaultValue: [0,1,2,3,4,5])
    static var pages: [Int]
    
}
