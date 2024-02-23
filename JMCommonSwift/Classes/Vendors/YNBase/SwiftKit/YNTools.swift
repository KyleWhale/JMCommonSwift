//
//  YNTools.swift
//  YNCustomer
//
//  Created by james on 2021/5/6.
//


import UIKit
import Foundation
import MediaPlayer
import CommonCrypto
import Photos

extension Int{
//    public var fit : Double{
//        return Double(self) * Double(YNMacro.scale)
//    }
    /// 设计图尺寸 360
    public var fit : Double{
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            return Double(self) * Double(YN_SCREENMIN / 460.0)
        }
        
        return Double(self) * Double(YN_SCREENMIN / 360.0)
    }
    public var cgfloat: Double {
        return Double(self)
    }
    
//    var cgfloat: CGFloat {
//        return CGFloat(self)
//    }
}

extension CGFloat{
    public var fit : CGFloat{
        return self * CGFloat(YNMacro.scale)
    }
}

public extension Float{
    var fit : Float{
        return self * Float(YNMacro.scale)
    }
    var cgfloat: CGFloat {
        return CGFloat(self)
    }
    
    /// 保留小数位数 转字符串
    func string(by bits: Int) -> String {
        return String(format: "%.\(bits)f", self)
    }
    
    
}

public extension Double{
    var fit : Double{
        return self * Double(YNMacro.scale)
    }
    var cgfloat: CGFloat {
        return CGFloat(self)
    }
    
    /// 保留小数位数 转字符串
    func string(by bits: Int) -> String {
        return String(format: "%.\(bits)f", self)
    }
    
    /// 保留小数位，四舍五入
    func doubled(by bits: Int) -> Double {
        let f = pow(10.0, Double(bits))
        return (self * f).rounded() / f
    }
    
}

extension CGRect{
    ///UI布局创建
    static public func yn_adapt(_ scaleX: Int,_ scaleY: Int,_ scaleW: Int,_ scaleH: Int) -> CGRect{
        return CGRect(x: scaleX.fit, y: scaleY.fit, width: scaleW.fit, height: scaleH.fit)
    }
    
}

public extension String {
    
    /// 获取字符串长度
    var yn_length: Int {
        return self.count
    }
    
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    ///过滤空格
    var yn_noSpaceString: String{
        let s = self as NSString
        return s.replacingOccurrences(of:" ", with: "") as String
    }
    
    ///手机号加密显示
    func yn_safeMdn() -> String{
        var resultMdn:String = ""
        if !self.isEmpty {
            let phoneStr:NSMutableString = NSMutableString(string: self)
            let tempRange:NSRange = NSMakeRange(3, 4)
            phoneStr.replaceCharacters(in: tempRange, with: "****")
            resultMdn = "\(phoneStr)"
        }else {
            resultMdn = ""
        }
        return resultMdn
    }
    
    ///获取字符串不为空的值
    func yn_value() -> String {
        if self.isEmpty {
            return ""
        }else {
            return self
        }
    }
    
    var yn_IsMobile: Bool {
        let mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", mobile)
        return predicate.evaluate(with: self)
    }
    
    ///是否包含中文
    func yn_isIncludeChinese() -> Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    func yn_contains(substr: String) -> Bool {
        return self.range(of: substr) != nil
    }
    
    func yn_componentsSeparated(_ componentsSeparat:String) -> [String:Any]{
        
        let a = components(separatedBy: componentsSeparat)
        var dict = [String:Any]()
        for s in a {
            
            let str = s.yn_urlDecoded() as NSString
            
            if str.contains("="){
                let range = str.range(of: "=")
                let key = str.substring(to: range.location)
                let value = str.substring(from: range.location+1)
                dict[key] = value
            }
        }
        return dict
    }
    
    func yn_attributeString() -> NSAttributedString {
        return NSAttributedString.init(string: self)
    }
    
    /// 获取富文本字符串
    func yn_attributeString(color: UIColor, font: UIFont) -> NSAttributedString {
        let attributesDic = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        return NSAttributedString.init(string: self, attributes: attributesDic)
    }
    
