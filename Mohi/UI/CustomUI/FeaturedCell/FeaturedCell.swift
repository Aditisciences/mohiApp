//
//  FeaturedCell.swift
//  Mohi
//
//  Created by Consagous on 13/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
protocol FeaturedCellDelegate {
    func methodSeeCategoriesProduct(cellIndex:Int)
}

class FeaturedCell: UICollectionViewCell {

    var cellIndex:Int!
    var delegate:FeaturedCellDelegate?
    
    @IBOutlet weak var  btnForCategories: UIButton!
    @IBOutlet weak var viewForMain: UIView!
    @IBOutlet weak var  lblForCateName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewForMain.layer.cornerRadius = viewForMain.frame.size.width/2
//        viewForMain.layer.borderWidth = 1.0
//        viewForMain.layer.borderColor =  UIColor.lightGray.cgColor
//        viewForMain.clipsToBounds = true
//        btnForCategories.imageView?.contentMode =  UIViewContentMode.scaleAspectFill
        
    }

    @IBAction func methodSeeCategoriesProduct(_ sender: Any) {
        if(delegate != nil){
            delegate?.methodSeeCategoriesProduct(cellIndex: self.cellIndex)
        }
    }
    
}
