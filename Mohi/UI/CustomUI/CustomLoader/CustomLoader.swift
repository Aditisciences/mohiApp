//
//  CustomLoader.swift
//  Mohi
//
//  Created by Apple_iOS on 25/01/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation
class CustomLoader: NSObject {
    
    static let sharedInstance = CustomLoader()
    private let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    //MARK: - Private Methods -
    private func setupLoader() {
        removeLoader()
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
    }
    
    //MARK: - Public Methods -
    func showLoader() {
        setupLoader()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let holdingView = appDel.window!.rootViewController!.view!
        
        DispatchQueue.main.async {
            self.activityIndicator.center = holdingView.center
            self.activityIndicator.startAnimating()
            holdingView.addSubview(self.activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