    ///文本添加行间距
    func yn_add(lineSpacing:CGFloat, withFontSize fontSize:CGFloat) -> NSAttributedString{
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),
                          NSAttributedString.Key.paragraphStyle : paraph]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// 计算文本高度
    func yn_textHeight(font: UIFont, maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: maxWidth, height: 0))
        lable.font = font
        lable.text = self
        lable.numberOfLines = 0
        return lable.sizeThatFits(CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    /// - 设置文字颜色
    func yn_attributeString(_ foregroundColor: UIColor, location: Int, length: Int) -> NSMutableAttributedString {
        let mutableAttributeString = NSMutableAttributedString.init(string: self)
        mutableAttributeString.addAttributes([NSAttributedString.Key.foregroundColor: foregroundColor], range: NSMakeRange(location, length))
        return mutableAttributeString
    }
    
    /// - 设置文字样式
    func yn_attributeString(_ font: UIFont, location: Int, length: Int) -> NSMutableAttributedString {
        let mutableAttributeString = NSMutableAttributedString.init(string: self)
        mutableAttributeString.addAttributes([NSAttributedString.Key.font: font], range: NSMakeRange(location, length))
        return mutableAttributeString
    }
    
    /// 计算文本宽度
    func yn_textWidth(font: UIFont) -> CGFloat {
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 0))
        lable.font = font
        lable.text = self
        lable.numberOfLines = 0
        return lable.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
    }
    
    var yn_jsonDictionary: Any?{
        
        let jsonData:Data = self.data(using: .utf8) ?? Data()
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict
        }
        YNLog("字符串josn解析失败")
        return nil
    }
    //根据开始位置和长度截取字符串
    func yn_subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    /// 判断是否为整数
    func yn_isPurnInt() -> Bool {
        
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    /// 字符串转时间戳
    func yn_toTimeInterval(formatter: String) -> TimeInterval? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        let date = dateFormatter.date(from: self)
        let timeInterval = date?.timeIntervalSince1970
        return timeInterval
    }
}
public extension String {
    
    //将原始的url编码为合法的url
    func yn_urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                                                            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func yn_urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    //md5加密
    func yn_md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        if let str = str {
            CC_MD5(str, strLen, result)
        }
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    //Range NSRange 转换
    func yn_toNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    func yn_toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    /// 替换字符
    func yn_replaceCharacter(origin : String ,replace : String) -> String {
        return    replace.replacingOccurrences(of: origin, with: replace, options: .forcedOrdering, range:replace.yn_toRange(NSRange(location: origin.yn_length, length: replace.count)))
    }
}

// MARK: - 类似GCD 的延时执行
extension DispatchTime: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
    
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
    
}

// MARK: - UI控件扩展
extension UILabel {
    
    convenience init(_ font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = UIColor.black, text: String = "", textAlignment: NSTextAlignment = .left, superView: UIView?) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.text = text
        self.textAlignment = textAlignment
        if let superView = superview {
            superView.addSubview(self)
        }
    }
    
    public func yn_set(attriText:String?,lineSpacing:CGFloat = 2) {
        
        guard let text = attriText  else { return  }
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font:font ?? UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle : paraph] as [NSAttributedString.Key : Any]
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    enum YNGetSizeType: Int {
        case text = 0
        case attributeString
    }
    
    /// 获取label的高度
    func yn_getHeight(type: YNGetSizeType? = nil, width: CGFloat? = nil) -> CGFloat {
        var w: CGFloat = width ?? -1
        var h: CGFloat = CGFloat.greatestFiniteMagnitude
        if w <= 0 {
            if frame.width == 0 {
                layoutIfNeeded()
            }
            guard frame.width != 0 else {
                //                print("🌶🌶🌶： 计算label的height失败，因为其width为0")
                return 0
            }
            w = frame.width
        }
        
        if let attributedText = attributedText, let type = type, type == .attributeString{
            
            h = attributedText.yn_getSize(width: w, height: h).height
        }else if let text = text {
            
            h = text.yn_getHeight(font: font, width: w)
        }else {
            print("label没有text，或者attribute")
        }
        return h
    }
    
    
    /// 获取label的width
    func yn_getWidth(type: YNGetSizeType? = nil, height: CGFloat? = nil) -> CGFloat {
        
        var w: CGFloat = CGFloat.greatestFiniteMagnitude
        var h: CGFloat = height ?? -1
        if h <= 0 {
            if frame.width == 0 {
                layoutIfNeeded()
            }
            guard frame.height != 0 else {
                print("🌶🌶🌶： 计算label的width失败，因为其height为0")
                return 0
            }
            h = frame.height
        }
        
        if let attributedText = attributedText, let type = type, type == .attributeString{
            
            w = attributedText.yn_getSize(width: w, height: h).width
        }else if let text = text {
            
            w = text.yn_getWidth(font: font, height: h)
        }else {
            print("label没有text，或者attribute")
        }
        return w + 1
    }
    
    
    /// 限制最大汉字数
    func yn_getLabelWidth(type: YNGetSizeType? = nil, height: CGFloat? = nil, maxCount: Int64) -> CGFloat {
        
        var str = "哈"
        for _ in 0 ..< maxCount {
            str += "哈"
        }
        
        let text = self.text
        let attributedText = self.attributedText
        let textW = yn_getWidth(type: type, height: height)
        
        self.text = str
        let strW = yn_getWidth(height: height)
        
        self.text = text
        self.attributedText = attributedText
        return strW < textW ? strW : textW
    }
}
// MARK: - get NSAttributedString height
extension NSAttributedString {
    
