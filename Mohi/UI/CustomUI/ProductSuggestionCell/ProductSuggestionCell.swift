//
//  ProductCell.swift
//  Mohi
//
//  Created by Consagous on 13/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

protocol ProductSuggestionCellDelegate {
//    func addToCart(cellIndex:Int)
//    func addToWishList(cellIndex:Int)
//    func removeFromWishList(cellIndex:Int)
    func methodShowProductDetails(cellIndex:Int)
    
}

class ProductSuggestionCell: UICollectionViewCell {
    
    var cellIndex:Int!
    var delegate:ProductSuggestionCellDelegate?
    
    //@IBOutlet weak var  btnForProductImage: UIButton!
    @IBOutlet weak var  imageViewProductImage: UIImageView!
    @IBOutlet weak var  btnForAddToCart: UIButton!
    @IBOutlet weak var  btnForAddToFav: UIButton!
    //  @IBOutlet weak var  btnForAddToCart: UIButton!
    @IBOutlet weak var  viewForLower: ViewLayerSetup!
    @IBOutlet weak var lblForPrice: UILabel!
    @IBOutlet weak var lblForName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        btnForProductImage.imageView?.contentMode =  UIViewContentMode.scaleAspectFill
        // Initialization code
    }
    
//    @IBAction func addToCart(_ sender: Any) {
//        if(delegate != nil){
//            delegate?.addToCart(cellIndex: self.cellIndex)
//        }
//    }
//
//    @IBAction func addToWishList(_ sender: Any) {
//        let button : UIButton = sender as! UIButton
//        if button.isSelected == false{
//            button.isSelected = true
//            if(delegate != nil){
//                delegate?.removeFromWishList(cellIndex: self.cellIndex)
//            }
//        }else{
//            button.isSelected = false
//
//            if(delegate != nil){
//                delegate?.addToWishList(cellIndex: self.cellIndex)
//            }
//
//        }
//    }
    
    @IBAction func methodShowProductDetails(_ sender: Any) {
        if(delegate != nil){
            delegate?.methodShowProductDetails(cellIndex: self.cellIndex)
        }
    }
}



