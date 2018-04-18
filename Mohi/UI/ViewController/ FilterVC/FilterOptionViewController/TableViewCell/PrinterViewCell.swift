//
//  PrinterViewCell.swift
//  Mohi
//

import UIKit

class PrinterViewCell: UITableViewCell {

    @IBOutlet weak var labelPrinterName: UILabel?
    @IBOutlet weak var imageViewStatus:UIImageView!
    
    var item: ShopByBrandModel?{
        didSet{
            guard let item = item else {
                return
            }
            
            labelPrinterName?.text = item.name
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