    /// 根据给定的范围计算宽高，如果计算宽度，则请把宽度设置为最大，计算高度则设置高度为最大
    func yn_getSize(width: CGFloat,height: CGFloat) -> CGSize {
        let attributed = self
        _ = CTFramesetterCreateWithAttributedString(attributed)
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        let framesetter = CTFramesetterCreateWithAttributedString(attributed)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange.init(location: 0, length: attributed.length), nil, rect.size, nil)
        return CGSize.init(width: size.width + 1, height: size.height + 1)
    }
    
}
// MARK: - get String height
extension String {
    func yn_getHeight(font:UIFont,width:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        
        //        let dic = [NSAttributedStringKey.font:font] // swift 4.0
        let dic = [NSAttributedString.Key.font:font] // swift 3.0
        
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        
        return ceil(strSize.height) + 1
    }
    ///获取字符串的宽度
    func yn_getWidth(font:UIFont,height:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        
        //        let dic = [NSAttributedStringKey.font:font] // swift 4.0
        let dic = [NSAttributedString.Key.font:font] // swift 3.0
        
        if let cString = self.cString(using: String.Encoding.utf8) {
            let str = String.init(cString: cString, encoding: String.Encoding.utf8)
            let strSize = str?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
            return strSize?.width ?? 0
        }
        return 0
        
    }
}
// MARK: - UIImageView控件扩展
extension UIImageView{
    
