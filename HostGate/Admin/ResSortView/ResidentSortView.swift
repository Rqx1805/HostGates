//
//  ResidentSortView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 02/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ResidentSortView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var dGlocale = DGLocalization()
    
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var sorttabledataview: UITableView!
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?
    var nameArray = [String]()
    class func intitiateFromNib() -> ResidentSortView {
        let View1 = UINib.init(nibName: "ResidentSortView", bundle: nil).instantiate(withOwner: self, options: nil).first as! ResidentSortView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sorttabledataview.delegate = self
        sorttabledataview.dataSource = self
        
        
        let nib = UINib(nibName: "ResSortCell", bundle: nil)
        self.sorttabledataview.register(nib, forCellReuseIdentifier: "cell")
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        let one = language == "en" ? "All" : "الكل"
        let two = language == "en" ? "Pending" : "قيد الانتظار"
        let three = language == "en" ? "Upcoming" : "القادمة"
        let four = language == "en" ? "Past" : "الماضي"
        let fifth = language == "en" ? "Active" : "نشيط"
        let six = language == "en" ? "Expired" : "منتهية الصلاحية"
        let seven = language == "en" ? "Completed" : "منجز"
        let eight = language == "en" ? "Cancelled" : "ألغيت"
        
        nameArray = [one, two, three, four, fifth, six, seven, eight]
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.title_lbl.text = language == "en" ? "Visitor Records" : "سجلات الزوار"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResSortCell
        cell.sortLbl.text = nameArray[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 1 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 2 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 3 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 4 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 5 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 6 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }else {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortRes")
            defaults.synchronize()
            buttonDoneHandler?()
        }
        
        
    }
    
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    
}

//MARK:-DGLoclalization Delegate
extension ResidentSortView:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
