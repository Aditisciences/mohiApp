//
//  OrderHistoryCell.swift
//  Mohi
//
//  Created by Mac on 05/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation
import Cosmos

protocol OrderHistoryCellDelegate {
    func openWriteReviewScr(cellIndex:Int)
    func cancelButtonPressed(cellIndex:Int)
    func needHelpButtonPressed(cellIndex:Int)
}

class OrderHistoryCell: UITableViewCell {
    
    @IBOutlet weak var labelProductTitle: UILabel!
    @IBOutlet weak var labelProductDeliveryStatus: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var viewForRating: CosmosView!
    @IBOutlet weak var viewDeliveryToolbar: UIView!
    @IBOutlet weak var viewPendingToolbar: UIView!
    
    var cellIndex:Int = -1
    var delegate:OrderHistoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension OrderHistoryCell{
    @IBAction func writeReviewButtonAction(_ sender:Any){
        if(delegate != nil){
            delegate?.openWriteReviewScr(cellIndex: cellIndex)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender:Any){
        if(delegate != nil){
            delegate?.cancelButtonPressed(cellIndex: cellIndex)
        }
    }
    
    @IBAction func needHelpButtonAction(_ sender:Any){
        if(delegate != nil){
            delegate?.needHelpButtonPressed(cellIndex: cellIndex)
        }
    }
}
