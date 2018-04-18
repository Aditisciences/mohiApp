//
//  HomeViewController.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - IBOutlet -
    @IBOutlet weak var homeTableView: UITableView!    
    //MARK: - Variable -
    var homeRefreshControl: UIRefreshControl = UIRefreshControl()
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Register table
        self.homeTableView.estimatedRowHeight = 322.0
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.tableFooterView = UIView()
        
        TopAddSliderTableViewCell.registerNib(forTable: self.homeTableView)
        HomeOfferTableViewCell.registerNib(forTable: self.homeTableView)
        ProductTableViewCell.registerNib(forTable: self.homeTableView)
        BannerTableViewCell.registerNib(forTable: self.homeTableView)
        FooterTableViewCell.registerNib(forTable: self.homeTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
