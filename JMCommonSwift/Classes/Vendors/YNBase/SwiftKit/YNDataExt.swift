//
//  YNDataExt.swift
//  YNSwiftMacro
//
//  Created by james on 2021/4/14.
//

import Foundation
import UIKit

public enum YNImageFormat: String {
    case jpg = ".jpg"
    case png = ".png"
    case gif = ".gif"
    case unknown = ""
}

extension Data{
        ///判断图片的 格式
        public var yn_imageFormat: YNImageFormat {
            var headerData = [UInt8](repeating: 0, count: 3)
            self.copyBytes(to: &headerData, from:(0..<3))
            let hexString = headerData.reduce("") { $0 + String(($1&0xFF), radix:16) }.uppercased()
            var imageFormat = YNImageFormat.unknown
            switch hexString {
            case "FFD8FF": imageFormat = .jpg
            case "89504E": imageFormat = .png
            case "474946": imageFormat = .gif
            default:break
            }
            return imageFormat
        }
}
extension Data{
    
    /// 同步压缩图片到指定文件大小
    ///
    /// - Parameters:
    ///   - rawData: 原始图片数据
    ///   - limitDataSize: 限制文件大小，单位字节
    /// - Returns: 处理后数据
    public static func compressImageData(_ rawData:Data, limitDataSize:Int) -> Data?{
        guard rawData.count > limitDataSize else {
            return rawData
        }
        
        var resultData = rawData
        
        // 若是 JPG，先用压缩系数压缩 6 次，二分法
        if resultData.yn_imageFormat == .jpg {
            var compression: Int = 1
            var maxCompression: Int = 1
            var minCompression: Int = 0
            for _ in 0..<6 {
                compression = Int((maxCompression + minCompression) / 2)
                if let data = compressImageData(resultData, limitDataSize: compression){
                    resultData = data
                } else {
                    return nil
                }
                if resultData.count < Int(Double(limitDataSize) * 0.9) {
                    minCompression = compression
                } else if resultData.count > limitDataSize {
                    maxCompression = compression
                } else {
                    break
                }
            }
            if resultData.count <= limitDataSize {
                return resultData
            }
        }
        
        // 若是 GIF，先用抽帧减少大小
        if resultData.yn_imageFormat == .gif {
            let sampleCount = resultData.yn_fitSampleCount
            if let data = compressImageData(resultData, limitDataSize: sampleCount){
                resultData = data
            } else {
                return nil
            }
            if resultData.count <= limitDataSize {
                return resultData
            }
        }
        
        var longSideWidth = Swift.max(resultData.yn_imageSize.height, resultData.yn_imageSize.width)
        // 图片尺寸按比率缩小，比率按字节比例逼近
        while resultData.count > limitDataSize{
            let ratio = sqrt(Double(limitDataSize) / Double(resultData.count))
            longSideWidth *= CGFloat(ratio)
            if let data = compressImageData(resultData, limitDataSize: Int(longSideWidth)) {
                resultData = data
            } else {
                return nil
            }
        }
        return resultData
    }
}
extension Data{
    
    var yn_fitSampleCount:Int{
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, [kCGImageSourceShouldCache: false] as CFDictionary) else {
            return 1
        }

        let frameCount = CGImageSourceGetCount(imageSource)
        var sampleCount = 1
        switch frameCount {
        case 2..<8:
            sampleCount = 2
        case 8..<20:
            sampleCount = 3
        case 20..<30:
            sampleCount = 4
        case 30..<40:
            sampleCount = 5
        case 40..<Int.max:
            sampleCount = 6
        default:break
        }
        
        return sampleCount
    }
    
    var yn_imageSize:CGSize{
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any],
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat,
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat else {
                return .zero
        }
        return CGSize(width: imageWidth, height: imageHeight)
    }
}
