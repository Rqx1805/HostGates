//
//  ResSubAccountsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AdSupport
import GiFHUD_Swift

class ResSubAccountsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var subAccountTableview: UITableView!
    @IBOutlet weak var searchbarTxt: UISearchBar!
    @IBOutlet weak var titlelbl: UILabel!
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user_sts = String()
    var defaults: UserDefaults!
    var role:Int!
    var response = NSMutableArray() 
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var communityID:Int!
    var comType:Int!
    var searchplace = String()
    var referseControl = UIRefreshControl()
    var noDataLabel = UILabel()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateSubAccountListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
                self.response.removeAllObjects()
                self.subAccountTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                 GIFHUD.shared.dismiss()
            }
            else{
                self.noDataLabel.isHidden = true
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.subAccountTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
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
//                self.removeAllOverlays()
                self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
                 GIFHUD.shared.dismiss()
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
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
        
        user_Id = defaults.integer(forKey: "UserIDGet")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        communityID = defaults.integer(forKey: "COMNEWID")
        self.comType = defaults.integer(forKey: "COMTYPE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        subAccountTableview.addSubview(referseControl)
        
        searchbarTxt.delegate = self
        searchbarTxt.setImage(UIImage(), for: .search, state: .normal)
        if #available(iOS 13.0, *) {
            //Vipin
            searchTextField?.placeholder = language == "en" ? "Search(name,email & id)" : "بحث (الاسم والبريد الإلكتروني والمعرّف)"
            self.searchTextField?.textAlignment = language == "en" ? NSTextAlignment.right : NSTextAlignment.left
            searchTextField?.textColor = UIColor.white
            searchTextField?.backgroundColor = UIColor.clear
            searchTextField?.borderStyle = .none
            searchTextField?.clearButtonMode = .never
            searchTextField?.inputAccessoryView = searchTextField?.keyboardToolbar
            searchbarTxt?.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonClicked))
            let items = NSMutableArray()
            items.add(done)
            searchbarTxt?.keyboardToolbar.items = items as? [UIBarButtonItem]
            
            IQKeyboardManager.shared.enable = true
            
            searchTextField?.textAlignment = NSTextAlignment.left
        }else {
            let searchfield = self.searchbarTxt.subviews[0].subviews.last as! UITextField
            searchfield.placeholder = language == "en" ? "Search(name,email & id)" : "بحث (الاسم والبريد الإلكتروني والمعرّف)"
            searchfield.keyboardType = .asciiCapable
            searchfield.textColor = UIColor.white
            searchfield.backgroundColor = UIColor.clear
            searchfield.borderStyle = .none
            searchfield.clearButtonMode = .never
            searchfield.inputAccessoryView = searchfield.keyboardToolbar
            // searchfield.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonClicked))
            let items = NSMutableArray()
            items.add(done)
            searchfield.keyboardToolbar.items = items as? [UIBarButtonItem]
            
            IQKeyboardManager.shared.enable = true
            
            searchfield.textAlignment = NSTextAlignment.left
            
           // GIFHUD.shared.show(withOverlay: true, duration:15)
            Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        }
        
        setupLeftDrawer(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("AddSubAccount"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("UpdateSubAccount"), object: nil)
        

        Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", CommunityID: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
        
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Sub Accounts" : "الحسابات الفرعية"
    }
    
    
    @objc func refresh(sender:AnyObject) {
        subAccountTableview.reloadData()
        referseControl.endRefreshing()
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", CommunityID: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
        
        // Code to refresh table view
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        view.endEditing(true)
        searchbarTxt.text = ""
        //your code when clicked on done
    }
    
    func dataNotFound(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.subAccountTableview.bounds.size.width, height: self.subAccountTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.subAccountTableview.backgroundView  = noDataLabel
        self.subAccountTableview.separatorStyle  = .none
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchbarTxt.text == "" {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", CommunityID: communityID)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: searchbarTxt.text, CommunityID: communityID)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            
        }
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    
    
    
    @IBAction func searchBtnAction(_ sender: Any) {
        searchbarTxt.resignFirstResponder()
        if searchbarTxt.text == "" {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", CommunityID: communityID)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: searchbarTxt.text, CommunityID: communityID)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            
        }
    }
    
    
    @objc func currencyItemChosen(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", CommunityID: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
        
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubaccountList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", CommunityID: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResSubAccountCell
        
        
        cell.id.text = language == "en" ? "Id No." : "هوية شخصية"
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.memberNameLbl.text = dict.value(forKey: "name") as? String
        cell.emailLbl.text = dict.value(forKey: "email") as? String
        cell.idNoLbl.text = dict.value(forKey: "id_number") as? String
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(handleTap1(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleTap(_ sender: UIButton){
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var subid = Int()
        subid = dict.value(forKey: "subaccount_id") as! Int
        var str = String()
        str = "edit"
        let defaults = UserDefaults.standard
        defaults.set(subid, forKey: "SUBID")
        defaults.set(str, forKey: "SUBEDIT")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddResSubAccountViewController") as! AddResSubAccountViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func handleTap1(_ sender: UIButton){
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var subid = Int()
        subid = dict.value(forKey: "subaccount_id") as! Int
        let myAlert = UIAlertController(title: "HostGates", message: language == "en" ? "Are you sure to delete this user?" : "هل أنت متأكد من حذف هذا المستخدم.", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            self.defaults.set("ResSubAccountsViewController", forKey: "Community_view_Controller")
            let nextview = DeleteCommunityView.intitiateFromNib()
            let model = BackModel()
            
            nextview.buttonDoneHandler = { (UniqueName) in
                
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:10)
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setValue(DataManager.getVal(subid) as! String, forKey: "subaccount_id")
                parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                parameterDictionary.setValue(DataManager.getVal("en") as! String, forKey: "language")
                print(parameterDictionary)
                
                let methodName = "deleteSubaccount"
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            GIFHUD.shared.dismiss()
                            self.showAlertAdd(message: message)
                        }else{
                            GIFHUD.shared.dismiss()
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                            
                        }
                        GIFHUD.shared.dismiss()
                    })
                }
                model.closewithAnimation()
                
            }
            nextview.buttonCancelHandler = {
                model.closewithAnimation()
            }
            model.show(view: nextview)
            
        })
        myAlert.addAction(okAction);
        myAlert.addAction(sayhi);
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func showAlertAdd(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            GIFHUD.shared.show(withOverlay: true, duration:15)
            Parsing().HostGateSubaccountList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid, SearchKeyword: "", CommunityID: self.communityID)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccountListAction), name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: nil)
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        var str = String()
        str = "add"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "SUBEDIT")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddResSubAccountViewController") as! AddResSubAccountViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:-DGLoclalization Delegate
extension ResSubAccountsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
