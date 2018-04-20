//
//  MoreVC.swift
//  Mohi
//
//  Created by Consagous on 28/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import SideMenu

class MoreVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- Action method implementation
extension MoreVC{
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
