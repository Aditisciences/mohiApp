//
//  StatusViewCell.swift
//  Mohi
//

import UIKit

class StatusViewCell: UITableViewCell {

    @IBOutlet weak var labelStatusName: UILabel?
    @IBOutlet weak var imageViewStatus:UIImageView!
    
    
    var item: ColourModel?{
        didSet{
            guard let item = item else {
                return
            }
           
            labelStatusName?.text = item.name
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func updateCheckStatus(isEnable:Bool){
        if(isEnable){
            imageViewStatus?.image = UIImage(named: "checkbox-selected")
        }else{
            imageViewStatus?.image = UIImage(named: "checkbox-unselected")
        }
    }
    
}
