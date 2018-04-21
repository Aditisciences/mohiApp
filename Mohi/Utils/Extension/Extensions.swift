//
//  Extensions.swift
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


extension String {
    
    var length: Int {
        return characters.count
    }
    
    func toBase64()->String{
        
        let data = self.data(using: String.Encoding.utf8)
        
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
    }
    
//    func hmacMd5(_ key: String, doBase64: Bool) -> String {
//        let inputData: Data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//        let keyData: Data = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//        
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CCHmac(CCHmacAlgorithm(kCCHmacAlgMD5), (keyData as NSData).bytes, keyData.count, (inputData as NSData).bytes, inputData.count, result)
//        let data = Data(bytes: UnsafePointer<UInt8>(result), count: digestLen)
//        result.deinitialize()
//        
//        var datastring:String?
//        if(doBase64){
//            datastring = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
//        }else{
//            datastring = stringFromResult(result, length: digestLen)
//        }
//        
//        return (datastring ?? "")!
//    }
    
    fileprivate func stringFromResult(_ result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return BaseApp.sharedInstance.removeOptionalString(String(describing: hash))
    }
    
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return BaseApp.sharedInstance.removeOptionalString(String(describing: self[i] as Character))
    }

    //TODO: change for swift3
    subscript (r: Range<Int>) -> String {
        // for swift2
        //let start = characters.index(startIndex, offsetBy: r.lowerBound)
        //let end = start.advancedBy(r.upperBound - r.lowerBound)
        
        // for swift3
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        
        return String(self[Range(start ..< end)])
    }
    
    func substring(with range: NSRange) -> String {
        let nsString = self as NSString
        return nsString.substring(with: range)
    }
    
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
    func validatePhoneNo(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

protocol DoubleConvertible {
    init(_ double: Double)
    var double: Double { get }
}

extension Double : DoubleConvertible { var double: Double { return self         } }
extension Float  : DoubleConvertible { var double: Double { return Double(self) } }
extension CGFloat: DoubleConvertible { var double: Double { return Double(self) } }

extension DoubleConvertible {
    var degreesToRadians: DoubleConvertible {
        return Self(double * M_PI / 180)
    }
    var radiansToDegrees: DoubleConvertible {
        return Self(double * 180 / M_PI)
    }
}

extension UITableView {
    func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
        
    }
    
    
    func layoutTableHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutFormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension UIImage {
    func maskWithColor(_ color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext?.clip(to: bounds, mask: maskImage!)
        bitmapContext?.setFillColor(color.cgColor)
        bitmapContext?.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext?.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            
            return coloredImage
            
        } else {
            return nil
        } 
    }
}

//MARK:- UIButton Extension to set image icon at any position
extension UIButton {
    
    //    This method sets an image and title for a UIButton and
    //    repositions the titlePosition with respect to the button image.
    //    Add additionalSpacing between the button image & title as required
    //    For titlePosition, the function only respects UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft and UIViewContentModeRight
    //    All other titlePositions are ignored
    @objc func set(image anImage: UIImage?, title: NSString!, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title!, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title as? String, for: state)
    }
    
    private func positionLabelRespectToImage(title: NSString, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    func playImplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func playExplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        var values = [Double]()
        let e = 2.71
        
        for t in 1..<100 {
            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
            
            values.append(value)
        }
        
        bounceAnimation.values = values
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func setImageColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func setImageColorForState(image: UIImage, color: UIColor, forState: UIControlState) {
        let temp = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        setImage(temp, for: forState)
        tintColor = color
    }
}

extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
