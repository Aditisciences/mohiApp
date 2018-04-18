//
//  ProductMiddleCell.swift
//  Mohi
//
//  Created by Consagous on 16/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Cosmos

protocol ProductMiddleCellDelegate {
    func actionONSizeChart(cellIndex:Int)
    func actionONAddToCart(cellIndex:Int)
    func actionONBuyNow(cellIndex:Int)
    func actionONWriteReview(cellIndex:Int)
}

class ProductMiddleCell: UITableViewCell {
    
    var cellIndex:Int!
    var delegate:ProductMiddleCellDelegate?
    
    @IBOutlet weak var btnForSizeChart: UIButton!
    @IBOutlet weak var btnForAddToCart: UIButton!
    @IBOutlet weak var btnForBuyNow: UIButton!
    
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var lblForPrice: UILabel!
    @IBOutlet weak var lblForAvailable: UILabel!
    
    @IBOutlet weak var viewForRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnForSizeChart.layer.cornerRadius = 10.0
        btnForSizeChart.layer.masksToBounds = true
        
        btnForAddToCart.layer.cornerRadius = 10.0
        btnForAddToCart.layer.masksToBounds = true
        
        btnForBuyNow.layer.cornerRadius = 10.0
        btnForBuyNow.layer.masksToBounds = true
        viewForRating.isUserInteractionEnabled = false
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction  func actionONSizeChart(_ sender: Any){
        if(delegate != nil){
            delegate?.actionONSizeChart(cellIndex: self.cellIndex)
        }
    }
    @IBAction func actionONAddToCart(_ sender: Any){
        if(delegate != nil){
            delegate?.actionONAddToCart(cellIndex: self.cellIndex)
        }
    }
    @IBAction  func actionONBuyNow(_ sender: Any){
        if(delegate != nil){
            delegate?.actionONBuyNow(cellIndex: self.cellIndex)
        }
    }
    @IBAction func actionONWriteReview(_ sender: Any){
        if(delegate != nil){
            delegate?.actionONWriteReview(cellIndex: self.cellIndex)
        }
    }
    
}
