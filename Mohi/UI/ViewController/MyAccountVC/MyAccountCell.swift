//
//  MyAccountCell.swift
//  Mohi
//
//  Created by Consagous on 12/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class MyAccountCell: UITableViewCell {

    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var btnTextNImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
