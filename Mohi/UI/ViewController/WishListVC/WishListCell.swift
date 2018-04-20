//
//  WishListCell.swift
//  Mohi
//
//  Created by Consagous on 12/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
//import ActiveLabel
import Cosmos

protocol WishListCellDelegate {
    func methodCancelProductFromWishList(cellIndex:Int)
    func methodProductAddToCart(cellIndex:Int)
}

class WishListCell: UITableViewCell {

    var cellIndex:Int!
    var delegate:WishListCellDelegate?

    
    @IBOutlet weak var imgForDress: UIButton!
    @IBOutlet weak var lblForTag: UILabel!
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var lblForPrice: UILabel!
    @IBOutlet weak var viewForRating:CosmosView!
    
//    @IBOutlet weak var viewForRating: Cosmos!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewForRating.isUserInteractionEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func methodCancelProductFromWishList(_ sender: Any) {
        if(delegate != nil){
            delegate?.methodCancelProductFromWishList(cellIndex: self.cellIndex)
        }
    }
    
    @IBAction func methodProductAddToCart(_ sender: Any) {
        if(delegate != nil){
            delegate?.methodProductAddToCart(cellIndex: self.cellIndex)
        }
    }
}
