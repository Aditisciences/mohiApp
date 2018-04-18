//
//  MyDeviceFilterModel.swift
//  Mohi
//

import Foundation

enum MyDeviceFilterOptionModelItemType {
    case ShopByBrand
    case Colors
    case Catalog
    case Availability
}

protocol MyDeviceFilterOptionModelItem {
    var type: MyDeviceFilterOptionModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension MyDeviceFilterOptionModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible: Bool {
        return true
    }
}

class MyDeviceFilterOptionModel: NSObject{
    var items = [MyDeviceFilterOptionModelItem]()
    
    var reloadSections: ((_ section: Int) -> Void)?
    
    init(printerNameList:[ShopByBrandModel]?, statusNameList:[ColourModel]?, faultNameList:[Catalog]?) {
        super.init()
        
        let printerList = PrinterNameModelItem(printerList: printerNameList)
        items.append(printerList)
        
        let statusList = StatusNameModelItem(statusOptionList: statusNameList)
        items.append(statusList)
        
        let faultList = FaultNameModelItem(faultOptionList: faultNameList)
        items.append(faultList)
        
//        let lastBackup = las
//        items.append(lastBackup)
    }
}

extension MyDeviceFilterOptionModel: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count + 1 // for last back view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section < 3){
            let item = items[section]
            guard item.isCollapsible else {
                return item.rowCount
            }
            
            if item.isCollapsed {
                return 0
            } else {
                return item.rowCount
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .ShopByBrand:
            if let item = item as? PrinterNameModelItem, let cell = tableView.dequeueReusableCell(withIdentifier: PrinterViewCell.identifier, for: indexPath) as? PrinterViewCell {
                let printerItem = item.printerList?[indexPath.row]
                cell.item = printerItem
                cell.updateCheckStatus(isEnable: (printerItem?.isCheck)!)
                cell.selectionStyle = .none
                return cell
            }
        case .Colors:
            if let item = item as? StatusNameModelItem, let cell = tableView.dequeueReusableCell(withIdentifier: StatusViewCell.identifier, for: indexPath) as? StatusViewCell {
                let statusItem = item.statusOptionList?[indexPath.row]
                cell.item = statusItem
                cell.updateCheckStatus(isEnable: (statusItem?.isCheck)!)
                cell.selectionStyle = .none
                return cell
            }
        case .Catalog:
            if let item = item as? FaultNameModelItem, let cell = tableView.dequeueReusableCell(withIdentifier: FaultViewCell.identifier, for: indexPath) as? FaultViewCell {
                let faultItem = item.faultOptionList?[indexPath.row]
                cell.item = faultItem
                cell.updateCheckStatus(isEnable: (faultItem?.isCheck)!)
                cell.selectionStyle = .none
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
}

extension MyDeviceFilterOptionModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section == 3){
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LastBackView.identifier) as? LastBackView {
                return headerView
            }
        } else {
            
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterHeaderView.identifier) as? FilterHeaderView {
                let item = items[section]
                
                headerView.item = item
                headerView.section = section
                headerView.delegate = self
                headerView.backgroundColor = UIColor.white
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        
//        tableView.beginUpdates()
//        let cell:EditImageDetailTableViewCell? = tableView.cellForRow(at: indexPath) as? EditImageDetailTableViewCell
//        cell?.updateCheckStatus(isEnable: menuItem.isCheck)
//        tableView.endUpdates()
        
        switch item.type {
        case .ShopByBrand:
            if let item = item as? PrinterNameModelItem, let cell = tableView.cellForRow(at: indexPath) as? PrinterViewCell {
                let printerItem = item.printerList?[indexPath.row]
                
                
                if(printerItem?.isCheck)!{
                    printerItem?.isCheck = !(printerItem?.isCheck)!
                    tableView.beginUpdates()
                    cell.updateCheckStatus(isEnable: (printerItem?.isCheck)!)
                    
                }else{
                    tableView.beginUpdates()
                    item.enableSelectionOnIndex(index: indexPath.row)
                    tableView.reloadData()
                }
            }
        case .Colors:
            if let item = item as? StatusNameModelItem, let cell = tableView.cellForRow(at: indexPath) as? StatusViewCell {
                let statusItem = item.statusOptionList?[indexPath.row]
                statusItem?.isCheck = !(statusItem?.isCheck)!
                
                tableView.beginUpdates()
                cell.updateCheckStatus(isEnable: (statusItem?.isCheck)!)
                tableView.endUpdates()
            }
        case .Catalog:
            if let item = item as? FaultNameModelItem, let cell = tableView.cellForRow(at: indexPath) as? FaultViewCell {
                let faultItem = item.faultOptionList?[indexPath.row]
                faultItem?.isCheck = !(faultItem?.isCheck)!
                
                tableView.beginUpdates()
                cell.updateCheckStatus(isEnable: (faultItem?.isCheck)!)
                tableView.endUpdates()
            }
        default: break
        }
    }
}

extension MyDeviceFilterOptionModel: FilterHeaderViewDelegate {
    func toggleSection(header: FilterHeaderView, section: Int) {
        var item = items[section]
        if item.isCollapsible {
            
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            reloadSections?(section)
        }
    }
}


class PrinterNameModelItem: MyDeviceFilterOptionModelItem {
    
    var type: MyDeviceFilterOptionModelItemType {
        return .ShopByBrand
    }
    
    var sectionTitle: String {
        return "Shop By Brand"
    }
    
    var rowCount: Int {
        if(printerList != nil && (printerList?.count)! > 0){
            return printerList!.count
        }else{
            return 0
        }
    }
    
    var isCollapsed = true
    var printerList: [ShopByBrandModel]?
    
    init(printerList: [ShopByBrandModel]?) {
        self.printerList = printerList
    }
    
    func enableSelectionOnIndex(index:Int){
        
        for printer in printerList!{
            printer.isCheck = false
        }
        
        let printer = printerList?[index]
        printer?.isCheck = true
        
    }
}

class StatusNameModelItem: MyDeviceFilterOptionModelItem {
    
    var type: MyDeviceFilterOptionModelItemType {
        return .Colors
    }
    
    var sectionTitle: String {
        return "Colors"
    }
    
    var rowCount: Int {
        if(statusOptionList != nil && (statusOptionList?.count)! > 0){
            return statusOptionList!.count
        }else{
            return 0
        }
    }
    
    var isCollapsed = true
    var statusOptionList: [ColourModel]?
    
    init(statusOptionList: [ColourModel]?) {
        self.statusOptionList = statusOptionList
    }
}

class FaultNameModelItem: MyDeviceFilterOptionModelItem {
    
    var type: MyDeviceFilterOptionModelItemType {
        return .Catalog
    }
    
    var sectionTitle: String {
        return "Catalog"
    }
    
    var rowCount: Int {
        if(faultOptionList != nil && (faultOptionList?.count)! > 0){
            return faultOptionList!.count
        }else{
            return 0
        }
    }
    
    var isCollapsed = true
    var faultOptionList: [Catalog]?
    
    init(faultOptionList: [Catalog]?) {
        self.faultOptionList = faultOptionList
    }
}
