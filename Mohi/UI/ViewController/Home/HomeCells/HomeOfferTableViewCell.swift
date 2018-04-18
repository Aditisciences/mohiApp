//
//  HomeOfferTableViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class HomeOfferTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet var offerView: UIView!
    
    //MARK: - Initialize cell -
    class func cellObject(forTable tableView: UITableView, indexPath: IndexPath) -> HomeOfferTableViewCell {
        let cell: HomeOfferTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(), for: indexPath) as! HomeOfferTableViewCell
        return cell
    }
    
    class func registerNib(forTable tableView: UITableView) {
        let nib: UINib = UINib(nibName: "HomeOfferTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier())
    }
    
    class func cellIdentifier() -> String {
        return "HomeOfferTableViewCellIdentifier"
    }
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
