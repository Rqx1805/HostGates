//
//  SortingView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 10/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SortingView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sortTableview: UITableView!
    
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?
    var nameArray = ["Name(A-Z)","Name(Z-A)","Email(A-Z)","Email(Z-A)"]
    var checkSelectButton = String()
    
    class func intitiateFromNib() -> SortingView {
        let View1 = UINib.init(nibName: "SortingView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SortingView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sortTableview.delegate = self
        sortTableview.dataSource = self
        
        let language = UserDefaults.standard.value(forKey: "Language") as? String
        checkSelectButton = UserDefaults.standard.value(forKey: "CheckSelectedButton") as? String ?? ""
        
        let one = language == "en" ? "Name(A-Z)" : "اسم (A-Z)"
        let two = language == "en" ? "Name(Z-A)" : "اسم (Z-A)"
        let three = language == "en" ? "Email(A-Z)" : "البريد الإلكتروني (A-Z)"
        let four = language == "en" ? "Email(Z-A)" : "البريد الإلكتروني (Z-A)"
        
        nameArray = [one, two, three, four]
        
        
        let nib = UINib(nibName: "SortingCell", bundle: nil)
        self.sortTableview.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SortingCell
        cell.sortLbl.text = nameArray[indexPath.item]
        cell.sortLbl.textColor = checkSelectButton == "\(indexPath.row)" ? UIColor.init(red: 210/255, green: 182/255, blue: 92/255, alpha: 1) : UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set("0", forKey: "CheckSelectedButton")
            defaults.set(sortdata, forKey: "SortData")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 1 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortData")
            defaults.set("1", forKey: "CheckSelectedButton")
            defaults.synchronize()
            buttonDoneHandler?()
        }else if indexPath.row == 2 {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortData")
            defaults.set("2", forKey: "CheckSelectedButton")
            defaults.synchronize()
            buttonDoneHandler?()
        }else {
            var sortdata = String()
            sortdata = nameArray[indexPath.row]
            let defaults = UserDefaults.standard
            defaults.set(sortdata, forKey: "SortData")
            defaults.set("3", forKey: "CheckSelectedButton")
            defaults.synchronize()
            buttonDoneHandler?()
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    
}
