//
//  AddReverseVisitorViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class AddReverseVisitorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var selVisitorTypeTxt: UITextField!
    @IBOutlet weak var countTxt: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var nameTxtview: UITextView!
    @IBOutlet weak var sunmit_btn: UIButton!
    @IBOutlet weak var list_lbl_ref: UILabel!
    
    var defaults: UserDefaults!
    var user_Id:Int!
    var communityID:Int!
    var propertyId:Int!
    var properUserIDNew:Int!
    var role:Int!
    var roleId:Int!
    var adminuserid:Int!
    var response = NSMutableArray()
    var str_selvisitor:NSString!
    var str_count:NSString!
    var pickerview: UIPickerView! = UIPickerView()
    var tyepArray = NSMutableArray()
    var idarray = NSArray()
    var nameArray = NSArray()
    var visID:Int!
    var referseControl = UIRefreshControl()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var roleId1:Int!
    var role1:Int!
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateVisitorRecordListByUseridAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorsTypeListbyUserId"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.tyepArray = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.tyepArray))")
                self.nameArray = self.tyepArray.value(forKey: "type") as! NSArray
                self.idarray = self.tyepArray .value(forKey: "visitortype_id") as! NSArray
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    @objc func HostGateReverseVisitorListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
                self.response.removeAllObjects()
                self.listTableView.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.listTableView.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    @objc func HostGateAddReverseVisitorAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddReverseVisitorNotification"), object: nil)
                self.listTableView.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                self.countTxt.text  = ""
                self.selVisitorTypeTxt.text = ""
                self.nameTxtview.text = self.language == "en" ? "Name" : "اسم"
                self.nameTxtview.textColor = .lightGray
                Parsing().HostGateReverseVisitorList(Language: self.language, PropertyId: self.propertyId, UserId: self.user_Id)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReverseVisitorListAction), name: NSNotification.Name(rawValue: "HostGateReverseVisitorListNotification"), object: nil)
