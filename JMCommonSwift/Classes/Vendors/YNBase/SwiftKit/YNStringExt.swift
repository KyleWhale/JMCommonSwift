//
//  YNStringExt.swift
//  YNSwiftMacro
//
//  Created by james on 2021/4/21.
//

import UIKit
import Foundation

extension String {
    
    ///获取压缩图片的网址,并对网址添加中午支持
    ///
    /// - Parameters:
    ///   - width: 图片宽度
    ///   - height: 图片高度
    func yn_thumImageUrl(width: CGFloat, height: CGFloat) -> URL? {
        return URL.init(string: self.yn_thumImageUrlString(width: width, height: height))
    }
    
    func yn_thumImageUrlString(width: CGFloat, height: CGFloat) -> String {
        var thumImageUrl: String
        if min(width, height) > 0 {
            let scale = YN_SCREEN_WIDTH > 375 ? 4 : 3
            let width = Int(width) * scale
            let height = Int(height) * scale
            thumImageUrl = self + "?x-oss-process=image/resize,w_\(width),h_\(height)/quality,q_100"
        } else {
            thumImageUrl = self
        }
        thumImageUrl = thumImageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        return thumImageUrl
    }
    
    /// 获取富文本价格字符串
    ///
    /// - Parameters:
    ///   - price: 价格
    ///   - color: 颜色
    ///   - unitFont: 单位￥和小数部分的字体大小
    ///   - amountFont: 价格整数部分字体大小
    static func yn_attributePrice(price: Float, color: UIColor, unitFont: UIFont, amountFont: UIFont) -> NSAttributedString {
        let priceStr = NSString.init(format: "￥%.2f", price)
        let attributePriceStr = NSMutableAttributedString.init(string: priceStr as String, attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font :
            amountFont])
        //单位￥和小数点后面数字字体大小设置
        attributePriceStr.addAttributes([NSAttributedString.Key.font : unitFont], range: priceStr.range(of: "￥"))
        
        if let decimalStr = priceStr.components(separatedBy: ".").last {
            let decimalRange = NSRange.init(location: priceStr.range(of: ".").location + 1, length: decimalStr.yn_length)
            attributePriceStr.addAttributes([NSAttributedString.Key.font : unitFont], range: decimalRange)
        }
        return attributePriceStr
    }
    
}
