//
//  YNUDConfig.swift
//  YNBase
//
//  Created by guo hongquan on 2021/6/17.
//

import Foundation

public let UD_EnvConfig = "envconfig"

@propertyWrapper
public struct UDWrapper<T> {
    let key: String
    let defaultValue: T
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
