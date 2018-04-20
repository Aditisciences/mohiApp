//
//  TimelineViewController.swift
//  Mohi
//
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var mohiFeedsView: UIView!
    @IBOutlet weak var wishlistView: UIView!

    @IBOutlet weak var widthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!

    //MARK: - Variables -
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // self.initializeTimeline()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.widthLayoutConstraint.constant = AppConstant.ScreenSize.SCREEN_WIDTH - 60
        self.heightLayoutConstraint.constant = self.widthLayoutConstraint.constant
        
//        self.createGradientLayer(customView: self.orderView)
//        self.createGradientLayer(customView: self.walletView)
//        self.createGradientLayer(customView: self.mohiFeedsView)
//        self.createGradientLayer(customView: self.wishlistView)
        
//        self.orderView.layoutIfNeeded()
//        self.walletView.layoutIfNeeded()
//        self.mohiFeedsView.layoutIfNeeded()
//        self.wishlistView.layoutIfNeeded()
    }
    
    //MARK: - Initialize -
    private func initializeTimeline() {
        self.createGradientLayer(customView: self.orderView)
        self.createGradientLayer(customView: self.walletView)
        self.createGradientLayer(customView: self.mohiFeedsView)
        self.createGradientLayer(customView: self.wishlistView)
        
        self.orderView.layer.borderColor = UIColor.lightGray.cgColor
        self.walletView.layer.borderColor = UIColor.lightGray.cgColor
        self.mohiFeedsView.layer.borderColor = UIColor.lightGray.cgColor
        self.wishlistView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func createGradientLayer(customView: UIView) {
        
        if let filterGradientLayers: [CAGradientLayer] = customView.layer.sublayers?.filter({ $0 is CAGradientLayer }) as? [CAGradientLayer] {
            for gradient in filterGradientLayers {
                gradient.removeFromSuperlayer()
            }
        }
        
        let viewWidth: CGFloat = (AppConstant.ScreenSize.SCREEN_WIDTH - 80)/2
        let viewHeight: CGFloat = viewWidth
        
        var gradientBounds: CGRect = CGRect.zero
        gradientBounds.size = CGSize(width: viewWidth, height: viewHeight)
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBounds
        gradientLayer.colors = [UIColor.green.withAlphaComponent(0.4).cgColor, UIColor.blue.withAlphaComponent(0.4).cgColor]
        customView.layer.addSublayer(gradientLayer)
        
        guard let filterLabels: [UILabel] = customView.subviews.filter({ $0 is UILabel }) as? [UILabel] else {
            return
        }
        
        for label in filterLabels {
            customView.bringSubview(toFront: label)
        }
        
        guard let filterButtons: [UIButton] = customView.subviews.filter({ $0 is UIButton }) as? [UIButton] else {
            return
        }
        
        for button in filterButtons {
            customView.bringSubview(toFront: button)
        }
    }

    @IBAction func orderAction(_ sender: AnyObject) {
        print("orderAction")
       let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: YourOrdersVC.nameOfClass) as YourOrdersVC
        self.present(controller, animated: true, completion: nil)
        return
        
        let storyBoard = UIStoryboard(name: "MyAccount", bundle: nil)
        let accountVC = storyBoard.instantiateViewController(withIdentifier: "SlideProfileVC") as! SlideProfileVC
        let accountNavigation: UINavigationController = UINavigationController(rootViewController: accountVC)
        
        accountNavigation.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func walletAction(_ sender: AnyObject) {
        print("walletAction")
    }
    
    @IBAction func mohiFeedsAction(_ sender: AnyObject) {
        print("mohiFeedsAction")
    }
    
    @IBAction func wishlistAction(_ sender: AnyObject) {
        print("wishlistAction")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
