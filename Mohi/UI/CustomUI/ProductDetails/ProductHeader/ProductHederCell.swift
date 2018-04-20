//
//  ProductHederCell.swift
//  Mohi
//
//  Created by Consagous on 16/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
protocol ProductHederCellDelegate {
    
    func actionONAddToWishList(cellIndex:Int)
    func actionONSideImages(cellIndex:Int)
}


class ProductHederCell: UITableViewCell {

    var cellIndex:Int!
    var delegate:ProductHederCellDelegate?
    
    @IBOutlet weak var imgThumb1: UIButton!
    @IBOutlet weak var imgThumb2: UIButton!
    @IBOutlet weak var imgThumb3: UIButton!
    @IBOutlet weak var imgThumb4: UIButton!
    
    @IBOutlet weak var imgThumbMain: UIButton!
    @IBOutlet weak var btnForWishList: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionONAddToWishList(_ sender: Any){
        if(delegate != nil){
            delegate?.actionONAddToWishList(cellIndex: self.cellIndex)
        }
    }
    
    @IBAction func actionONSideImages(_ sender: UIButton){
        if(delegate != nil){
            delegate?.actionONSideImages(cellIndex: self.cellIndex)
        }
    }
}
