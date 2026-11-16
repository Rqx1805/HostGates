//
//  UserDashboardViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 25/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class UserDashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlet
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var buildingNumberLbl: UILabel!
    @IBOutlet weak var unlitNumberLbl: UILabel!
    @IBOutlet weak var visitorTableview: UITableView!
    @IBOutlet weak var comnutynameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var unit_no: UILabel!
    @IBOutlet weak var gate: UILabel!
    @IBOutlet weak var address_lbl_ref: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var buliding_no_lbl_ref: UILabel!
    @IBOutlet weak var building_no_lbl: UILabel!
    @IBOutlet weak var address_image_view_ref: UIImageView!
    @IBOutlet weak var country_image_view_ref: UIImageView!
    @IBOutlet weak var building_image_view_ref: UIImageView!
    @IBOutlet weak var unit_floor_image_view_ref: UIImageView!
    
    
    
    var arb = ""
    var eng = ""
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var defaults: UserDefaults!
    var user_Id:Int!
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    var username:String!
    var str = String()
    var community = NSDictionary()
    var userdetail = NSDictionary()
    var updateImage:String!
    var updateImage1:String!
    var gateArray = NSMutableArray()
    var comType:Int!
    var email:String!
    var phone:String!
    var countrycode:String!
    var referseControl = UIRefreshControl()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
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
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
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
    
    //MARK:- ForgotPasswordStudent WebService
    @objc func HostGateDashboard(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            
            if status == 0{
                self.dataNotFound()
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                self.community = response.value(forKey: "comunity_detail") as! NSDictionary
                self.address_lbl.text = self.community.value(forKey: "address") as? String
                self.address_lbl_ref.text = self.language == "en" ? "Address  " : "عنوان  "
                self.countryLbl.text = self.community.value(forKey: "country") as? String
                self.updateImage =  self.community.value(forKey: "logo") as? String
                self.comnutynameLbl.text =  self.community.value(forKey: "title") as? String
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.image1.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                self.userdetail = response.value(forKey: "user_detail") as! NSDictionary
                self.buliding_no_lbl_ref.text = self.language == "en" ? "Building Number" : "رقم المبنى"
                self.building_no_lbl.text = self.userdetail.value(forKey: "building_number") as? String
                self.unlitNumberLbl.text = self.userdetail.value(forKey: "unit_number") as? String
                self.updateImage1 =  self.userdetail.value(forKey: "profile_picture") as? String
                self.email =  self.userdetail.value(forKey: "email") as? String
                self.phone =  self.userdetail.value(forKey: "phone") as? String
                self.countrycode = self.userdetail.value(forKey: "country_code") as? String
                self.usernameLbl.text =  self.userdetail.value(forKey: "full_name") as? String
                let AddPicture_url1: NSURL = NSURL(string: self.updateImage1)!
                self.image2.sd_setImage(with: AddPicture_url1 as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                var str = String()
                str = self.userdetail.value(forKey: "full_name") as! String
                var str1 = String()
                str1 = self.userdetail.value(forKey: "username") as! String
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "Name")
                defaults.set(str1, forKey: "USer")
                defaults.set(self.email, forKey: "EMAILADDRESS")
                defaults.set(self.phone, forKey: "PHONENumber")
                defaults.set(self.comnutynameLbl.text, forKey: "TITLE")
                defaults.set(self.countrycode, forKey: "CountryCode")
                defaults.set(self.updateImage1, forKey: "Image")
                defaults.synchronize()
                self.gateArray = response.value(forKey: "gate_list") as! NSMutableArray
                self.visitorTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        //CheckUser.....
        let CheckSting = defaults.value(forKey: "Check_User_For_Support_Condition")as? String
        if CheckSting == "1"{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle , message: self.language == "en" ? "Your account is expired! So please contact to Admin!!" : "انتهت صلاحية حسابك! لذا يرجى الاتصال على الادارية!", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
        }
        
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        self.role = defaults.integer(forKey: "ROLE")
        user_sts = defaults.value(forKey: "User_Status") as! String
        self.comType = defaults.integer(forKey: "COMTYPE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        setupLeftDrawer(self)
        
        self.address_image_view_ref.layer.cornerRadius = 4
        self.address_image_view_ref.clipsToBounds = true
        self.country_image_view_ref.layer.cornerRadius = 4
        self.country_image_view_ref.clipsToBounds = true
        self.building_image_view_ref.layer.cornerRadius = 4
        self.building_image_view_ref.clipsToBounds = true
        self.unit_floor_image_view_ref.layer.cornerRadius = 4
        self.unit_floor_image_view_ref.clipsToBounds = true
        
        image1.layer.cornerRadius = image1.frame.height/2
        image1.layer.masksToBounds = true
        image1.clipsToBounds = true
        
        image2.layer.cornerRadius = image2.frame.height/2
        image2.layer.masksToBounds = true
        image2.clipsToBounds = true
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        visitorTableview.addSubview(referseControl)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateDashboard1(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDashboard), name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: nil)
        
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
            
        }
        
       // GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Dashboard" : "لوحة القيادة"
        self.country.text = language == "en" ? "Country" : "بلد"
        self.unit_no.text = language == "en" ? "Unit & Floor No." : "رقم الوحدة والطابق"
        self.gate.text = language == "en" ? "Gate" : "بوابة"
    }
    
    @objc func refresh(sender:AnyObject) {
        visitorTableview.reloadData()
        referseControl.endRefreshing()
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateDashboard1(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDashboard), name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: nil)
        // Code to refresh table view
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.visitorTableview.bounds.size.width, height: self.visitorTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.visitorTableview.backgroundView  = noDataLabel
        self.visitorTableview.separatorStyle  = .none
    }
    
    //    //MARK:- UITableView Delegate
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if gateArray.count>0
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
    
    
    //MARK:- UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserDashVisitoCell
        
        cell.name.text = language == "en" ? "Name" : "اسم"
        cell.number.text = language == "en" ? "Number" : "رقم"
        
        var dict = NSDictionary()
        dict = gateArray.object(at: indexPath.row) as! NSDictionary
        cell.nameLbl.text = dict.value(forKey: "name") as? String
        cell.numberLbl.text =  dict.value(forKey: "number") as? String
        
        return cell
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
    
    @IBAction func sideMenuBtn(_ sender: Any) {
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
}

//MARK:-DGLoclalization Delegate
extension UserDashboardViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
