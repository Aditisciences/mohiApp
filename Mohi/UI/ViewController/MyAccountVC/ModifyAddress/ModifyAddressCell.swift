//
//  ModifyAddressCell.swift
//  Mohi
//
//  Created by RajeshYadav on 29/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

protocol ModifyAddressCellDelegate {
    func editButton(cellIndex:Int, editButtonFrame:CGRect)
    func deleteButton(cellIndex:Int, editButtonFrame:CGRect)
    func viewOptionButton(cellIndex:Int)
    func cellCurrentSelectedIndex(cellIndex:Int)
}

class ModifyAddressCell: UITableViewCell {
    
    @IBOutlet weak var buttonAddressSelection: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDesc:UILabel!
    @IBOutlet weak var viewOption:UIView!
    @IBOutlet weak var viewOptionEditOnly:UIView!
    
    var cellIndex:Int!
    var delegate:ModifyAddressCellDelegate?
    
    var lastSelectedStatus = false
    var isDeleteBtnHidden = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        buttonAddressSelection.isSelected = selected
        
//        if !selected {
            //viewOption.isHidden = true
        //viewOptionEditOnly.isHidden = true
//        }
//
        if delegate != nil && selected{
            delegate?.cellCurrentSelectedIndex(cellIndex: cellIndex)
        }
        
        buttonDelete.isHidden = isDeleteBtnHidden
        
    }
    
    func udpateSelection(status:Bool){
        buttonAddressSelection.isSelected = status
    }
}

//MARK:- Action method implementation
extension ModifyAddressCell{
    @IBAction func editOptionButtonAction(_ sender:Any){
        
        if(!self.buttonAddressSelection.isHidden){
            viewOptionEditOnly.isHidden = false
        }else{
            viewOption.isHidden = false
        }
        
        if(delegate != nil){
            delegate?.viewOptionButton(cellIndex: self.cellIndex)
        }
    }
    
    @IBAction func editButtonAction(_ sender:Any){
        //viewOption.isHidden = true
        if(delegate != nil){
            delegate?.editButton(cellIndex: self.cellIndex, editButtonFrame: buttonEdit.frame)
        }
    }
    
    @IBAction func deleteButtonAction(_ sender:UIButton){
        
        if(!BaseApp.sharedInstance.isTooEarlyMultipleClicks(sender)){
//            viewOption.isHidden = true
            if(delegate != nil){
                delegate?.deleteButton(cellIndex: self.cellIndex, editButtonFrame: buttonEdit.frame)
            }
        }
    }
}