    //添加自旋转动画
    func yn_addRotateAni(_ duration:Float = 4) {
        
        if self.layer.animation(forKey: "transform.rotation.z") == nil{
            let rotationAnimation:CABasicAnimation = CABasicAnimation.init()
            rotationAnimation.toValue = NSNumber.init(value: (2 * Double.pi))
            rotationAnimation.duration = CFTimeInterval(duration)
            rotationAnimation.repeatCount = MAXFLOAT
            rotationAnimation.isRemovedOnCompletion = false
            self.layer.add(rotationAnimation, forKey: "transform.rotation.z")
        }
        
    }
    
}
// MARK: - UIButton控件扩展
public extension UIButton {
    
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     便利构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
    convenience init (imageName : String, bgImageName : String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor, fontSize : CGFloat, title : String) {
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    convenience init(titleFont: UIFont = UIFont.systemFont(ofSize: 14), normalTitleColor: UIColor = UIColor.black, normalTitle: String = "", target: Any?, action: Selector, superView: UIView?) {
        self.init(type: .custom)
        self.titleLabel?.font = titleFont
        self.setTitleColor(normalTitleColor, for: .normal)
        self.setTitle(normalTitle, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
        if let superView = superView {
            superView.addSubview(self)
        }
    }
    
    convenience init(normalImage: UIImage, target: Any?, action: Selector, superView: UIView?) {
        self.init(type: .custom)
        self.setImage(normalImage, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
        if let superView = superView {
            superView.addSubview(self)
        }
    }
    
    /**
     UIButton图像文字同时存在时---图像相对于文字的位置
     
     - top:    图像在上
     - left:   图像在左
     - right:  图像在右
     - bottom: 图像在下
     */
    enum YNButtonImageEdgeInsetsStyle {
        case top, left, right, bottom
    }
    
    func yn_fixImagePosition(at style: YNButtonImageEdgeInsetsStyle, space: CGFloat) {
        guard let imageV = imageView else { return }
        guard let titleL = titleLabel else { return }
        //获取图像的宽和高
        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height
        //获取文字的宽和高
        let labelWidth  = titleL.intrinsicContentSize.width
        let labelHeight = titleL.intrinsicContentSize.height
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //UIButton同时有图像和文字的正常状态---左图像右文字，间距为0
        switch style {
        case .left:
            //正常状态--只不过加了个间距
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space * 0.5, bottom: 0, right: space * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space * 0.5, bottom: 0, right: -space * 0.5)
        case .right:
            //切换位置--左文字右图像
            //图像：UIEdgeInsets的left是相对于UIButton的左边移动了labelWidth + space * 0.5，right相对于label的左边移动了-labelWidth - space * 0.5
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space * 0.5, bottom: 0, right: -labelWidth - space * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space * 0.5, bottom: 0, right: imageWidth + space * 0.5)
        case .top:
            //切换位置--上图像下文字
            /**图像的中心位置向右移动了labelWidth * 0.5，向上移动了-imageHeight * 0.5 - space * 0.5
             *文字的中心位置向左移动了imageWidth * 0.5，向下移动了labelHeight*0.5+space*0.5
             */
            imageEdgeInsets = UIEdgeInsets(top: -imageHeight * 0.5 - space * 0.5, left: labelWidth * 0.5, bottom: imageHeight * 0.5 + space * 0.5, right: -labelWidth * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: labelHeight * 0.5 + space * 0.5, left: -imageWidth * 0.5, bottom: -labelHeight * 0.5 - space * 0.5, right: imageWidth * 0.5)
        case .bottom:
            //切换位置--下图像上文字
            /**图像的中心位置向右移动了labelWidth * 0.5，向下移动了imageHeight * 0.5 + space * 0.5
             *文字的中心位置向左移动了imageWidth * 0.5，向上移动了labelHeight*0.5+space*0.5
             */
            imageEdgeInsets = UIEdgeInsets(top: imageHeight * 0.5 + space * 0.5, left: labelWidth * 0.5, bottom: -imageHeight * 0.5 - space * 0.5, right: -labelWidth * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: -labelHeight * 0.5 - space * 0.5, left: -imageWidth * 0.5, bottom: labelHeight * 0.5 + space * 0.5, right: imageWidth * 0.5)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
    
    static var yn_topNameKey : Character!
    static var yn_leftNameKey : Character!
    static var yn_bottomNameKey : Character!
    static var yn_rightNameKey : Character!
    
    
    /// 扩大按钮的点击区域
    /// - Parameters:
    ///   - top: 上部距离
    ///   - left: 左边距离
    ///   - bottom: 下边部距离
    ///   - right: 右边距离
    func yn_enlargeTouchSize(top : CGFloat, left : CGFloat, bottom : CGFloat, right : CGFloat){
        objc_setAssociatedObject(self, &UIButton.yn_topNameKey, NSNumber.init(value: Float(top)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &UIButton.yn_leftNameKey, NSNumber.init(value: Float(left)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &UIButton.yn_bottomNameKey, NSNumber.init(value: Float(bottom)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &UIButton.yn_rightNameKey, NSNumber.init(value: Float(right)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    private func yn_expandRect() -> CGRect {
        let topEdege = NSNumber.init(value: objc_getAssociatedObject(self, &UIButton.yn_topNameKey) as? Float ?? 0)
        let leftEdge = NSNumber.init(value: objc_getAssociatedObject(self, &UIButton.yn_leftNameKey) as? Float ?? 0)
        let bottomEdge = NSNumber.init(value: objc_getAssociatedObject(self, &UIButton.yn_bottomNameKey) as? Float ?? 0)
        let rightEdge = NSNumber.init(value: objc_getAssociatedObject(self, &UIButton.yn_rightNameKey) as? Float ?? 0)
        
        if topEdege.floatValue != 0 || leftEdge.floatValue != 0 || bottomEdge.floatValue != 0 || rightEdge.floatValue != 0 {
            return CGRect.init(x: self.bounds.origin.x - CGFloat.init(truncating: leftEdge),
                               y: self.bounds.origin.y - CGFloat.init(truncating: topEdege),
                               width: self.bounds.size.width + CGFloat.init(truncating: leftEdge) + CGFloat.init(truncating: rightEdge),
                               height: self.bounds.size.height + CGFloat.init(truncating: topEdege) + CGFloat.init(truncating: bottomEdge))
        }else{
            return self.bounds
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = self.yn_expandRect()
        if buttonRect.equalTo(self.bounds){
            return super.point(inside: point, with: event)
        }
        return buttonRect.contains(point)
    }
}
// MARK: - UIImage控件扩展
extension UIImage {
    
    ///始终保持图片原有的状态，不使用Tint Color渲染
    public func yn_noRenderingImageName(_ imageName:String) -> UIImage {
        let path:String?  = YNBundle.path(forResource: imageName, ofType: "png") ?? ""
        
        guard let u = path, !u.isEmpty else {
            return UIImage()
        }
        let image : UIImage = ((UIImage(named:imageName )?.withRenderingMode(.alwaysOriginal))) ?? UIImage()
        /**
         UIImageRenderingModeAutomatic  自动根据当前环境渲染
         UIImageRenderingModeAlwaysOriginal  使用原有的图片状态，不被Tint Color所渲染
         UIImageRenderingModeAlwaysTemplate  渲染图片
         */
        return image
    }
    
    ///获取纯色图片
    public func yn_createImage(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        return yn_createImage(color, rect)
    }
    
    // 根据颜色绘制图片
    public func yn_createImage(_ color: UIColor, _ rect : CGRect)-> UIImage{
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    ///修正图片方向
    public func yn_fixedOrientation() -> UIImage {
        
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi/2)
            break
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError()
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError()
        }
        if let cgImage = self.cgImage,let colorSpace = cgImage.colorSpace,let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            
            
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                break
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                break
            }
            guard let image: CGImage = ctx.makeImage() else { return UIImage() }
            
            return UIImage(cgImage: image)
        }else {
            return UIImage()
        }
    }
    
    ///保存到相册
    public func yn_saveToAlbum(){
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] (granted) in
                DispatchQueue.main.async {
                    if (granted) {
                        self?.yn_saveAlbum()
                    }else{
                        YNKeyWindow()?.yn_showToast("没有相册的存储权限")
                    }
                }
            })
        case .authorized: // 开启授权
            DispatchQueue.main.async {
                self.yn_saveAlbum()
            }
            break
        default:
            DispatchQueue.main.async {
                YNKeyWindow()?.yn_showToast("There is no storage permission for albums")
            }
            return
        }
    }
    
    private func yn_saveAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        }) {(isSuccess: Bool, error: Error?) in
            if isSuccess {
                DispatchQueue.main.async {
                    YNKeyWindow()?.yn_showToast("Save successfully")
                }
            } else{
                DispatchQueue.main.async {
                    if let error = error as NSError?,error.code == 2047 {
                        YNKeyWindow()?.yn_showToast("There is no storage permission for albums")
                    }
                }
            }
        }
        
    }
}

