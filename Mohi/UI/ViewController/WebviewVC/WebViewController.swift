//
//  WebViewController.swift
//  Mohi
//
//  Created by Consagous on 28/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class WebViewController: BaseViewController{
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    
    var screenName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelScreenTitle.text = screenName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Action  method implementation
extension WebViewController{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
}
