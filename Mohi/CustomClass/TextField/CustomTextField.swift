//  CustomTextField.swift
//  Mohi
//
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateProperties()
    }
    
    //MARK: - Private methods -
    private func updateProperties() {
        
//        if let font: UIFont = UIFont(name: "Century Gothic", size: 16.0) {
//            self.font = font
//        }else {
//            self.font = UIFont.systemFont(ofSize: 16.0)
//        }
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15.0, height: self.bounds.size.height))
        self.leftView?.backgroundColor = self.backgroundColor
        
        self.rightViewMode = UITextFieldViewMode.always
        self.rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15.0, height: self.bounds.size.height))
        self.rightView?.backgroundColor = self.backgroundColor
    }
}

