//
//  MyDeviceFilterOptionViewController.swift
//  Mohi
//

import Foundation

class MyDeviceFilterOptionViewController: BaseViewController{
    
//    fileprivate var hamburgerViewController = HamburgerViewController.sharedInstance

    fileprivate var filterList:[APIResponseParam.GetFilterListItems] = []
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var myDeviceFilterOptionModel:MyDeviceFilterOptionModel?
    
    override func viewDidLoad() {
        prepare()
    }
}

//MARK:- Fileprivate method implementation
extension MyDeviceFilterOptionViewController{
    fileprivate func prepare(){
        
        //        viewModel.reloadSections = { [weak self] (section: Int) in
        //            self?.tableView?.beginUpdates()
        //            self?.tableView?.reloadSections([section], with: .fade)
        //            self?.tableView?.endUpdates()
        //        }
        
        var printerList:[ShopByBrandModel] = []
        var printerNameModel = ShopByBrandModel()
        printerNameModel.name = "A to Z"
        printerList.append(printerNameModel)
        
        printerNameModel = ShopByBrandModel()
        printerNameModel.name = "Z to A"
        printerList.append(printerNameModel)
        
        var statusList:[ColourModel] = []
        var statusNameModel = ColourModel()
        statusNameModel.name = "Ready For Activation"
        statusList.append(statusNameModel)
        
        statusNameModel = ColourModel()
        statusNameModel.name = "Active"
        statusList.append(statusNameModel)
        
        statusNameModel = ColourModel()
        statusNameModel.name = "Deactivated"
        statusList.append(statusNameModel)
        
        statusNameModel = ColourModel()
        statusNameModel.name = "Unsold"
        statusList.append(statusNameModel)
        
        statusNameModel = ColourModel()
        statusNameModel.name = "Return"
        statusList.append(statusNameModel)
        
        var faultList:[Catalog] = []
        var faultNameModel = Catalog()
        faultNameModel.name = "No Ink"
        faultList.append(faultNameModel)
        
        faultNameModel = Catalog()
        faultNameModel.name = "Low Ink"
        faultList.append(faultNameModel)
        
        faultNameModel = Catalog()
        faultNameModel.name = "Out of Ink"
        faultList.append(faultNameModel)
        
        faultNameModel = Catalog()
        faultNameModel.name = "Miscellaneous Device Fault"
        faultList.append(faultNameModel)
        
        faultNameModel = Catalog()
        faultNameModel.name = "Firmware Update Required"
        faultList.append(faultNameModel)
        
        myDeviceFilterOptionModel = MyDeviceFilterOptionModel(printerNameList: printerList, statusNameList: statusList, faultNameList: faultList)
        
        
        myDeviceFilterOptionModel?.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
        
        //tableView?.estimatedRowHeight = 100
        tableView?.estimatedRowHeight = 40
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.sectionHeaderHeight = 40
        tableView?.separatorStyle = .none
        tableView?.dataSource = myDeviceFilterOptionModel
        tableView?.delegate = myDeviceFilterOptionModel
        
        tableView?.register(PrinterViewCell.nib, forCellReuseIdentifier: PrinterViewCell.identifier)
        tableView?.register(StatusViewCell.nib, forCellReuseIdentifier: StatusViewCell.identifier)
        tableView?.register(FaultViewCell.nib, forCellReuseIdentifier: FaultViewCell.identifier)
        
        tableView?.register(FilterHeaderView.nib, forHeaderFooterViewReuseIdentifier: FilterHeaderView.identifier)
        
        tableView.register(LastBackView.nib, forHeaderFooterViewReuseIdentifier: LastBackView.identifier)
    }
}
//
//extension MyDeviceFilterOptionViewController {
//
//    @IBAction func buttonHamburgerAction(_ sender:UIButton){
//        if !BaseApp.sharedInstance.isTooEarlyMultipleClicks(sender) {
//            var rcFrame = hamburgerViewController.view.frame
//            var isMenuDisplay = true
//            if rcFrame.origin.x < 0 {
//                isMenuDisplay = false
//            }
//
//            if isMenuDisplay {
//                hamburgerViewController.view.isHidden = false
//                rcFrame.origin.x -= rcFrame.size.width
//                hamburgerViewController.view.frame = rcFrame
//            }else{
//                hamburgerViewController.view.isHidden = false
//                rcFrame.origin.x = 0
//                hamburgerViewController.view.frame = rcFrame
//            }
//        }
//    }
//}

