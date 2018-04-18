//
//  BuyNowTableViewCell.swift
//  Mohi
//
//  Created by Mac on 06/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

protocol BuyNowTableViewCellDelegate {
    func actionOnQty(cellIndex:Int, quantity:String)
    func quantityButtonAction(cellIndex:Int, quantity:String)
}

class BuyNowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelProductName:UILabel!
    @IBOutlet weak var labelProductPrice:UILabel!
    @IBOutlet weak var labelExpectedDeliveryCharges:UILabel!
    @IBOutlet weak var txtForQty: UITextField!
    @IBOutlet weak var imageViewProductThumnail: UIImageView!
    
    fileprivate var customPicker: UIPickerView!
    fileprivate var pickerArray = AppConstant.quantityArray
    
    var cellIndex:Int = -1
    var delegate:BuyNowTableViewCellDelegate?
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
}

extension BuyNowTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
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
        if(delegate != nil){
            delegate?.actionOnQty(cellIndex: cellIndex, quantity: pickerArray[row])
        }
    }
}

extension BuyNowTableViewCell{
    @IBAction func quantityButtonAction(_ sender:Any){
        let index = (self.txtForQty.text != nil) ? (Int(self.txtForQty.text!)! - 1): 0
        if(index < pickerArray.count){
            self.customPicker.selectRow(index, inComponent: 0, animated: true)
        }
        if(delegate != nil){
            delegate?.quantityButtonAction(cellIndex: cellIndex, quantity: self.txtForQty.text!)
        }
        
        
        self.txtForQty.becomeFirstResponder()
    }
}
