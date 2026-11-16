//
//  ComVisitorsViewController.swift
//  HostGate
//
//  Created by MAC-25 on 13/02/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class ComVisitorsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var startDateTxt: UITextField!
    @IBOutlet weak var endDateTxt: UITextField!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var ExportBtn: UIButton!
    @IBOutlet weak var visitorTableview: UITableView!
    
    var language:String!
    var defaults:UserDefaults!
    var comnunityId:Int!
    var response = NSMutableArray()
    var datepicker :UIDatePicker! = UIDatePicker()
    var datepicker1 :UIDatePicker! = UIDatePicker()
    var dataCheckString = String()
    var imageString = String()
    var roleId:Int!
    var adminuserid:Int!
    var userid:Int!
    var role:Int!
    var deviceTocken = NSString()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    @objc func HostGateGetAllVisListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataCheckString = "DataNotComing"
                self.dataNotFound()
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetAllVisListNotification"), object: nil)
                self.response.removeAllObjects()
                GIFHUD.shared.dismiss()
                self.visitorTableview.reloadData()
                
            }
            else{
                self.dataCheckString = "DataComing"
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                GIFHUD.shared.dismiss()
                self.visitorTableview.reloadData()
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
                self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
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
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        comnunityId = defaults.integer(forKey: "CommunityID")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        userid = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        let spaceEmail1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        startDateTxt.leftViewMode = .always
        startDateTxt.leftView = spaceEmail1
        
        
        let spaceEmail2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        endDateTxt.leftViewMode = .always
        endDateTxt.leftView = spaceEmail2
        
        startDateTxt.clearButtonMode = .always
        endDateTxt.clearButtonMode = .always
        startDateTxt.delegate = self
        datepicker.datePickerMode = UIDatePicker.Mode.date
        startDateTxt.inputView = datepicker
        datepicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        endDateTxt.delegate = self
        datepicker1.datePickerMode = UIDatePicker.Mode.date
        endDateTxt.inputView = datepicker1
        datepicker1.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: UIControl.Event.valueChanged)
        
        

        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateGetAllVisList(CommunityId: comnunityId, StartDate: "", EndDate: "",language:language)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllVisListAction), name: NSNotification.Name(rawValue: "HostGateGetAllVisListNotification"), object: nil)
        
        self.startDateTxt.placeholder = language == "en" ? "Start Date" : "تاريخ البدء"
        self.endDateTxt.placeholder = language == "en" ? "End Date" : "تاريخ الانتهاء"
        self.startDateTxt.textAlignment = language == "en" ? .left : .right
        self.endDateTxt.textAlignment = language == "en" ? .left : .right
        self.filterBtn.setTitle(language == "en" ? "FILTER" : "منقي", for: .normal)
        self.ExportBtn.setTitle(language == "en" ? "EXPORT" : "تصدير", for: .normal)
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: userid, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == startDateTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dateString1 = dateFormatter1.string(from: datepicker.date)
            startDateTxt.text = dateString1
        }else if textField == endDateTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dateString1 = dateFormatter1.string(from: datepicker.date)
            endDateTxt.text = dateString1
        }else {
            
        }
    }
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        if startDateTxt.text == "" && endDateTxt.text == ""{
//            GIFHUD.shared.show(withOverlay: true, duration:15)
//            Parsing().HostGateGetAllVisList(CommunityId: comnunityId, StartDate: "", EndDate: "",language:language)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllVisListAction), name: NSNotification.Name(rawValue: "HostGateGetAllVisListNotification"), object: nil)
//        }
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if startDateTxt.text == "" && endDateTxt.text == ""{
            self.startDateTxt.text = ""
            self.endDateTxt.text = ""
            GIFHUD.shared.show(withOverlay: true, duration:15)
            Parsing().HostGateGetAllVisList(CommunityId: comnunityId, StartDate: "", EndDate: "",language:language)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllVisListAction), name: NSNotification.Name(rawValue: "HostGateGetAllVisListNotification"), object: nil)
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDateTxt.text = dateFormatter.string(from: sender.date)
        
    }
    
    @objc func handleDatePicker1(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        endDateTxt.text = dateFormatter.string(from: sender.date)
        
    }
    
    func dataNotFound(){
        
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.visitorTableview.bounds.size.width, height: self.visitorTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.visitorTableview.backgroundView  = noDataLabel
        self.visitorTableview.separatorStyle  = .none
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
    //            let noDataLabel: UILabel   = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //            noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //        }
    //        return numOfSections
    //    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ComVistCell
        var dict = NSDictionary()
        
        cell.hostNameLbl.text = language == "en" ? "Host Name:" : "اسم المضيف:"
        cell.CreatorLbl.text = language == "en" ? "Creator:" : "المنشئ:"
        cell.typeLb.text = language == "en" ? "Type" : "النوع"
        cell.countLb.text = language == "en" ? "Count" : "العدد"
        cell.dateTimeLb.text = language == "en" ? "Date/Time" : "تاريخ / وقت"
        cell.stsLbl.text = language == "en" ? "Status" : "الحالة"
        
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.nameLbl.text = dict.value(forKey: "created_by") as? String
        cell.meLbl.text = dict.value(forKey: "creator") as? String
        cell.typelbl.text = dict.value(forKey: "visitor_types") as? String
        cell.dateTimeLbl.text = dict.value(forKey: "date_time") as? String
        cell.status.text = dict.value(forKey: "status") as? String
        cell.view_btn_ref.tag = indexPath.row
        cell.view_btn_ref.addTarget(self, action: #selector(ViewBtnAction), for: .touchUpInside)
        var Count = Int()
        Count = dict.value(forKey: "count") as! Int
        var Str = String()
        Str = String(Count)
        cell.vpountLbl.text = Str
        var shoests:String!
        shoests = dict.value(forKey: "status") as? String
        if shoests == "Active" {
            cell.status.textColor = UIColor(red: 80/255, green: 155/255, blue: 90/255, alpha: 1.0)
        }else if shoests == "Cancelled" {
            cell.status.textColor = UIColor.red
        }else if shoests == "Expired" {
            cell.status.textColor = UIColor.yellow
        }else if shoests == "Completed" {
            cell.status.textColor = UIColor(red: 56/255, green: 180/255, blue: 56/255, alpha: 1.0)
        }else if shoests == "Pending" {
            cell.status.textColor = UIColor(red: 228/255, green: 172/255, blue: 88/255, alpha: 1.0)
        }else if shoests == "Upcoming" {
            cell.status.textColor = UIColor.yellow
        }
        else if shoests == "Past" {
            cell.status.textColor = UIColor.yellow
        }
        return cell
    }
    
    
    @objc func ViewBtnAction(sender: UIButton){
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
    
    @IBAction func exportBtnAction(_ sender: Any) {
        GIFHUD.shared.show(withOverlay: true, duration:10)
        if dataCheckString == "DataNotComing"{
            GIFHUD.shared.dismiss()
            GIFHUD.shared.dismiss()
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "No record found." : "لا يوجد سجلات.", buttonTitle: language == "en" ? "OK" : "حسنا")
        }else{
            let fileName = "Visitor_Sheet_120.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            var csvText = "HostName,Creator,Type,Count,Date/Time,Status,ImageURL\n"
            for i in 0...response.count-1 {
                var dict1 = NSDictionary()
                dict1 = response.object(at: i) as! NSDictionary
                
                 var imageAr = NSArray()
                  imageAr = dict1.value(forKey: "images") as! NSArray
                for i in 0..<imageAr.count{
                    if imageString == ""{
                        imageString += "\"" + "\(imageAr[i])" + "\""
                    }else{
                        imageString += "\\" + "\"" + "\(imageAr[i])" + "\""
                    }
                }
                var name:String!
                name = dict1.value(forKey: "name") as? String
                let vc = name.replacingOccurrences(of: ",", with: "")
                print(vc)
                let newLine = "\((vc) ?? ""),\((dict1.value(forKey: "creator")) ?? ""),\((dict1.value(forKey: "visitor_types")) ?? ""),\((dict1.value(forKey: "count")) ?? ""),\((dict1.value(forKey: "date_time")) ?? ""),\((dict1.value(forKey: "status")) ?? ""),\((imageString) ?? "")\n"
                csvText.append(contentsOf: newLine)
            }
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                // let csvData = URL(fileURLWithPath: path!.absoluteString)
                
                let textToShare = "Look at this awesome Iphone App!"
                let objectsToShare = [textToShare, path!] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes =  [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
            GIFHUD.shared.dismiss()
        }
        
    }
    @IBAction func filterBtnAction(_ sender: Any) {
        if startDateTxt.text == ""{
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter start date." : "الرجاء إدخال تاريخ البدء.", buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if endDateTxt.text == ""{
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter end date." : "الرجاء إدخال تاريخ الانتهاء." , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else{
            
                GIFHUD.shared.show(withOverlay: true, duration:10)
                Parsing().HostGateGetAllVisList(CommunityId: comnunityId, StartDate: startDateTxt.text, EndDate: endDateTxt.text, language: language)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllVisListAction), name: NSNotification.Name(rawValue: "HostGateGetAllVisListNotification"), object: nil)
            
        }
    }
}