//                self.removeAllOverlays()
            }
        }
    }
    
    
    //MARK:- Login WebService
       @objc func HostGateAccountStatusAction(_ notification: Notification) {
           let status = (notification.userInfo?["status"] as? Int)!
           let str_message = (notification.userInfo?["message"] as? String)!
           
           
           DispatchQueue.main.async() {
               
               if status == 0{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                   self.removeAllOverlays()
                   self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
               } else if status == 1{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                   self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                   self.removeAllOverlays()
                GIFHUD.shared.dismiss()
               } else {
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                   let deafults = UserDefaults.standard
                   deafults.set(nil, forKey: "Logoutstatus")
                   deafults.synchronize()
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
                   self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        GIFHUD.shared.setGif(named: "loader.gif")
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        user_Id = defaults.integer(forKey: "UserIDGet")
        communityID = defaults.integer(forKey: "COMNEWID")
        properUserIDNew = defaults.integer(forKey: "PERUSERIDNEW")
        propertyId = defaults.integer(forKey: "PERID")
        roleId = defaults.integer(forKey: "PERUSERID")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "PERROLEID")
        role1 = defaults.integer(forKey: "ROLE")
        roleId1 = defaults.integer(forKey: "RoleId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
//        showWaitOverlay()
        nameTxtview.delegate = self
        self.nameTxtview.textColor = .lightGray
        nameTxtview.text = language == "en" ? "Name/Name's" :  "الأسم/الأسماء"
        self.list_lbl_ref.text = language == "en" ? "List" : "قائمة"
        self.list_lbl_ref.isHidden = true
        if language .isEqual("en") || language .isEqual(""){
            self.nameTxtview.textAlignment = .left
        }else if language .isEqual("ar") {
            self.nameTxtview.textAlignment = .right
        }
        pickerview.delegate = self
        pickerview.dataSource = self
        selVisitorTypeTxt.inputView = pickerview
        countTxt.delegate = self
        selVisitorTypeTxt.delegate = self
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        listTableView.addSubview(referseControl)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorsTypeListbyUserId(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: properUserIDNew, CommunityID: communityID, Role: role)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListByUseridAction), name: NSNotification.Name(rawValue: "HostGateVisitorsTypeListbyUserId"), object: nil)
        
        
        
        Parsing().HostGateReverseVisitorList(Language: language, PropertyId: propertyId, UserId: user_Id)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReverseVisitorListAction), name: NSNotification.Name(rawValue: "HostGateReverseVisitorListNotification"), object: nil)
        
        
        self.sunmit_btn.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId1, DeviceID: deviceId, Role: role1, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.title_lbl.text = language == "en" ? "Add Unexpected Visitor" : "زائر غير متوقع"
        self.selVisitorTypeTxt.placeholder = language == "en" ? "Select Visitor Type" : "اختر نوع الزائر"
        self.countTxt.placeholder = language == "en" ? "Count" : "العدد"
        if language .isEqual("en") || language .isEqual(""){
            self.selVisitorTypeTxt.textAlignment = .left
            self.countTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.selVisitorTypeTxt.textAlignment = .right
            self.countTxt.textAlignment = .right
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        listTableView.reloadData()
        referseControl.endRefreshing()
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateReverseVisitorList(Language: language, PropertyId: propertyId, UserId: user_Id)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReverseVisitorListAction), name: NSNotification.Name(rawValue: "HostGateReverseVisitorListNotification"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        
        
        // Code to refresh table view
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == countTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 5
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }
        else {
            return false
        }
        
        
        
    }
    
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selVisitorTypeTxt {
            if selVisitorTypeTxt.text == "" {
                self.pickerView(pickerview, didSelectRow: 0, inComponent: 0)
            }
        }else {
            
        }
    }
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Name/Name's" || textView.text == "الأسم/الأسماء" {
            textView.text = ""
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        guard range.location == 0 else {
            return true
        }
        let currentString: NSString = (textView.text ?? "Enter Reason") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        return validate1(string: newString)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = language == "en" ? "Name/Name's" : "الأسم/الأسماء"
            if language .isEqual("en") || language .isEqual(""){
                textView.textAlignment = .left
            }else if language .isEqual("ar") {
                textView.textAlignment = .right
            }
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    func validate1(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return nameArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return nameArray[row] as? String
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if nameArray.count == 0 {
            
        }else {
            selVisitorTypeTxt.text = nameArray[row] as? String
            visID = idarray[row] as? Int
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.listTableView.bounds.size.width, height: self.listTableView.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.isHidden = true
        noDataLabel.textColor = UIColor.white
        noDataLabel.textAlignment = .center
        self.listTableView.backgroundView  = noDataLabel
        self.listTableView.separatorStyle  = .none
        
    }
    
    
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if response.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
    //        }
    //        else
    //        {
    //
    //            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //                noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //        }
    //        return numOfSections
    //    }
    
    //MARK:- UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! listCellView
        self.list_lbl_ref.isHidden = false
        cell.type.text = language == "en" ? "Type" : "النوع"
        cell.count.text = language == "en" ? "Count" : "العدد"
        cell.date_time.text = language == "en" ? "Date/Time" : "تاريخ / وقت"
        cell.status.text = language == "en" ? "Status" : "الحالة"
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.typeLbl.text = dict.value(forKey: "visitor_types") as? String
        var count:Int!
        count = dict.value(forKey: "count") as? Int
        var countl = String()
        countl = String(count)
        cell.countLbl.text = countl
        cell.dateTimeLbl.text = dict.value(forKey: "date_time") as? String
        cell.statusLbl.text = dict.value(forKey: "status") as? String
        if cell.statusLbl.text == "Active" {
            cell.statusLbl.textColor = UIColor(red: 80/255, green: 155/255, blue: 90/255, alpha: 1.0)
        }else if cell.statusLbl.text == "Cancelled" {
            cell.statusLbl.textColor = UIColor.red
        }else if cell.statusLbl.text == "Expired" {
            cell.statusLbl.textColor = UIColor.yellow
        }else if cell.statusLbl.text == "Completed" {
            cell.statusLbl.textColor = UIColor(red: 56/255, green: 180/255, blue: 56/255, alpha: 1.0)
        }else if cell.statusLbl.text == "Pending" {
            cell.statusLbl.textColor = UIColor(red: 228/255, green: 172/255, blue: 88/255, alpha: 1.0)
        }else if cell.statusLbl.text == "Upcoming" {
            cell.statusLbl.textColor = UIColor.yellow
        }
        else if cell.statusLbl.text == "Past" {
            cell.statusLbl.textColor = UIColor.yellow
        }
        return cell
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        str_selvisitor = selVisitorTypeTxt.text as NSString?
        str_count = countTxt.text as NSString?
        if str_selvisitor .isEqual(to: ""){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select visitor type." : "يرجى اختيار نوع الزائر." , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if str_count .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter visitor count." : "الرجاء إدخال عدد الزوار." , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:15)
                Parsing().HostGateAddReverseVisitor(Language: language, Count: str_count as String?, PropertyId: propertyId, VisitorTypeID:visID, UserId: user_Id, Name: nameTxtview.text)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddReverseVisitorNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAddReverseVisitorAction), name: NSNotification.Name(rawValue: "HostGateAddReverseVisitorNotification"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
        }
    }
}

//MARK:-DGLoclalization Delegate
extension AddReverseVisitorViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
