//
//  CartCell.swift
//  Mohi
//
//  Created by Consagous on 17/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

protocol CartCellDelegate {
    func removeFromAddToCart(cellIndex:Int)
    func moveToWishList(cellIndex:Int)
    func actionOnQty(cellIndex:Int, quantity:String)
 }

class CartCell: UITableViewCell {

    var cellIndex:Int!
    var delegate:CartCellDelegate?
    
    var customPicker: UIPickerView!
    
    @IBOutlet weak var btnForImage: UIButton!
    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var btnRemoveWishList: UIButton!
    @IBOutlet weak var lblForCateName: UILabel!
    @IBOutlet weak var lblForProductName: UILabel!
    @IBOutlet weak var lblForPrice: UILabel!
    @IBOutlet weak var lblForDeliver: UILabel!
    @IBOutlet weak var txtForQty: UITextField!
    
    @IBOutlet weak var viewQty: UIView!
    
    fileprivate var pickerArray = AppConstant.quantityArray
    var selectedIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220))
        customPicker.delegate = self
        customPicker.showsSelectionIndicator = true
        txtForQty.inputView = customPicker
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateRemoveWishListToAddCart(){
        btnRemoveWishList.setImage(#imageLiteral(resourceName: "cart_gray"), for: UIControlState.normal)
        btnRemoveWishList.setTitle("Add to cart", for: UIControlState.normal)
    }
}

//MARK:- Action method implementation
extension CartCell {
    @IBAction func removeFromAddToCart(_ sender: Any) {
        if(delegate != nil){
            delegate?.removeFromAddToCart(cellIndex: self.cellIndex)
        }
    }
    
    @IBAction func moveToWishList(_ sender: Any) {
        if(delegate != nil){
            delegate?.moveToWishList(cellIndex: self.cellIndex)
        }
    }
    
    @IBAction func actionOnQty(_ sender: Any) {
        let index = (self.txtForQty.text != nil) ? (Int(self.txtForQty.text!)! - 1): 0
        if(index < pickerArray.count){
            self.customPicker.selectRow(index, inComponent: 0, animated: true)
        }
        self.txtForQty.becomeFirstResponder()
    }
}

extension CartCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerArray.count
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row)")
        selectedIndex = row
        txtForQty.text = pickerArray[row]
        txtForQty.resignFirstResponder()
        if(delegate != nil){
            delegate?.actionOnQty(cellIndex: cellIndex, quantity: pickerArray[row])
        }
    }
}

