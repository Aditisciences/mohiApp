//
//  FilterOptionList.swift
//  Mohi
//
//  Created by Mac on 10/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

enum FilterOptionType{
    case Brand
    case Color
    case Catagory
}

protocol FilterOptionListDelegate{
    func updateOptionList()
}

class FilterOptionList: BaseViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var labelScreenTitle:UILabel!
    
    var optionListData:[APIResponseParam.GetFilterListItems.FilterData]?
    var filterOptionType:FilterOptionType = .Brand
    var delegate:FilterOptionListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelScreenTitle.text = self.title
    }
}

extension FilterOptionList {
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender:Any){
        if(delegate != nil){
            delegate?.updateOptionList()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}

extension FilterOptionList: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return optionListData != nil ? (optionListData?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterOptionListTableViewCell.nameOfClass, for: indexPath) as! FilterOptionListTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        let optionInfo = optionListData![indexPath.row]
        
        cell.updateCellInfo(title: optionInfo.name!, cellIndex: indexPath.row,  colorValue:optionInfo.code,checkBoxStatus: optionInfo.status)
        
        return cell
    }
}

extension FilterOptionList: FilterOptionListTableViewCellDelegate{
    func updateCheckBoxStatus(cellIndex:Int, status:Bool){
        optionListData![cellIndex].status = status
    }
}
