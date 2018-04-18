//
//  SideViewController.swift
//  MyPanditJi
//
//  Created by Consagous on 07/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class SideViewController: DLHamburguerViewController {

    override func awakeFromNib() {
        
       let storyBoardContent = UIStoryboard(name: "Dashboard", bundle: nil)
        self.contentViewController =   storyBoardContent.instantiateViewController(withIdentifier: "CustomNavigation")
        
        self.menuViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HamburgerViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
