//
//  FontsConfig.swift
// Flum
//
//  Created by Pawan Jat on 19/12/16.
//  Copyright © 2016 Pawan Jat. All rights reserved.
//

import Foundation
import UIKit

class FontsConfig: NSObject {
  
    static let FONT_SIZE_10:CGFloat = 10.0
    static let FONT_SIZE_11:CGFloat = 11.0
    static let FONT_SIZE_12:CGFloat = 12.0
    static let FONT_SIZE_13:CGFloat = 13.0
    static let FONT_SIZE_14:CGFloat = 14.0
    static let FONT_SIZE_15:CGFloat = 15.0
    static let FONT_SIZE_16:CGFloat = 16.0
    static let FONT_SIZE_17:CGFloat = 17.0
    static let FONT_SIZE_18:CGFloat = 18.0
    static let FONT_SIZE_19:CGFloat = 19.0
    static let FONT_SIZE_20:CGFloat = 20.0
    static let FONT_SIZE_21:CGFloat = 21.0
    static let FONT_SIZE_22:CGFloat = 22.0
    static let FONT_SIZE_23:CGFloat = 23.0
    static let FONT_SIZE_24:CGFloat = 24.0
    static let FONT_SIZE_25:CGFloat = 25.0
    static let FONT_SIZE_26:CGFloat = 26.0
    static let FONT_SIZE_27:CGFloat = 27.0
    static let FONT_SIZE_28:CGFloat = 28.0

    
    static let FONT_TYPE_UbantuB:String = "Ubuntu-Bold"
    static let FONT_TYPE_UbantuL:String = "Ubuntu-Light"
    static let FONT_TYPE_UbantuM:String = "Ubuntu-Medium"
    static let FONT_TYPE_UbantuR:String = "Ubuntu-Regular"
    
    static let FONT_TYPE_GothiB:String = "Century Gothic Bold"
    static let FONT_TYPE_GothiR:String = "Century Gothic"
    
    struct FontHelper {
        static func defaultFontUbantuWithSizeB(_ size: CGFloat) -> UIFont {
            return UIFont(name: FONT_TYPE_UbantuB as String, size: size)!
        }
        
        static func defaultFontUbantuWithSizeL(_ size: CGFloat) -> UIFont {
            return UIFont(name: FONT_TYPE_UbantuL as String, size: size)!
        }
        
        static func defaultFontUbantuWithSizeM(_ size: CGFloat) -> UIFont {
            return UIFont(name: FONT_TYPE_UbantuM as String, size: size)!
        }
        
        static func defaultFontUbantuWithSizeR(_ size: CGFloat) -> UIFont {
            return UIFont(name: FONT_TYPE_UbantuR as String, size: size)!
        }
        
        static func defaultFontGothiWithSizeB(_ size: CGFloat) -> UIFont {
            return UIFont(name: FONT_TYPE_GothiB as String, size: size)!
        }

        static func defaultFontGothiWithSizeR(_ size: CGFloat) -> UIFont {
            return UIFont(name: FONT_TYPE_GothiR as String, size: size)!
        }
    }
}
