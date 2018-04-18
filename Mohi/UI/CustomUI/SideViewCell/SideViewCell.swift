//
//  SideViewCell.swift
//  MyPanditJi
//
//  Created by Consagous on 08/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class SideViewCell: UITableViewCell {

    
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var btnForImage: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
