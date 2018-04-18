//
//  TutorialCollectionViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 29/03/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

protocol TutorialCollectionViewCellDelegate: class {
    func doneTutorialAction()
}

class TutorialCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var tutorialDoneButton: UIButton!

    //MARK: - Variables -
    weak var delegate: TutorialCollectionViewCellDelegate?
    
    //MARK: - Register nib -
    class func tutorialItemRegisterNib(collectionView: UICollectionView) {
        let tutorialNib: UINib = UINib.init(nibName: "TutorialCollectionViewCell", bundle: nil)
        collectionView.register(tutorialNib, forCellWithReuseIdentifier: self.itemIdentifier())
    }
    
    //MARK: - Instance object -
    class func tutorialInstanceObject(collectionView: UICollectionView, indexPath: IndexPath) -> TutorialCollectionViewCell {
        let tutorialItem: TutorialCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier(), for: indexPath) as! TutorialCollectionViewCell
        return tutorialItem
    }
    
    class func itemIdentifier() -> String {
        return "tutorialItemIdentifier"
    }
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Initalize class -
    func configureTutorialItem(index: Int) {
        
        self.tutorialDoneButton.isHidden = true
        
        switch index {
        case 0:
            self.tutorialImageView.image = UIImage(named: "tutorial1")
        case 1:
            self.tutorialImageView.image = UIImage(named: "tutorial2")
        default:
            self.tutorialDoneButton.isHidden = false
            self.tutorialImageView.image = UIImage(named: "tutorial3")
        }
        
    }
    
    //MARK: - IBAction -
    @IBAction func tutorialDoneAction(_ sender: AnyObject) {
        self.delegate?.doneTutorialAction()
    }
}
