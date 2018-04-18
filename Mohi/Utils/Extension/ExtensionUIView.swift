//
//  ExtensionUIView.swift
//  Flum
//
//  Created by RajeshYadav on 21/12/16.
//  Copyright © 2016 47billion. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    /**
     *  Pins the subview of the receiver to the edge of its frame, as specified by the given attribute, by adding a layout constraint.
     *
     *  @param subview   The subview to which the receiver will be pinned.
     *  @param attribute The layout constraint attribute specifying one of `NSLayoutAttributeBottom`, `NSLayoutAttributeTop`, `NSLayoutAttributeLeading`, `NSLayoutAttributeTrailing`.
     */
    func msg_pinSubview(_ subview: UIView, toEdge attribute: NSLayoutAttribute, withConstant:CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: withConstant))
    }
    
    /**
     *  Pins all edges of the specified subview to the receiver.
     *
     *  @param subview The subview to which the receiver will be pinned.
     */
    func msg_pinAllEdgesOfSubview(_ subview: UIView) {
        self.msg_pinSubview(subview, toEdge: .bottom, withConstant: 0.0)
        self.msg_pinSubview(subview, toEdge: .top, withConstant: 0.0)
        self.msg_pinSubview(subview, toEdge: .leading, withConstant: 0.0)
        self.msg_pinSubview(subview, toEdge: .trailing, withConstant: 0.0)
    }
    
    /**
     *  Pins all edges of the specified subview to the receiver.
     *
     *  @param subview The subview to which the receiver will be pinned.
     */
    func msg_pinAllEdgesOfMediaSubview(_ subview: UIView) {
        //self.msg_pinSubview(subview, toEdge: .bottom)
        self.msg_pinSubview(subview, toEdge: .top, withConstant: -5.0)
        self.msg_pinSubview(subview, toEdge: .leading, withConstant: 0.0)
        self.msg_pinSubview(subview, toEdge: .trailing, withConstant: 0.0)
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, isAllowBorder:Bool = false) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        //mask.borderColor = self.layer.borderColor
        //mask.borderColor = UIColor.red.cgColor
        //        mask.borderWidth = 1.0
        self.layer.mask = mask
        //        maskLayer1.path = maskPAth1.CGPath
        //        self.layer.mask = maskLayer1
        //        self.layer.addSublayer(mask)
        
        //        CAShapeLayer*   frameLayer = [CAShapeLayer layer];
        //        frameLayer.frame = bounds;
        //        frameLayer.path = maskPath.CGPath;
        //        frameLayer.strokeColor = [UIColor redColor].CGColor;
        //        frameLayer.fillColor = nil;
        //
        //        [self.layer addSublayer:frameLayer];
        
        if(isAllowBorder){
            let frameLayer = CAShapeLayer()
            frameLayer.name = "Border"
            frameLayer.frame = self.bounds
            frameLayer.path = path.cgPath
            //frameLayer.strokeColor = UIColor.red.cgColor
            frameLayer.strokeColor = self.layer.borderColor
            //            frameLayer.strokeStart
            frameLayer.fillColor = nil
            self.layer.addSublayer(frameLayer)
        }
    }
    
    func removeBorder(){
        //self.layer.sublayers = nil
        if(self.layer.sublayers != nil && (self.layer.sublayers?.count)! > 0){
            for layer in self.layer.sublayers! {
                if layer.name?.compare("Border") == ComparisonResult.orderedSame{
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
