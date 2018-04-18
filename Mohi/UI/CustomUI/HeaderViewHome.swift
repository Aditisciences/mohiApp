//
//  HeaderViewHome.swift
//  Mohi
//
//  Created by Consagous on 13/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

protocol HeaderViewHomeCellDelegate {
    func methodSeeAllAction(cellIndex:Int)
}


class HeaderViewHome: UIView {
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var btnForSeeAll: UIButton!
    
    var cellIndex:Int!
    var delegate:HeaderViewHomeCellDelegate?
    
    @IBAction func methodSeeAllAction(_ sender: Any) {
        if(delegate != nil){
            delegate?.methodSeeAllAction(cellIndex: self.cellIndex)
        }
    }
    
   

}