// MARK: - UITextField控件扩展
extension UITextField {
    
    convenience init(_ font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = UIColor.black, textAlignment: NSTextAlignment = .left, clearButtonMode: UITextField.ViewMode = .whileEditing, placeholder: String = "", superView: UIView?) {
        
        self.init()
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.clearButtonMode = clearButtonMode
        self.placeholder = placeholder
        if superView != nil {
            superView?.addSubview(self)
        }
    }
    
    /// 为textfield添加键盘上部完成按钮
    func yn_addDoneButtonForKeyboard() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: YN_SCREEN_WIDTH, height: 44))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(shouldEndEditing))
        bar.items = [spaceItem,item]
        inputAccessoryView = bar
    }
    
    @objc private func shouldEndEditing() {
        endEditing(true)
    }
    
    ///Placeholder居中显示
    public func yn_centerPlaceHolder(){
        if let placeholderLabel = self.value(forKey: "_placeholderLabel") as? UILabel {
            placeholderLabel.textAlignment = NSTextAlignment.center
            placeholderLabel.textColor = YNHexColor(0xFF5e63a6)
        }
    }
    
    ///字数限制
    public func yn_setLimitBy(_ limit:NSInteger,_ string:String) {
        if string.yn_isIncludeChinese() {
            YNLog("不能输入汉字，谢谢")
        }else if (string.count > limit)
        {
            let range: Range<String.Index> = string.startIndex..<string.index(string.startIndex, offsetBy: limit-1)
            let firstLetterRange: Range = string.rangeOfComposedCharacterSequences(for: range)
            self.text = string.substring(with: firstLetterRange)
        }
    }
    
    ///iOS13.0 deprecated 之后，此方法废弃，会引起崩溃，慎用！
    @available(*, deprecated, message: "iOS13.0 之后，此方法废弃，会引起崩溃，慎用！")
    public var yn_placeholdeColor : UIColor {
        get{
            return .white
        }
        set{
            setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    
    ///左内边距
    public  var yn_leftPadding : Int {
        get{
            return 0
        }
        set{
            let v = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: Int(yn_height)))
            v.backgroundColor = .clear
            self.leftView = v
            self.leftViewMode = .always
        }
    }
}

//MARK:UIBarButtonItem-扩展
extension UIBarButtonItem {
    
    convenience init(imageName : String) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.init(customView : btn)
    }
}

//MARK:UIColor-扩展
public extension UIColor {
    
    ///返回随机颜色
    class var yn_random:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    /// 返回纯色图片
    func yn_image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(rect)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
            UIGraphicsEndImageContext()
            return image
        }else {
            return UIImage()
        }
        
    }
}
//MARK: Date-扩展
public extension Date {
    func yn_toString(_ format:String) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format.isEmpty ? "yyyy-MM" : format
        return dateFormatter.string(from: self as Date)
    }
    
    static func yn_DayStr(_ timeInterval:TimeInterval) -> String {
        return Date.yn_toTimeStr(timeInterval, "yyyy-MM-dd")
    }
    
    //时间戳转成字符串
    static func yn_toTimeStr(_ timeInterval:TimeInterval,_ dateFormat:String?) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval/1000)
        //        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    
}

public extension Date {
    var yn_age: Int {
        return NSCalendar.current.dateComponents([.year,.month], from: self, to: Date()).year ?? 0
    }
}

public extension NSDate {
    class func createDateString(time timestamp : TimeInterval) -> String {
        let timeStr = Date.yn_toTimeStr(timestamp, nil)
        return self.createDateString(createAtStr: timeStr)
    }
    
    class func createDateString(time timestamp : TimeInterval,format:String) -> String {
        let timeStr = Date.yn_toTimeStr(timestamp,format.isEmpty ? nil : format)
        return timeStr
    }
    
