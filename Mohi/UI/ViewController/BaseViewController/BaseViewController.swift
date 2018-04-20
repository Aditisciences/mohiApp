//
//  BaseViewController.swift
//  MyPanditJi
//
//  Created by Apple on 01/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var constraintNavigationHeight:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.constraintNavigationHeight != nil){
            if AppConstant.DeviceType.IS_IPHONE_X{
                self.constraintNavigationHeight?.constant = AppConstant.IPHONE_X_DEFAULT_NAVIGATION_BAR_HEIGHT
            }
        }
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
}
}
