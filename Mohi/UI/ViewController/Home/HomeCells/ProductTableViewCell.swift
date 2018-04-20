//
//  ProductTableViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet var productView: UIView!
    
    //MARK: - Initialize cell -
    class func cellObject(forTable tableView: UITableView, indexPath: IndexPath) -> ProductTableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(), for: indexPath) as! ProductTableViewCell
        return cell
    }
    
    class func registerNib(forTable tableView: UITableView) {
        let nib: UINib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier())
    }
    
    class func cellIdentifier() -> String {
        return "ProductTableViewCellIdentifier"
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
