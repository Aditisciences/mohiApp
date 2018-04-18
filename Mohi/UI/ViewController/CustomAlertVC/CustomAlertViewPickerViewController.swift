//
//  CustomAlertViewPickerViewController.swift
//  Mohi
//

import Foundation

protocol CustomAlertViewPickerViewControllerDelegate {
    func updatePickerSelection(selectedIndex:Int)
    func selectionCancel()
    func selectionDone(selectedIndex: Int)
}

class CustomAlertViewPickerViewController: BaseViewController{
    var delegate: CustomAlertViewPickerViewControllerDelegate?
    
    @IBOutlet var pickerView:UIPickerView!
    
    var pickerArray:[String] = []
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.datePickerView.datePickerMode = self.pickerMode
//        selectedIndex
        pickerView.showsSelectionIndicator = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //pickerView.selectedRow(inComponent: selectedIndex)
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
    }
}

extension CustomAlertViewPickerViewController{
    @IBAction func cancelButtonAction(_ sender:Any){
        if(delegate != nil){
            delegate?.selectionCancel()
        }
    }
    
    @IBAction func doneButtonAction(_ sender:Any){
        if(delegate != nil){
            delegate?.selectionDone(selectedIndex: selectedIndex)
        }
    }
}

extension CustomAlertViewPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerArray.count
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row)")
        selectedIndex = row
        if(delegate != nil){
            delegate?.updatePickerSelection(selectedIndex: selectedIndex)
        }
    }
}
