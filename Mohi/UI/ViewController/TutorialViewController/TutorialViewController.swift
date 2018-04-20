//
//  TutorialViewController.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 29/03/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var tutorialPageControl: UIPageControl!

    //MARK: - Instance object -
    class func instanceObject() -> TutorialViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let controller: TutorialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        TutorialCollectionViewCell.tutorialItemRegisterNib(collectionView: self.tutorialCollectionView)
    }
    
    @IBAction func skipTutorialAction(_ sender: AnyObject) {
        self.skipTutorialAction()
    }
    
    @IBAction func tutorialPageControlAction(_ sender: AnyObject) {
        
        let pageNumber: CGFloat = CGFloat.init(self.tutorialPageControl.currentPage)
        
        let moveToPoint: CGPoint = CGPoint(x: AppConstant.ScreenSize.SCREEN_WIDTH * pageNumber, y: 0.0)
        
        let indexPath: IndexPath = self.tutorialCollectionView.indexPathForItem(at: moveToPoint)!
        
        self.tutorialCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    func skipTutorialAction() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setUpApplicationRootView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tutorialItem: TutorialCollectionViewCell = TutorialCollectionViewCell.tutorialInstanceObject(collectionView: collectionView, indexPath: indexPath)
        
        if tutorialItem.delegate == nil {
            tutorialItem.delegate = self
        }
        
        tutorialItem.configureTutorialItem(index: indexPath.item)
        
        return tutorialItem
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}

extension TutorialViewController: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = AppConstant.ScreenSize.SCREEN_WIDTH
        let pageNo = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.tutorialPageControl.currentPage = Int(pageNo)
    }
}


extension TutorialViewController: TutorialCollectionViewCellDelegate {
    
    internal func doneTutorialAction() {
        self.skipTutorialAction()
    }
}
