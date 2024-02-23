//
//  YNDictionaryExt.swift
//  YNSwiftMacro
//
//  Created by james on 2021/4/21.
//

import Foundation
extension Dictionary {
    
    /// 获取字典中的字典型value
    public func yn_dictionary(key: Key) -> YNDefaultDic {
        let value = self[key]
        switch value {
        case let value as YNDefaultDic:
            return value
        default:
            return [:]
        }
    }
    
    /// 获取字典中数组类型的value
    public func yn_arrayValue(key: Key) -> [YNDefaultDic] {
        let value = self[key]
        guard let arrry = value as? [YNDefaultDic] else {
            return []
        }
        return arrry
    }

    /// 获取字典中的字符串value
    public func stringValue(key: Key, defaultValue: String = "") -> String {
        
        let value = self[key]
        switch value {
        case let string as String:
            return string.yn_length > 0 ? string : defaultValue
        case let number as NSNumber:
            return number.stringValue
        default:
            return defaultValue
        }
    }
    
    /// 获取字典中的整形value
    public func intValue(key: Key, defaultValue: Int = 0) -> Int {
        
        let value = self[key]
        switch value {
        case let value as Int:
            return value
        case let value as String:
            return atol(value)
        case let value as NSNumber:
            return value.intValue
        default:
            return defaultValue
        }
    }
    
    /// 获取字典中的单精度浮点型value
    public func floatValue(key: Key, defaultVale: Float = 0.0) -> Float {
        let value = self[key]
        switch value {
        case let value as Float:
            return value
        case let value as NSNumber:
            return value.floatValue
        default:
            return defaultVale
        }
    }
    
    /// 获取字典中的双精度浮点型value
    public func doubleValue(key: Key, defaultVale: Double = 0.0) -> Double {
        let value = self[key]
        switch value {
        case let value as Double:
            return value
        case let value as String:
            return atof(value)
        case let value as NSNumber:
            return value.doubleValue
        default:
            return defaultVale
        }
    }
    
    /// 获取字典中的bool型value
    public func boolValue(key: Key, defaultValue: Bool = false) -> Bool {
        let value = self[key]
        switch value {
        case let value as Bool:
            return value
        case let value as NSNumber:
            return value.boolValue
        default:
            return defaultValue
        }
    }
}
