//
//  YNUnicode.swift
//  YNBase
//
//  Created by james on 2021/5/28.
//

import Foundation
import UIKit

extension Array{

    public var unicodeDescription : String {
        
        return self.description.stringByReplaceUnicode
    }
}

extension Dictionary {

    public var unicodeDescription : String{
    
        return self.description.stringByReplaceUnicode
    }
}

extension String {
    
    public var unicodeDescription : String{
    
        return self.stringByReplaceUnicode
    }
    
    var stringByReplaceUnicode : String{

        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        
        var returnStr:String = ""
        if let tempData = tempStr3.data(using: String.Encoding.utf8) {
            do {
                returnStr = try PropertyListSerialization.propertyList(from: tempData, options: [.mutableContainers], format: nil) as? String ?? ""
            } catch {
                print(error)
            }
        }
        
        return returnStr.replacingOccurrences(of: "\\n", with: "\n")
    }
}