    class func createDateString(createAtStr : String) -> String {
        // 1.创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale
        
        // 2.将字符串时间,转成NSDate类型
        guard let createDate = fmt.date(from: createAtStr) else {
            return ""
        }
        
        // 3.创建当前时间
        let nowDate = Date()
        
        // 4.计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 5.对时间间隔处理
        // 5.1.显示刚刚
        if interval < 60 {
            return "刚刚"
        }
        
        // 5.2.59分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 5.3.11小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        // 5.4.创建日历对象
        let calendar = NSCalendar.current
        
        // 5.5.处理昨天数据: 昨天 12:23
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        // 5.6.处理一年之内: 02-22 12:22
        let targetYear = calendar.component(.year, from: createDate)//calendar.components(.Year, fromDate: createDate, toDate: nowDate, options: [])
        let currYear = calendar.component(.year, from: nowDate)
        if abs(targetYear-currYear) < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        // 5.7.超过一年: 2014-02-12 13:22
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}

//MARK:TimeInterval-扩展
public extension TimeInterval {
    
    func yn_toStr(_ formatter: String?) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter ?? "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date as Date)
    }
    
    func yn_format(by bit: Int) -> TimeInterval {
        let count = "\(Int(self))".count
        if count == bit {
            return self
        } else {
            if count > bit {
                return TimeInterval(Int(self) / Int(pow(10, Double(count - bit))))
            } else {
                return TimeInterval(Int(self) * Int(pow(10, Double(bit - count))))
            }
        }
    }
    
    func yn_format10bit() -> TimeInterval {
        return yn_format(by: 10)
    }
    
    func yn_format13bit() -> TimeInterval {
        return yn_format(by: 13)
    }
    
}


//MARK:UIViewController-扩展
extension UIViewController {
    
    public func yn_hidenNavBar(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.setValue(0, forKeyPath: "backgroundView.alpha")
    }
    
    public func yn_showNavBar(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setValue(1, forKeyPath: "backgroundView.alpha")
    }
    
    public func yn_hidenTabBar() {
        let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController
        //        tabBarController.tabBar.isHidden = true
        if let tabBarController = tabBarController {
            let frame = tabBarController.tabBar.frame
            let height = frame.size.height
            UIView.animate(withDuration: 0.35, animations: {
                tabBarController.tabBar.frame = (frame.offsetBy(dx: 0, dy: height))
            }) { (finished) in
                tabBarController.tabBar.isHidden = true
            }
        }
        
    }
    
    public func yn_showTabBar() {
        
        if let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
            tabBarController.tabBar.isHidden = false
            let frame = tabBarController.tabBar.frame
            UIView.animate(withDuration: 0.35, animations: {
                tabBarController.tabBar.frame = (frame.offsetBy(dx: 0, dy: 0))
            }){ (finished) in
                
            }
        }
    }
    
    @objc public func yn_back() {
        if let navigationController = navigationController, navigationController.viewControllers.first != self {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc public func yn_dissmissToRoot() {
        //获取根VC
        var  rootVC =  self .presentingViewController
        while  let  parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated:  true , completion:  nil )
        // self .view.window?.rootViewController?.dismiss(animated:  true , completion:  nil )
    }
    
    func yn_addChildViewController(_ childVC: UIViewController, toView: UIView) {
        childVC.beginAppearanceTransition(true, animated: false)
        toView.addSubview(childVC.view)
        childVC.endAppearanceTransition()
        childVC.didMove(toParent: self)
    }
    
    // MARK: 字典转字符串
    func yn_dicValueString(_ dic: Any) -> String?{
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else { return "" }
        let str = String(data: data, encoding: String.Encoding.utf8)
        return str
    }
    
    // MARK: 字符串转字典
    func yn_infoFromJson(_ str: String) -> YNDefaultDic?{
        guard !str.isEmpty,
              let data = str.data(using: String.Encoding.utf8) else {
            return YNDefaultDic()
        }
        if let array = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [YNDefaultDic] {
            return array.first
        }
        return nil
    }
}

extension UIDevice{
    
    func yn_blankof<T>(type:T.Type) -> T {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let val = ptr.pointee
        ptr.deinitialize(count: 1)
        return val
    }
    
