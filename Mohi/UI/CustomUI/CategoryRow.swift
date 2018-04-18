//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import SDWebImage

protocol CategoryRowDelegate {
    func methodSeeCategoriesProduct(cellIndex:Int, rowIndex:Int)
    func addToCart(cellIndex:Int, rowIndex:Int)
    func removeFromWishList(cellIndex:Int, rowIndex:Int)
    func addToWishList(cellIndex:Int, rowIndex:Int)
    func methodShowProductDetails(cellIndex:Int, rowIndex:Int)
    func methodSeeAll(rowIndex:Int)
}

class CategoryRow : UITableViewCell {
    @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var labelRow: UILabel!
    
    var rowIndex:Int!
    var delegate:CategoryRowDelegate?
    var is_product = true
    
//    var featuredDataList:[APIResponseParam.FeaturedProduct.FeaturedProductData]?
//    var categoriesList:[APIResponseParam.Categories.CategoriesData]?
    var productList:[APIResponseParam.HomeScreenDetail.HomeScreenDetailData]?
    
    let rowValue = Int()
    
    func registerCustomCells(){
        collectionViewMain.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        collectionViewMain.register(UINib(nibName: "FeaturedCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCell")
    }
    
    func updateCellInfo(){
        collectionViewMain.reloadData()
    }
    
 }

extension CategoryRow{
    @IBAction func methodSeeAll(_ sender: Any) {
        if(delegate != nil){
            delegate?.methodSeeAll(rowIndex: self.rowIndex)
        }
    }
}

extension CategoryRow : UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList != nil ? (productList?.count)! : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productInfo = productList?[indexPath.row]
        if(!is_product){
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCell
            cell.delegate =  self
            cell.cellIndex = indexPath.row
            
            if(productInfo?.image != nil){
                cell.btnForCategories.sd_setImage(with: URL(string: (productInfo?.image)!), for: .normal, completed: nil)
            }
            cell.lblForCateName.text = productInfo?.product_name ?? ""
            return cell
        }
        
        // Default product cell
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.delegate =  self
        cell.cellIndex = indexPath.row
        
        if(productInfo?.image != nil){
            cell.btnForProductImage.sd_setImage(with: URL(string: (productInfo?.image!)!), for: .normal, completed: nil)
        }
        
        cell.lblForName.text =  productInfo?.product_name ?? ""
        
        let productPrice:Float = Float(productInfo?.product_price ?? "0.00")!
        if(productPrice > 0){
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", productPrice))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(9), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        } else {
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "0.00", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(9), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        }
        
        if(productInfo?.is_wishlist?.caseInsensitiveCompare("0") == ComparisonResult.orderedSame) {
            cell.btnForAddToFav.isSelected = true
        }else{
            cell.btnForAddToFav.isSelected = false
        }
        
        if(productInfo?.is_add_to_cart?.caseInsensitiveCompare("0") == ComparisonResult.orderedSame) {
            cell.btnForAddToCart.isSelected = true
        }else{
            cell.btnForAddToCart.isSelected = false
        }
        return cell
    }
}

extension CategoryRow : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
//        let ssnString = ((arrForData.object(at: indexPath.row) as AnyObject).value(forKey: "ssn") as? String)!
//        let notificationName = Notification.Name("CELLSELCTED")
//        // Post notification
//        NotificationCenter.default.post(name: notificationName, object: ssnString)
        
    }
}

extension CategoryRow : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //if collectionViewMain.tag == 0{
        if(self.rowIndex == 0) {
            return CGSize(width:100 , height: 100)
        }
        return  CGSize(width:140 , height: collectionView.frame.height)
    }
}

//MARK:- FeaturedCellDelegate method implementation
extension CategoryRow: FeaturedCellDelegate {
    func methodSeeCategoriesProduct(cellIndex:Int){
        if(delegate != nil){
            delegate?.methodSeeCategoriesProduct(cellIndex: cellIndex, rowIndex: self.rowIndex)
        }
    }
}

//MARK:- ProductCellDelegate method implementation
extension CategoryRow: ProductCellDelegate {
    func methodShowProductDetails(cellIndex:Int){
        if(delegate != nil){
            delegate?.methodShowProductDetails(cellIndex: cellIndex, rowIndex: self.rowIndex)
        }
    }
    func addToCart(cellIndex:Int){
        if(delegate != nil){
            delegate?.addToCart(cellIndex: cellIndex, rowIndex: self.rowIndex)
        }
    }
    func addToWishList(cellIndex:Int){
        if(delegate != nil){
            delegate?.addToWishList(cellIndex: cellIndex, rowIndex: self.rowIndex)
        }
    }
    func removeFromWishList(cellIndex:Int){
        if(delegate != nil){
            delegate?.removeFromWishList(cellIndex: cellIndex, rowIndex: self.rowIndex)
        }
    }
}

