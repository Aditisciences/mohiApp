//
//  FaultViewCell.swift
//  Mohi
//

import UIKit

class FaultViewCell: UITableViewCell {

    @IBOutlet weak var labeFaultName: UILabel?
    @IBOutlet weak var imageViewStatus:UIImageView!
    
    var item: Catalog? {
        didSet {
            guard  let item = item else {
                return
            }
            
            labeFaultName?.text = item.name
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
