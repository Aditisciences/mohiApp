//
//  BannerTableViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet var bannerImageView: UIImageView!
    
    //MARK: - Initialize cell -
    class func cellObject(forTable tableView: UITableView, indexPath: IndexPath) -> BannerTableViewCell {
        let cell: BannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(), for: indexPath) as! BannerTableViewCell
        return cell
    }
    
    class func registerNib(forTable tableView: UITableView) {
        let nib: UINib = UINib(nibName: "BannerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier())
    }
    
    class func cellIdentifier() -> String {
        return "BannerTableViewCellIdentifier"
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
    
    //MARK: - Initalize class -
    func configureCell(imageURL: String) {
        
        if let uRL: URL = URL(string: imageURL) {
            
            self.bannerImageView.sd_setImage(with: uRL, placeholderImage: nil, options: [], completed: { [weak self] (image, error, cacheType, url) in
                self?.bannerImageView.image = image
            })
            
        }
    }
    
}
