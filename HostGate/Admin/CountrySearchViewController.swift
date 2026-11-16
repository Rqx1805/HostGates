//
//  CountrySearchViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 26/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import GiFHUD_Swift

class CountrySearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    

    //MARK:- IBOutlet
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var countryTableview: UITableView!
    
    var countryArray = NSMutableArray()
    var countryname = NSArray()
    var name:String!
    var searchController: UISearchController?
    var filteredCountries = NSMutableArray()
    
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var dGlocale = DGLocalization()
    
    //MARK:- Login WebService
    @objc func HostGateGetCountryList(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.countryArray.removeAllObjects()
                self.countryTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.countryArray = (notification.userInfo?["country"] as? NSMutableArray)!
                print("response: \(String(describing: self.countryArray))")
                self.countryname = self.countryArray.value(forKey: "name") as! NSArray
                self.countryTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        setUpSearchBar()
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().GetCountryList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetCountryList), name: NSNotification.Name(rawValue: "GetCountryListNotification"), object: nil)
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.title_lbl.text = language == "en" ? "Country List" : "قائمة الدول"
        if language == "en" {
            self.cancel_btn.setTitle("Cancel", for: .normal)
        }else if language == "ar" {
            self.cancel_btn.setTitle("إلغاء", for: .normal)
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredCountries.removeAllObjects()
        
        let text = searchController.searchBar.text!.lowercased()
        
        for country in 0...countryArray.count-1 {
            var dict = NSDictionary()
            dict = countryArray.object(at: country) as! NSDictionary
            var name = String()
            name = dict.value(forKey: "name") as! String
            if name.lowercased().contains(text) {
                
                filteredCountries.add(name)
            }
        }
        
        countryTableview.reloadData()
    }
    
    func setUpSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.countryTableview.tableHeaderView = searchController?.searchBar
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.searchBar.placeholder = "Search"
        self.searchController?.searchResultsUpdater = self
    }
    
    //MARK:- UITableView Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController!.isActive && searchController!.searchBar.text != "" {
            return filteredCountries.count
        }
        return countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCell
        if searchController!.isActive && searchController!.searchBar.text != "" {
            cell.countryNameLbl.text = filteredCountries[indexPath.row] as? String
            return cell
        }
        var dict = NSDictionary()
        dict = countryArray.object(at: indexPath.row) as! NSDictionary
        cell.countryNameLbl.text = dict.value(forKey: "name") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchController?.searchBar.text != "" {
            name = filteredCountries.object(at: indexPath.row) as? String
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: "COUNTRYNAME")
            defaults.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("SelectCountry1"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("ForgotSelectCountry1"), object: nil)
            self.searchController?.isActive = false
            dismiss(animated: true, completion: nil)
        }else{
            var dict = NSDictionary()
            dict = countryArray.object(at: indexPath.row) as! NSDictionary
            self.searchController?.isActive = false
            name = dict.value(forKey: "name") as? String
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: "COUNTRYNAME")
            defaults.synchronize()
            
            self.countryTableview.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name("SelectCountry"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("ForgotSelectCountry"), object: nil)
            dismiss(animated: true, completion: nil)
        }
        
        //}
    }
    @IBAction func cancelBtnActiomn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:-DGLoclalization Delegate
extension CountrySearchViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