    /// 磁盘总大小
    var yn_totalDiskSize:Int64{
        var fs = yn_blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_blocks)
        }
        return -1
    }
    
    /// 磁盘可用大小
    var yn_availableDiskSize:Int64{
        var fs = yn_blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
        }
        return -1
    }
    
    /// 将大小转换成字符串用以显示
    func yn_fileSizeToString(fileSize:Int64) -> String{
        
        let fileSize1 = CGFloat(fileSize)
        
        let KB:CGFloat = 1024
        let MB:CGFloat = KB*KB
        let GB:CGFloat = MB*KB
        
        return String(format: "%.1f GB", CGFloat(fileSize1)/GB)
        
        //        if fileSize < 10
        //        {
        //            return "0 B"
        //        }else if fileSize1 < KB
        //        {
        //            return "< 1 KB"
        //        }else if fileSize1 < MB
        //        {
        //            return String(format: "%.1f KB", CGFloat(fileSize1)/KB)
        //        }else if fileSize1 < GB
        //        {
        //            return String(format: "%.1f MB", CGFloat(fileSize1)/MB)
        //        }else
        //        {
        //            return String(format: "%.1f GB", CGFloat(fileSize1)/GB)
        //        }
    }
}

/// swift 延时进行封装 使用方法 delay(time){// DOSOMETHING}
extension NSObject {
    
    // MARK:返回className
    public var yn_className:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
            
        }
    }
    
    /*
     使用例子 全局队列
     delay(by: 5, qosClass: .userInitiated) {
     print("时间2：", Date())
     }
     */
    public func yn_delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                         _ closure: @escaping () -> Void) {
        
       
        if let qosClass = qosClass {
            let dispatchQueue = DispatchQueue.global(qos: qosClass)
            dispatchQueue.asyncAfter(
                deadline: DispatchTime.now() + delayTime, execute: closure
            )
        }else {
            let dispatchQueue = DispatchQueue.main
            dispatchQueue.asyncAfter(
                deadline: DispatchTime.now() + delayTime, execute: closure
            )
        }
    }
    
    ///[使用运行时]获取当前类所有的属性数组
    public func yn_propertyList() -> [String] {
        var properties:[String] = [String]()
        var count :UInt32 = 0
        //获取‘类’的属性列表
        let list = class_copyPropertyList(self.classForCoder, &count)
        print("属性的数量\(count)")
        for i in 0..<Int(count) {
            //根据下标 获取属性
            if let a = list?[i] {
                //获取属性的名称
                let cName = property_getName(a)
                let n:String = String(utf8String:cName) ?? ""
                properties.append(n)
                print("\(n)\n")
            }
            
        }
        return properties;
    }
    
}
// MARK: - Array-扩展
extension Array{
    
    public var yn_jsonString: String{
        
        if (!JSONSerialization.isValidJSONObject(self)) {
            YNLog("无法解析出JSONString")
            return ""
        }
        let data : Data = try! JSONSerialization.data(withJSONObject: self, options: [])
        guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else { return "" }
        return jsonString
    }
    
}
// MARK: - Dictionary-扩展
extension Dictionary {
    
    ///字典转json字符串
    public var yn_jsonString: String{
        if (!JSONSerialization.isValidJSONObject(self)) {
            return ""
        }
        let data : Data = try! JSONSerialization.data(withJSONObject: self, options: [])
        guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else { return "" }
        return jsonString
    }
    
    /// 获取字典中的字符串value
    func yn_stringValue(key: Key, defaultValue: String = "") -> String {
        
        let value = self[key]
        switch value {
        case let string as String:
            return string.count > 0 ? string : defaultValue
        case let number as NSNumber:
            return number.stringValue
        default:
            return defaultValue
        }
    }
    
