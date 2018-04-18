//
//  ExtensionNSObject.swift
//  Flum
//
//  Created by RajeshYadav on 30/12/16.
//  Copyright © 2016 47billion. All rights reserved.
//

import Foundation
public extension NSObject{
    public class var nameOfClass: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var nameOfClass: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
