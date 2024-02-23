//
//  HTImageHelper.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import UIKit

public class HTImageHelper: NSObject {
    
    public static var imagePrefix: String = ""
    
    public static func imageWithCount(_ count: Int) -> URL? {
        return URL(string: "\(imagePrefix)\(count)@3x.png")
    }
    
    public static func imageWithName(_ name: String) -> UIImage? {
        
       var bundle: Bundle?
       if let url = Bundle.main.url(forResource: "JMSwiftCommon.xcassets", withExtension: nil) {
           
           bundle = Bundle(url: url)
       }else {
           
           bundle = HTImageHelper.frameworkBundle("JMSwiftCommon")
       }
       
       let image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
        
        return image
    }
    
    public class func frameworkBundle(_ name: String) -> Bundle? {
        var frameworksUrl = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
        frameworksUrl = frameworksUrl?.appendingPathComponent(name)
        frameworksUrl = frameworksUrl?.appendingPathExtension("framework")
        
        guard let frameworkBundleUrl = frameworksUrl else {
            return nil
        }
        
        let bundle = Bundle(url: frameworkBundleUrl)
        frameworksUrl = bundle?.url(forResource: name, withExtension: "bundle")
        
        guard let bundleUrl = frameworksUrl else {
            return nil
        }
        
        return Bundle(url: bundleUrl)
    }
}