    /// 获取字典中的整形value
    func yn_intValue(key: Key, defaultValue: Int = 0) -> Int {
        
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
    func yn_floatValue(key: Key, defaultVale: Float = 0.0) -> Float {
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
    func yn_doubleValue(key: Key, defaultVale: Double = 0.0) -> Double {
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
    func yn_boolValue(key: Key, defaultValue: Bool = false) -> Bool {
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
//MARK: UIView扩展-frame
extension UIView {
    
    /// X
    public var yn_left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    /// Y
    public var yn_top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    /// 右边界的X值
    public var yn_right: CGFloat{
        get{
            return self.yn_left + self.yn_width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    
    /// 下边界的Y值
    public var yn_bottom: CGFloat{
        get{
            return self.yn_top + self.yn_height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    /// centerX
    public var yn_centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    /// centerY
    public var yn_centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    /// width
    public var yn_width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    /// height
    public var yn_height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    /// origin
    public var yn_origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.yn_left = newValue.x
            self.yn_top = newValue.y
        }
    }
    
    /// size
    public var yn_size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.yn_width = newValue.width
            self.yn_height = newValue.height
        }
    }
    
}
//MARK:UIView圆角属性
public extension UIView {
    
    var yn_cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func yn_roundCorner () {
        self.layer.cornerRadius = self.yn_height/2;
        self.layer.masksToBounds = true
    }
    
    func yn_addBorder(_ bColor:UIColor, _ bWidth:CGFloat) {
        self.layer.borderColor = bColor.cgColor
        self.layer.borderWidth = bWidth
    }
    
    func yn_addShadow(_ bgColor:UIColor, _ shadowColor:UIColor) {
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
    
    func yn_addShadow(shadowRadius: CGFloat, shadowOffset: CGSize, shadowColor: UIColor) {
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
    
}
//MARK:BlurView
public extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var ynBlurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
            ) as? BlurView {
                return blurView
            }
            self.ynBlurView = BlurView(to: self)
            return self.ynBlurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                      !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        public func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        public func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}

@objc protocol YNNotiProtocol : NSObjectProtocol {
    @objc func loginCompleted()
    @objc func paySuccess()
}

class YNNotification: NSObject {
    
    struct Name {}
    
    static func postLoginNoti(){
        self.post(name: YNNotification.Name.LoginCompleted, object: nil)
    }
    
    static func postPaySuccessNoti(){
        self.post(name: YNNotification.Name.ThirdPaySuccess, object: nil)
    }
    
    static func postHistoryChangeNoti(){
        self.post(name: YNNotification.Name.HistoryChange, object: nil)
    }
    
    static func postNetStatusChangeNoti(){
        self.post(name: YNNotification.Name.NetStatusChange, object: nil)
    }
    
    static func addLoginNoti(_ observer: YNNotiProtocol){
        NotificationCenter.default.addObserver(observer, selector: #selector(observer.loginCompleted), name: YNNotification.Name.LoginCompleted, object: nil)
    }
    
    static func addPaySuccessNoti(_ observer: YNNotiProtocol){
        NotificationCenter.default.addObserver(observer, selector: #selector(observer.paySuccess), name: YNNotification.Name.ThirdPaySuccess, object: nil)
    }
    
}
//YNNotification.post(name: YNNotification.Name.ShareCompleted, object: ["isSuccess":false])
extension YNNotification.Name{
    
    public static let ThirdPaySuccess = notiName("ThirdPaySuccess")
    public static let LoginCompleted = notiName("LoginCompleted")
    public static let HistoryChange = notiName("HistoryChange")
    public static let ShareCompleted = notiName("ShareCompleted")
    public static let UserInfoDidChange = notiName("UserInfoDidChange")
    public static let GetAPIHostSuccess = notiName("GetAPIHostSuccess")
    public static let MyCollectDidChange = notiName("MyCollectDidChange")
    public static let InviteSuccess = notiName("InviteSuccess")
    public static let SrartMorelink = notiName("SrartMorelink")
    public static let EndFreeTrial = notiName("EndFreeTrial") //结束免费试看 视频播放结束免费看
    public static let GetPayResult = notiName("GetPayResult") //支付时点击左上角返回按钮触发，向服务器获取支付结果
    public static let CacheSizeChange = notiName("CacheSizeChange")
    public static let NetStatusChange = notiName("NetStatusChange")
    public static let APPISINSTART = notiName("APPISINSTART")
    public static let DotRefresh = notiName("DotRefresh")
    
    public static let VideoPlayDidEnd = notiName(NSNotification.Name.AVPlayerItemDidPlayToEndTime.rawValue)
    
    static func notiName(_ name:String) -> NSNotification.Name{
        return NSNotification.Name(rawValue: name)
    }
}


extension YNNotification{
    
    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?){
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    static func post(name aName: NSNotification.Name, object anObject: Any?){
        NotificationCenter.default.post(name: aName, object: anObject)
    }
    
    static func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]? = nil){
        NotificationCenter.default.post(name: aName, object: anObject, userInfo: aUserInfo)
    }
    
    static func removeObserver(_ observer: Any){
        NotificationCenter.default.removeObserver(observer)
    }
    
    static func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?){
        NotificationCenter.default.removeObserver(observer, name: aName, object: anObject)
    }
    
    @discardableResult static func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Swift.Void) -> NSObjectProtocol{
        return NotificationCenter.default.addObserver(forName: name, object: obj, queue: queue, using: block)
    }
    
}

extension NSNumber {
    
    /// formatter number 格式化数字 return String
    public func yn_formatterNumber(_ formatterStyle: NumberFormatter.Style, bits: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = bits
        formatter.maximumFractionDigits =  bits
        formatter.numberStyle = formatterStyle
        return formatter.string(from: self)
    }
    
    /// 整数 formatter number 格式化数字 return String
    public func yn_integerFormatterNumber(_ formatterStyle: NumberFormatter.Style) -> String? {
        return yn_formatterNumber(formatterStyle, bits: 0)
    }
    
    /// 2位小数 formatter number 格式化数字 return String
    public func yn_fractionFormatterNumber(_ formatterStyle: NumberFormatter.Style) -> String? {
        return yn_formatterNumber(formatterStyle, bits: 2)
    }
    
}
