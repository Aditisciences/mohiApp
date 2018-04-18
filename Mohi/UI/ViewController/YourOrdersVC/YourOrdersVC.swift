//
//  YourOrdersVC.swift
//  Mohi
//
//  Created by Consagous on 19/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class YourOrdersVC: BaseViewController {

     @IBOutlet weak var tableView: UITableView!
    
    fileprivate var yourOrderHistoryVC:YourOrderHistoryVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        yourOrderHistoryVC = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Action method implementation
extension YourOrdersVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
}

extension YourOrdersVC: UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyAccountCell.nameOfClass, for: indexPath) as! MyAccountCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let index = indexPath.row
        var title = String()
        var image = UIImage()
        switch index {
        case 0:
            title = "View Your Order history"
            image = UIImage.init(named: "order-history_gray")!
            break
        case 1:
            title = "Downloads"
            image = UIImage.init(named: "download_gray")!
            break
        case 2:
            title = "Your Reward points"
            image = UIImage.init(named: "rewards-points")!
            break
        case 3:
            title = "View Your Return Requests"
            image = UIImage.init(named: "event_gray")!
            break
        case 4:
            title = "Your Transactions"
            image = UIImage.init(named: "transaction_gray")!
            break
        case 5:
            title = "Recurring Payments"
            image = UIImage.init(named: "payments_gray")!
            break
        default:
            break
        }
        cell.btnTextNImage.setImage(image, for: .normal)
        cell.btnTextNImage.setTitle(title, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            yourOrderHistoryVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: YourOrderHistoryVC.nameOfClass)
            self.navigationController?.pushViewController(yourOrderHistoryVC!, animated: true)
            break
        default:
            break
        }
    }
}
