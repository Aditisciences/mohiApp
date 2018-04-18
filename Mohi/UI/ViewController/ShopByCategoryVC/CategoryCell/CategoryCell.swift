//
//  CategoryCell.swift
//  Mohi
//
//  Created by Consagous on 12/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    //@IBOutlet weak var  btnForCategoriesImage: UIButton!
    @IBOutlet weak var imageViewForCategoriesImage: UIImageView!
    @IBOutlet weak var viewForMain: UIView!
    @IBOutlet weak var  viewForCateName: ViewLayerSetup!
    @IBOutlet weak var  lblForCateName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //btnForCategoriesImage.imageView?.contentMode =  UIViewContentMode.scaleAspectFill
        
        viewForCateName.roundCorners(.topLeft, radius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
