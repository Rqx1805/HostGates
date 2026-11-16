//
//  GateReverseVisitorRecordViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AdSupport
import GiFHUD_Swift

class GateReverseVisitorRecordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var ReverseVisitorRecordTableview: UITableView!
    @IBOutlet weak var searchbarTxt: UISearchBar!
    @IBOutlet weak var dateTxt: UITextField!
    
    var defaults:UserDefaults!
    var propertyId:Int!
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var role:Int!
    var comType:Int!
    var user_Id:Int!
    var communityID:Int!
    var response = NSMutableArray()
    var sortData:String!
    var searchplace = String()
    var datepicker :UIDatePicker! = UIDatePicker()
    var referseControl = UIRefreshControl()
    var noDataLabel = UILabel()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var roleId:Int!
    var adminuserid:Int!
    var deviceTocken = NSString()
    
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateVisitorListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.response.removeAllObjects()
                self.ReverseVisitorRecordTableview.reloadData()
//                self.removeAllOverlays()
                self.dataNotFound()
                self.noDataLabel.isHidden = false
                GIFHUD.shared.dismiss()
            }
            else{
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.ReverseVisitorRecordTableview.reloadData()
                 self.noDataLabel.isHidden = true
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    var searchTextField: UITextField? {
        let subViews = self.searchbarTxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    //MARK:- Login WebService
      @objc func HostGateAccountStatusAction(_ notification: Notification) {
          let status = (notification.userInfo?["status"] as? Int)!
          let str_message = (notification.userInfo?["message"] as? String)!
        
          DispatchQueue.main.async() {
              
              if status == 0{
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                  self.removeAllOverlays()
                  self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
              }
              else if status == 1{
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                  self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                  self.removeAllOverlays()
                GIFHUD.shared.dismiss()
              }else {
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
        
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        self.comType = defaults.integer(forKey: "COMTYPE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        communityID = defaults.integer(forKey: "COMNEWID")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        setupLeftDrawer(self)
        let spaceEmail1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dateTxt.leftViewMode = .always
        dateTxt.leftView = spaceEmail1
        dateTxt.delegate = self
        datepicker.datePickerMode = UIDatePicker.Mode.date
        dateTxt.inputView = datepicker
        // datepicker.maximumDate = Date()
        datepicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        searchbarTxt.delegate = self
        searchbarTxt.setImage(UIImage(), for: .search, state: .normal)
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.SearchPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateTxt.inputAccessoryView = toolBar
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        ReverseVisitorRecordTableview.addSubview(referseControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CheckIn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("CheckOut"), object: nil)
        if #available(iOS 13.0, *) {
            //Vipin
            searchTextField?.placeholder = language == "en" ? "Search..." : "بحث..."
            self.searchTextField?.textAlignment = language == "en" ? NSTextAlignment.right : NSTextAlignment.left
            searchTextField?.textColor = UIColor.white
            searchTextField?.backgroundColor = UIColor.clear
            searchTextField?.borderStyle = .none
            searchTextField?.clearButtonMode = .never
            searchTextField?.inputAccessoryView = searchTextField?.keyboardToolbar
            searchTextField?.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonClicked))
            let items = NSMutableArray()
            items.add(done)
            searchTextField?.keyboardToolbar.items = items as? [UIBarButtonItem]
            
            IQKeyboardManager.shared.enable = true
            searchTextField?.textAlignment = NSTextAlignment.left
        }else {
            let searchfield = self.searchbarTxt.subviews[0].subviews.last as! UITextField
            searchfield.placeholder = language == "en" ? "Search..." : "بحث..."
            searchfield.keyboardType = .asciiCapable
            searchfield.textColor = UIColor.white
            searchfield.backgroundColor = UIColor.clear
            searchfield.borderStyle = .none
            searchfield.clearButtonMode = .never
            searchfield.inputAccessoryView = searchfield.keyboardToolbar
            searchfield.textAlignment = language == "en" ? NSTextAlignment.right : NSTextAlignment.left
            searchfield.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonClicked))
            let items = NSMutableArray()
            items.add(done)
            searchfield.keyboardToolbar.items = items as? [UIBarButtonItem]
            
            IQKeyboardManager.shared.enable = true
            searchfield.textAlignment = NSTextAlignment.left
           // GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        }
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    func dataNotFound(){
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.ReverseVisitorRecordTableview.bounds.size.width, height: self.ReverseVisitorRecordTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.isHidden = true
        noDataLabel.textColor = UIColor.white
        noDataLabel.textAlignment = .center
        self.ReverseVisitorRecordTableview.backgroundView  = noDataLabel
        self.ReverseVisitorRecordTableview.separatorStyle  = .none
        
    }
    
    //MARK:- language Function
    func decorate() {
        self.title_lbl.text = language == "en" ? "Visitors" : "الزائرين"
        dateTxt.placeholder = language == "en" ? "Date(YYYY-MM-DD)" : "التاريخ (YYYY-MM-DD)"
        if language == "en" || language == "" {
            dateTxt.textAlignment = .left
        }else {
            dateTxt.textAlignment = .right
        }
        //            self.next_btn.setTitle("Next".localize, for: .normal)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == dateTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dateString1 = dateFormatter1.string(from: datepicker.date)
            dateTxt.text = dateString1
        }else {
            
        }
    }
    
    @objc func donePicker (sender:UIBarButtonItem)
    {
        self.view.endEditing(true)
        if dateTxt.text == "" {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }else {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: dateTxt.text, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }
        // Put something here
    }
    
    @objc func SearchPicker (sender:UIBarButtonItem)
    {
        self.view.endEditing(true)
        dateTxt.text = ""
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
        // Put something here
    }
    
    @objc func refresh(sender:AnyObject) {
        ReverseVisitorRecordTableview.reloadData()
        referseControl.endRefreshing()
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
        
        
        // Code to refresh table view
    }
    
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
    }
    @objc func currencyItemChosen(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
    }
    @objc func doneButtonClicked(_ sender: Any) {
        view.endEditing(true)
        searchbarTxt.text = ""
        //your code when clicked on done
    }
    //MARK:- Date Button Action
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTxt.text = dateFormatter.string(from: sender.date)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if dateTxt.text == "" {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }else {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: dateTxt.text, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GateReverseVisitorRecordCell
        
        
        cell.unit_no.text = language == "en" ? "Unit/Floor Number:" : "وحدة / رقم الطابق"
        cell.type.text = language == "en" ? "Type:" : "اكتب"
        cell.visitor_count.text = language == "en" ? "Visitor count" : "عدد الزوار"
        cell.date_time.text = language == "en" ? "Date/Time" : "تاريخ / وقت";
        cell.building_no.text = language == "en" ? "Building No." : "رقم المبنى"
        cell.status_lbl_refffff.text = language == "en" ? "Status" : "الحالة"
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        var count = Int()
        count = dict.value(forKey: "count") as! Int
        var countstr = String()
        countstr = String(count)
        cell.countLbl.text = countstr
        cell.pinLbl.text = dict.value(forKey: "unit_number") as? String
        cell.stsLbl.text = dict.value(forKey: "status") as? String
        cell.visTypeLbl.text = dict.value(forKey: "visitor_types") as? String
        cell.dateLbl.text = dict.value(forKey: "date_time") as? String
        cell.timeLbl.text = dict.value(forKey: "building_number") as? String
        cell.visNameLbl.text = dict.value(forKey: "host_name") as? String
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(Handletap(_:)), for: .touchUpInside)
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(Handletap1(_:)), for: .touchUpInside)
        
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(Handletap2(_:)), for: .touchUpInside)
        var shoests:String!
        shoests = dict.value(forKey: "status") as? String
        
        var checkSts:Int!
        checkSts = dict.value(forKey: "check_status") as? Int
        
        
        
        if shoests == "Active" {
            if checkSts == 1 {
                cell.editwidthCons.constant = 0
                cell.viewBtnrightCons.constant = -10
                cell.editBtn.isHidden = true
            }else {
                cell.editwidthCons.constant = 30
                cell.viewBtnrightCons.constant = 16
                cell.editBtn.isHidden = false
            }
            cell.deleteBtn.isHidden = false
            // cell.editBtn.isHidden = false
            // cell.editwidthCons.constant = 30
            cell.deleteWidthCons.constant = 30
            cell.stsLbl.textColor = UIColor(red: 80/255, green: 155/255, blue: 90/255, alpha: 1.0)
        }else if shoests == "Cancelled" {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.editwidthCons.constant = 0
            cell.deleteWidthCons.constant = 0
            cell.stsLbl.textColor = UIColor.red
        }else if shoests == "Expired" {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.editwidthCons.constant = 0
            cell.deleteWidthCons.constant = 0
            cell.stsLbl.textColor = UIColor.yellow
        }else if shoests == "Completed" {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.editwidthCons.constant = 0
            cell.deleteWidthCons.constant = 0
            cell.stsLbl.textColor = UIColor(red: 56/255, green: 180/255, blue: 56/255, alpha: 1.0)
        }else if shoests == "Pending" {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.editwidthCons.constant = 0
            cell.deleteWidthCons.constant = 0
            cell.stsLbl.textColor = UIColor.yellow
        }else if shoests == "Upcoming" {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.editwidthCons.constant = 0
            cell.deleteWidthCons.constant = 0
            cell.stsLbl.textColor = UIColor.yellow
        }
        else if shoests == "Past" {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.editwidthCons.constant = 0
            cell.deleteWidthCons.constant = 0
            cell.stsLbl.textColor = UIColor.yellow
        }
        
        return cell
    }
    
    @objc func Handletap(_ sender: UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        
        var checkSts:Int!
        checkSts = dict.value(forKey: "check_status") as? Int
        if checkSts == 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Visitor Already Check-In." : "زائر بالفعل في الاختيار." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else {
            var vistorid:Int!
            vistorid = dict.value(forKey: "visitor_id") as? Int
            var pincode:String!
            pincode = dict.value(forKey: "pin_code") as? String
            
            let defaults = UserDefaults.standard
            defaults.set(vistorid, forKey: "VISTORID")
            defaults.set(pincode, forKey: "PINCODE")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "GateUpdateRecordViewController") as! GateUpdateRecordViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func Handletap1(_ sender: UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var vistorid:Int!
        vistorid = dict.value(forKey: "visitor_id") as? Int
        var pincode:String!
        pincode = dict.value(forKey: "pin_code") as? String
        
        let defaults = UserDefaults.standard
        defaults.set(vistorid, forKey: "VISTORID")
        defaults.set(pincode, forKey: "PINCODE")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "VisitorCheckOutViewController") as! VisitorCheckOutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func Handletap2(_ sender: UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var vistorid:Int!
        vistorid = dict.value(forKey: "visitor_id") as? Int
        
        
        let defaults = UserDefaults.standard
        defaults.set(vistorid, forKey: "VISTORID")
        defaults.synchronize()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GateVisitorDetailViewController") as! GateVisitorDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchbarTxt.text == "" {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }else {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: searchbarTxt.text, Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        if searchbarTxt.text == "" {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }else {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: searchbarTxt.text, Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }
    }
    
    @IBAction func dateBtnAction(_ sender: Any) {
        if dateTxt.text == "" {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }else {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: language, UserID: user_Id, CommunityID: communityID, Search_Keyword: "", Search_Visitor_date: dateTxt.text, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
            
        }
    }
    
    //MARK:- Logout WebService
    @objc func HostGateLogoutAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
       
        
        DispatchQueue.main.async() {
            
            if status == 1{
             let deafults = UserDefaults.standard
             deafults.set(nil, forKey: "Logoutstatus")
             deafults.synchronize()
             let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
             self.navigationController?.pushViewController(Leaderboard, animated: true)
             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                print("Logout sucessfully.")
            }else {
                print("Somthing went wrong.")
             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
            }
            
        }
    }
    
    @IBAction func sidemenuBtnAction(_ sender: Any) {
        setSideMenu()
    }
    func setSideMenu() {
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
   //MARK: - Left drawer
   func setupLeftDrawer(_ controller: UIViewController) {
       
       self.leftDrawerTransition = DrawerTransition(target: controller, drawer: left)
       self.leftDrawerTransition.setPresentCompletion { print("left present...") }
       self.leftDrawerTransition.setDismissCompletion { print("left dismiss...") }
       self.leftDrawerTransition.edgeType = .left
       
       if user_sts == "1" {
           
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                   //                self.navigationController?.pushViewController(VC, animated: true)
                   
                   self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   })
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  
                  
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 2)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               } else if(indexpath.row == 3)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FreeAccountsViewController") as! FreeAccountsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "VisitorTypeNewViewController") as! VisitorTypeNewViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                 //  self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
                   
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       } else if user_sts == "2" && self.role == 1 {
           
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                   //                    VC.selectedIndex = 2
                   //                    if  VC.selectedIndex < VC.viewControllers!.count {
                   //                        var viewControllers = VC.viewControllers
                   //                        viewControllers?.remove(at:  VC.selectedIndex)
                   //                        VC.viewControllers = viewControllers
                   //                    }
                   //                    VC.selectedIndex = 0
                   self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   })
                   
                   
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 2) {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "VisitorTypeNewViewController") as! VisitorTypeNewViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(VC, animated: true)
                   }
               }else if (indexpath.row == 3) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }
               else if(indexpath.row == 4)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
                   
               else if(indexpath.row == 5)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }else if user_sts == "2" && self.role == 2 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0){
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FinDashboardViewController") as! FinDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 3) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FreeAccountsViewController") as! FreeAccountsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 4) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FinReporingController") as! FinReporingController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 5) {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(VC, animated: true)
                   }
               }else if(indexpath.row == 6){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }else if user_sts == "2" && self.role == 3 {
           
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                   //                self.navigationController?.pushViewController(VC, animated: true)
                   
                   self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   })
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 2)
               {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                     //  self.navigationController?.pushViewController(VC, animated: true)
                   }
               } else if(indexpath.row == 3)
               {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "FreeAccountsViewController") as! FreeAccountsViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                       //self.navigationController?.pushViewController(VC, animated: true)
                   }
               }
               else if(indexpath.row == 4)
               {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "VisitorTypeNewViewController") as! VisitorTypeNewViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(VC, animated: true)
                   }
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
                   
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
       else if user_sts == "3" && self.role == 1 && self.comType == 1 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResSubAccountsViewController") as! ResSubAccountsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 3) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResVisitorRecordsViewController") as! ResVisitorRecordsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPasscardViewController") as! ResidentPasscardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 7){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       } else if user_sts == "3" && self.role == 1 && self.comType == 2 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResVisitorRecordsViewController") as! ResVisitorRecordsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 3)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeePasscardViewController") as! EmployeePasscardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
                   else if(indexpath.row == 7)
                   {
                       let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(Leaderboard, animated: true)
                   }else if(indexpath.row == 8)
                   {
                       let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                       //self.navigationController?.pushViewController(Leaderboard, animated: true)
                   }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
       else if user_sts == "3" && self.role == 2 && comType == 1 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResVisitorRecordsViewController") as! ResVisitorRecordsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 3)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPasscardViewController") as! ResidentPasscardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
       else {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "GateHomeViewController") as! GateHomeViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }
               else if(indexpath.row == 1)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 2)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentListViewController") as! ResidentListViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
                   
               else if(indexpath.row == 3)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "GateReverseVisitorRecordViewController") as! GateReverseVisitorRecordViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else if(indexpath.row == 4)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                             NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
   }
    
    
    
    @IBAction func filterBtnAction(_ sender: Any) {
        let nextview = ResidentSortView.intitiateFromNib()
        let model = PopModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            self.defaults = UserDefaults.standard
            self.sortData = self.defaults.value(forKey: "SortRes") as? String
            //["All","Upcoming","Past","Active","Expired","Completed","Cancelled"]
            var vist:String!
            if self.sortData == "All" {
                vist = ""
            }else if self.sortData == "Pending" {
                vist = "5"
            }
            else if self.sortData == "Upcoming" {
                vist = "upcoming"
            }else if self.sortData == "Past" {
                vist = "past"
            }else if self.sortData == "Active" {
                vist = "1"
            }else if self.sortData == "Expired" {
                vist = "4"
            }else if self.sortData == "Completed" {
                vist = "2"
            }else if self.sortData == "Cancelled"  {
                vist = "3"
            }
            model.closewithAnimation()
//            self.showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateGteVisitorList(Language: self.language, UserID: self.user_Id, CommunityID: self.communityID, Search_Keyword: "", Search_Visitor_date: "", Visitor_Sorting: vist)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorListAction), name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: nil)
        }
        model.show(view: nextview)
    }
    
    
}

//MARK:-DGLoclalization Delegate
extension GateReverseVisitorRecordViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
