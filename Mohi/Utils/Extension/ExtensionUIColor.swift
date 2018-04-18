//
//  ExtensionUIColor.swift
//  Flum
//
//  Created by RajeshYadav on 21/12/16.
//  Copyright © 2016 47billion. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /**
     *  @return A color object containing HSB values similar to the iOS 7 messages app green bubble color.
     */
    class func msg_messageBubbleGreenColor() -> UIColor {
        return UIColor(hue: CGFloat(130.0 / 360.0), saturation: CGFloat(0.68), brightness: CGFloat(0.84), alpha: CGFloat(1.0))
    }
    
    /**
     *  @return A color object containing HSB values similar to the iOS 7 messages app green bubble color.
     */
    class func appTheamRedColor() -> UIColor {
        return UIColor.init(red: 206/255.0, green: 12/255.0, blue: 93/255.0, alpha: 1.0)
    }
    
    /**
     *  @return A color object containing HSB values similar to the iOS 7 messages app green bubble color.
     */
    class func appTheamWhiteColor() -> UIColor {
        return UIColor.init(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
    }
    
    /**
     *  @return A color object containing HSB values similar to the iOS 7 messages app blue bubble color.
     */
    class func msg_messageBubbleBlueColor() -> UIColor {
        return UIColor(hue: CGFloat(210.0 / 360.0), saturation: CGFloat(0.94), brightness: CGFloat(1.0), alpha: CGFloat(1.0))
    }
    
    /**
     *  @return A color object containing HSB values similar to the iOS 7 red color.
     */
    class func msg_messageBubbleRedColor() -> UIColor {
        return UIColor(hue: CGFloat(0.0 / 360.0), saturation: CGFloat(0.79), brightness: CGFloat(1.0), alpha: CGFloat(1.0))
    }
    
    /**
     *  @return A color object containing HSB values similar to the iOS 7 messages app light gray bubble color.
     */
    class func msg_messageBubbleLightGrayColor() -> UIColor {
        return UIColor(hue: CGFloat(240.0 / 360.0), saturation: CGFloat(0.02), brightness: CGFloat(0.92), alpha: CGFloat(1.0))
    }
    
    //MARK: - Utilities
    /**
     *  Creates and returns a new color object whose brightness component is decreased by the given value, using the initial color values of the receiver.
     *
     *  @param value A floating point value describing the amount by which to decrease the brightness of the receiver.
     */
    func msg_colorByDarkeningColor(withValue value: CGFloat) -> UIColor {
        let totalComponents = self.cgColor.numberOfComponents
        let isGreyscale = (totalComponents == 2) ? true : false
        var oldComponents: [CGFloat] = self.cgColor.components!
        var newComponents = [CGFloat](repeating: 0.0, count: 4)
        if isGreyscale {
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[3] = oldComponents[1]
        }else {
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value
            newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value
            newComponents[3] = oldComponents[3]
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColor(colorSpace: colorSpace, components: newComponents)
        let retColor = UIColor(cgColor: newColor!)
        return retColor
    }
}
