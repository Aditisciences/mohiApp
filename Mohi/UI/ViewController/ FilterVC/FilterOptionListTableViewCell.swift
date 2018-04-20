//
//  FilterOptionListTableViewCell.swift
//  Mohi
//
//  Created by Mac on 10/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation


protocol FilterOptionListTableViewCellDelegate {
    func updateCheckBoxStatus(cellIndex:Int, status:Bool)
}

class FilterOptionListTableViewCell: UITableViewCell {
    
    var cellIndex:Int!
    var delegate:FilterOptionListTableViewCellDelegate?
    
    let ColorThumbnailWidth:CGFloat = 30
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var constraintColorWidth: NSLayoutConstraint!
    
    //    @IBOutlet weak var viewForRating: Cosmos!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        //btnCheck.isSelected = selected
    }
    
    func  updateCellInfo(title:String, cellIndex:Index, colorValue:String? = nil, checkBoxStatus:Bool){
        if(colorValue != nil){
            lblColor.isHidden = false
            lblColor.backgroundColor = UIColor(hexString: colorValue != nil ? "\(colorValue!)FF" : "")
            constraintColorWidth.constant = ColorThumbnailWidth
        } else{
            lblColor.isHidden = true
            constraintColorWidth.constant = 0
        }
        
        lblTitle.text = title.localizedLowercase.localizedCapitalized
        btnCheck.isSelected = checkBoxStatus
        self.cellIndex = cellIndex
    }
}

// MARK:- Action method implementation
extension FilterOptionListTableViewCell{
    @IBAction func checkBoxUpdateActionMethod(_ sender:Any){
        btnCheck.isSelected = !btnCheck.isSelected
        if(delegate != nil){
            delegate?.updateCheckBoxStatus(cellIndex:cellIndex, status:btnCheck.isSelected)
        }
    }
}
