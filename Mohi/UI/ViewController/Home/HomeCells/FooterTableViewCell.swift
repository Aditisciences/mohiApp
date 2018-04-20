//
//  FooterTableViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet var footerView: UIView!
    
    //MARK: - Initialize cell -
    class func cellObject(forTable tableView: UITableView, indexPath: IndexPath) -> FooterTableViewCell {
        let cell: FooterTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(), for: indexPath) as! FooterTableViewCell
        return cell
    }
    
    class func registerNib(forTable tableView: UITableView) {
        let nib: UINib = UINib(nibName: "FooterTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier())
    }
    
    class func cellIdentifier() -> String {
        return "FooterTableViewCellIdentifier"
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
