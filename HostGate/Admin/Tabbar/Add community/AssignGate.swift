//
//  AssignGate.swift
//  HostGate
//
//  Created by mac-15 on 28/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class AssignGate: UIView,UITableViewDelegate,UITableViewDataSource {
    var buttonCrossHandler : (() -> Void)?
    var buttonCheckAllHandler : (() -> Void)?
    var buttonAssignHandler : (() -> Void)?
    var GetListDataArray = [Any]()
    var select_type_array = NSMutableArray()
    var newArr = [String]()
    var isClick: Bool = false
    var selectSts:String!
    var sels:String!
    var defaults:UserDefaults!
    var getar = [String]()
    var indexPath = IndexPath()
    var Check = String()
    var count:Int!
    @IBOutlet weak var checkBtn: UIButton!
    class func intitiateFromNib() -> AssignGate {
        let View1 = UINib.init(nibName: "AssignGate", bundle: nil).instantiate(withOwner: self, options: nil).first as! AssignGate
        
        return View1
    }
    
    
    @IBOutlet weak var assign: UIButton!
    @IBOutlet weak var select_all: UILabel!
    @IBOutlet weak var please_assign_gate: UILabel!
    @IBOutlet weak var AssignTblView: UITableView!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        sels = defaults.value(forKey: "SELSTS") as? String
        getar = defaults.value(forKey: "IDar") as! [String]
        let nibClass = UINib(nibName: "AssignTableCell", bundle: nil)
        self.AssignTblView.register(nibClass, forCellReuseIdentifier: "AssignTableCell")
        self.AssignTblView.estimatedRowHeight = 60
        self.AssignTblView.rowHeight = UITableView.automaticDimension
        self.AssignTblView.dataSource = self
        self.AssignTblView.delegate = self
        self.AssignTblView.tableFooterView = UIView()
        self.AssignTblView.sectionHeaderHeight = 0
        self.AssignTblView.separatorStyle = .none
        
        //        if sels == "true"{
        //            CheckAllButtonAction(UIButton())
        //
        //        }else {
        //            isClick = false
        //        }
        
        self.GetAssignListAPI()
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        if language == "en" {
            self.assign.setTitle("DONE", for: .normal)
        }else if language == "ar" {
            self.assign.setTitle("فعله", for: .normal)
        }
        self.select_all.text = language == "en" ? "Select All" : "اختر الكل"
        self.please_assign_gate.text = language == "en" ? "Assign Gate Account" : "تعيين حساب البوابة"
        //        self.select_type_array = self.getar as! NSMutableArray
        //        for i in 0..<getar.count{
        //            self.newArr.append(getar![i] as! String)
        //        }
    }
    
    
    
    func GetAssignListAPI(){
        //self.showWaitOverlay()
        
        let CommunityID = DataManager.getVal(Config().AppUserDefaults.value(forKey: "CommunityID")) as! String
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(CommunityID), forKey: "community_id" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getAllGate"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    self.GetListDataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.AssignTblView.reloadData()
                }else if status == "0"{
                    self.dataNotFound()
                    self.GetListDataArray.removeAll()
                    self.AssignTblView.reloadData()
                    if self.GetListDataArray.count > 0{
                        self.AssignTblView.backgroundView = nil
                    }else{
                        
                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.AssignTblView.frame.size.width, height: self.AssignTblView.frame.size.height))
                        //label.font = Config().AppGlobalFont(14, isBold: false)
                        label.textColor = .white
                        label.textAlignment = .center
                        label.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
                        self.AssignTblView.backgroundView = label
                        
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
                //self.removeAllOverlays()
            })
        }
        
    }
    @IBAction func CrossButtonAction(_ sender: UIButton) {
        if select_type_array.count == 0{
            for i in 0..<getar.count{
                let str = getar[i]
                self.select_type_array.addObjects(from: [str])
                print(self.select_type_array)
                print(getar)
            }
        }
        buttonCrossHandler?()
    }
    
    @IBAction func CheckAllButtonAction(_ sender: UIButton) {
        var news = String()
        Check = ""
        news = "gate"
        let defaults = UserDefaults.standard
        defaults.set(news, forKey: "NEWA")
        defaults.synchronize()
        self.getar.removeAll()
        if (!isClick) {
            isClick = true
            selectSts = "true"
            self.checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
            
                for index in 0..<self.GetListDataArray.count{
                    let dict = DataManager.getVal(self.GetListDataArray[index]) as! [String:Any]
                    let gate_id = DataManager.getVal(dict["gate_id"]) as! String
                    self.select_type_array.add(gate_id)
                    self.getar.append(gate_id)
                }
        }else{
            isClick = false
            self.checkBtn.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
            self.select_type_array.removeAllObjects()
            self.getar.removeAll()
            selectSts = "false"
            buttonCheckAllHandler?()
        }
        
        defaults.set(selectSts, forKey: "SelSts")
        defaults.synchronize()
        self.AssignTblView.reloadData()
        
    }
    
    
    @IBAction func AssignButtonAction(_ sender: UIButton) {
        if select_type_array.count == 0{
            for i in 0..<getar.count{
                let str = getar[i]
                self.select_type_array.addObjects(from: [str])
                print(self.select_type_array)
                print(getar)
            }
        }
        buttonAssignHandler?()
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.AssignTblView.bounds.size.width, height: self.AssignTblView.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.AssignTblView.backgroundView  = noDataLabel
        self.AssignTblView.separatorStyle  = .none
    }
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if GetListDataArray.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
    //            self.checkBtn.isHidden = false
    //
    //        }
    //        else
    //        {
    //
    //            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //            noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //            self.checkBtn.isHidden = true
    //
    //        }
    //        return numOfSections
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.GetListDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignTableCell", for: indexPath) as! AssignTableCell
        let dict = DataManager.getVal(self.GetListDataArray[indexPath.row]) as! NSDictionary
        let gate_name = DataManager.getVal(dict["gate_name"]) as! String
        let gate_id = DataManager.getVal(dict["gate_id"]) as! String
        cell.TitleLbl.text = gate_name
        
        if Check == "equal"{
            if self.select_type_array.contains(gate_id){
                cell.CheckButton.setImage(UIImage(named:"Checkbox"), for: .normal)
            }else{
                cell.CheckButton.setImage(UIImage(named:"ic_check_box_outline_blank_24px"), for: .normal)
            }
        }else{
            if self.select_type_array.contains(gate_id){
                cell.CheckButton.setImage(UIImage(named:"Checkbox"), for: .normal)
            }else{
                if self.getar.contains(gate_id){
                    cell.CheckButton.setImage(UIImage(named:"Checkbox"), for: .normal)
                }else{
                    cell.CheckButton.setImage(UIImage(named:"ic_check_box_outline_blank_24px"), for: .normal)
                }
            }
        }
        if self.getar.count == self.GetListDataArray.count{
            self.checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
        }else{
            self.checkBtn.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.GetListDataArray[indexPath.row]) as! [String: Any]
        let gate_id = DataManager.getVal(dict["gate_id"]) as! String
        //        if self.select_type_array.contains(gate_id){
        //            self.select_type_array.remove(gate_id)
        //            self.checkBtn.setImage(UIImage(named:"ic_check_box_outline_blank_24px"), for: .normal)
        //            self.isClick = false
        //        }else{
        self.select_type_array.removeAllObjects()
        Check = ""
        for i in 0..<getar.count{
            if gate_id == self.getar[i] {
                Check = "equal"
                count = i
            }else{
                
            }
        }
        if Check == "equal"{
            self.getar.remove(at: count)
        }else{
            self.getar.append(gate_id)
        }
        defaults.set("gate", forKey: "NEWA")
        
        
        //            self.select_type_array.addObjects(from: [newArr])
        //            self.isClick = true
        
        //            if select_type_array.count == GetListDataArray.count {
        //                self.checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
        //            }else {
        //                print("Ashish")
        //            }
        for i in 0..<getar.count{
            let str = getar[i]
            self.select_type_array.addObjects(from: [str])
            print(self.select_type_array)
            print(getar)
        }
        
        
        self.AssignTblView.reloadData()
    }
}
