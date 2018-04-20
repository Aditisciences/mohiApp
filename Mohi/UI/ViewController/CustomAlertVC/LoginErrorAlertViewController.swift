//
//  LoginErrorAlertViewController.swift
//  Mohi
//
//  Created by Apple_iOS on 19/01/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation

protocol LoginErrorAlertViewControllerDelegate {
    func openLoginView()
    func openSignupView()
}

class LoginErrorAlertViewController: BaseViewController {
    
    @IBOutlet weak var titleHeightConstraint:NSLayoutConstraint!
//    @IBOutlet weak var buttonError: UIButton!
    @IBOutlet weak var optionsContainerView: UIView!
    
    var delegate:LoginErrorAlertViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // blur effect
//        //self.view.backgroundColor = UIColor().transparentBlur()
//        self.view.backgroundColor = UIColor.trans
    }
}
//
//extension LoginErrorAlertViewController{
//    func updateBlur() {
//        // 1
//        optionsContainerView.isHidden = true
//        
//        // 2
//        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,
//                                               true, 1)
//        // 3
//        self.view.drawHierarchy(in: self.view.bounds,
//                                          afterScreenUpdates: true)
//        // 4
//        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        let blur = screenshot.applyLightEffect()
//        
//        blurView.frame = optionsContainerView.bounds
//        blurView.image = blur
//        blurView.contentMode = .Bottom
//        
//        optionsContainerView.hidden = false
//    }
//}

extension LoginErrorAlertViewController{
//    @IBAction func methodCancelAction(_ sender: Any) {
//        self.view.removeFromSuperview()
//        if(delegate != nil){
//            delegate?.cancelProfileUpdateCustomAlertViewControllerScr()
//        }
//    }
    
    @IBAction func methodLoginAction(_ sender: Any) {
        self.view.removeFromSuperview()
        if(delegate != nil){
            delegate?.openLoginView()
        }
    }
    
    @IBAction func methodSignUpAction(_ sender: Any) {
        self.view.removeFromSuperview()
        if(delegate != nil){
            delegate?.openSignupView()
        }
    }
}
