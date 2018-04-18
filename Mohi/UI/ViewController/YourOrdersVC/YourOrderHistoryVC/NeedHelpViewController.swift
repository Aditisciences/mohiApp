//
//  NeedHelpViewController.swift
//  Mohi
//
//  Created by Apple_iOS on 12/01/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation

class NeedHelpViewController: BaseViewController {
    @IBOutlet weak var webView:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: APIParamConstants.needHelpUrl)
        let urlRequest:URLRequest = URLRequest(url: myURL!)
        
        webView.loadRequest(urlRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- Action method implementation
extension NeedHelpViewController{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
}
