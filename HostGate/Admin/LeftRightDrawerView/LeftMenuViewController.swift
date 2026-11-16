//
//  LeftMenuViewController.swift
//  AssanUser
//
//  Created by Sensu Soft on 31/07/17.
//  Copyright © 2017 Sensussoft. All rights reserved.
//

import UIKit
let KEY_SIDEMENU_IMAGE = "SIDEMENU_IMAGE"
let KEY_SIDEMENU_ITEM = "SIDEMENU_ITEM"
let KEY_SIDEMENU_SELECTED = "KEY_SIDEMENU_SELECTED"

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
   
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var milesSlider: UISlider!
    
   // @IBOutlet weak var viewRatting: HCSStarRatingView!
    @IBOutlet weak var lblRatting: UILabel!
    
    @IBOutlet weak var stepperControl: UIStepper!
    
    @IBOutlet weak var viewTopHeader: UIView!
    
    
    var arrListMenu = [[String: AnyObject]]()
    typealias CompletionBlock = (IndexPath) -> Void
    var menuClickBlock : CompletionBlock!
    var leftDrawerTransition:DrawerTransition!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dicAchivementTotal : [String : AnyObject]!
    
    var role_id:Int!
    
    var data = false
    var nameArray = NSMutableArray()
    var imageArray = NSMutableArray()
    var isFirstTimeReload = Bool()
    var defaults:UserDefaults!
    var userstatus:String!
    var language:String!
    var flag_Arabic : NSString!
    var user_sts = String()
  
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
     let currentLanguageBundle = Bundle(path: Bundle.main.path(forResource: NSLocale.preferredLanguages[0], ofType: "lproj") ?? "")
    var role:Int!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    var username:String!
    var updateImage:String!
    var Name:String!
     var comType:Int!
    
    //MARK:- Create Variable for language localizations
    var dGlocale = DGLocalization()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
       
    }
    
    @IBAction func profileBtnAction(_ sender: Any) {
        if user_sts == "1" {
//            self.window = UIWindow(frame:UIScreen.main.bounds)
//            self.nav = UIStoryboard(name: "Main", bundle: nil)
//            let navigate = self.nav.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
//            self.navController = UINavigationController(rootViewController: navigate)
//            self.window?.rootViewController = self.navController
//            navigate.navigationController?.navigationBar.isHidden = true
//            self.window?.makeKeyAndVisible()
          
        }else if user_sts == "2" {
//            self.window = UIWindow(frame:UIScreen.main.bounds)
//            self.nav = UIStoryboard(name: "Main", bundle: nil)
//            let navigate = self.nav.instantiateViewController(withIdentifier: "ResidentMyProfileViewController") as! ResidentMyProfileViewController
//            self.navController = UINavigationController(rootViewController: navigate)
//            self.window?.rootViewController = self.navController
//            navigate.navigationController?.navigationBar.isHidden = true
//            self.window?.makeKeyAndVisible()
          
        }else if user_sts == "3" {
//            self.window = UIWindow(frame:UIScreen.main.bounds)
//            self.nav = UIStoryboard(name: "Main", bundle: nil)
//            let navigate = self.nav.instantiateViewController(withIdentifier: "ResSubMyProfileViewController") as! ResSubMyProfileViewController
//            self.navController = UINavigationController(rootViewController: navigate)
//            self.window?.rootViewController = self.navController
//            navigate.navigationController?.navigationBar.isHidden = true
//            self.window?.makeKeyAndVisible()
           
        }else {
//            self.window = UIWindow(frame:UIScreen.main.bounds)
//            self.nav = UIStoryboard(name: "Main", bundle: nil)
//            let navigate = self.nav.instantiateViewController(withIdentifier: "GateCommunityProfileViewController") as! GateCommunityProfileViewController
//            self.navController = UINavigationController(rootViewController: navigate)
//            self.window?.rootViewController = self.navController
//            navigate.navigationController?.navigationBar.isHidden = true
//            self.window?.makeKeyAndVisible()
          
        }
    }
    
    @objc func refreshtable(_ userInfo: Notification?) {
      
        self.tblView.reloadData()
        
    }
    
    func doSetupUI() {
        
        tblView.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "cell")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView()
        
    }
    
   
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshtable(_:)), name: NSNotification.Name("RefreshTable"), object: nil)
        
        defaults = UserDefaults.standard
        user_sts = defaults.value(forKey: "User_Status") as! String
        self.comType = defaults.integer(forKey: "COMTYPE")
        self.role = defaults.integer(forKey: "ROLE")
        Name = defaults.value(forKey: "Name") as? String
        username = defaults.value(forKey: "USer") as? String
        updateImage = defaults.value(forKey: "Image") as? String
        if updateImage != nil{
            let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
            profileImageView.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "load_logo"))
        }else {
            profileImageView.image = UIImage(named: "load_logo")
        }
        if user_sts == "1" {
            if username == nil {
                self.NameLbl.text = language == "en" ? "User" : "المستعمل"
            }else {
                self.NameLbl.text = Name
            }
        }
            //        else  if user_sts == "2" {
            //            if Name == nil {
            //                self.NameLbl.text = "User"
            //            }else {
            //                self.NameLbl.text = Name
            //            }
            //        }
        else  if user_sts == "2" && comType == 1 {
            if username == nil {
                self.NameLbl.text = language == "en" ? "User" : "المستعمل"
            }else {
                self.NameLbl.text = Name
            }
        }   else  if user_sts == "2" && comType == 2 {
                 if username == nil {
                     self.NameLbl.text = language == "en" ? "User" : "المستعمل"
                 }else {
                     self.NameLbl.text = Name
                 }
             }
        else  if user_sts == "2" && comType == 0 {
            if username == nil {
                self.NameLbl.text = language == "en" ? "User" : "المستعمل"
            }else {
                self.NameLbl.text = Name
            }
        }
        else if user_sts == "3" {
            if username == nil {
                self.NameLbl.text = language == "en" ? "User" : "المستعمل"
            }else {
                self.NameLbl.text = Name
            }
        }else if user_sts == "4" {
            if username == nil {
                self.NameLbl.text = language == "en" ? "User" : "المستعمل"
            }else {
                self.NameLbl.text = username
            }
        }
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        nameArray = NSMutableArray()
        imageArray = NSMutableArray()
        
        let DashBoard = language == "en" ? "DASHBOARD" : "لوحة القيادة"
        let MyProfile = language == "en" ? "MY PROFILE" : "ملفي"
        let SUBSCRIPTIONS = language == "en" ? "SUBSCRIPTION" : "الاشتراكات"
        let FREEACCOUNTS = language == "en" ? "FREE ACCOUNTS" : "حسابات مجانية"
        let VISITORTYPES = language == "en" ? "VISITOR TYPES" : "أنواع الزوار"
        let LANGUAGE = language == "en" ? "LANGUAGE" : "لغة"
        let CREATESUPPORTTICKET = language == "en" ? "SUPPORT TICKET" : "بطاقة الدعم"
        let ABOUTUS = language == "en" ? "ABOUT US" : "معلومات عنا"
        let LOGOUT = language == "en" ? "LOGOUT" : "تسجيل خروج"
        let VISITORS = language == "en" ? "VISITORS" : "الزائرين"
//        let HOSTPASS = language == "en" ? "HOST PASS" : "مضيف مرور"
        let PASSCARDS = language == "en" ? "PASS CARDS" : "بطاقات المرور"
        let USERS = language == "en" ? "USERS" : "المستخدمين"
        let SUBACCOUNT = language == "en" ? "SUB ACCOUNTS" : "حسابات فرعية"
        let TERMCondition = language == "en" ? "TERMS & CONDITIONS" : "الشروط و الأحكام"
        let privacy = language == "en" ? "PRIVACY POLICY" : "سياسة الخصوصية"
        let reports = language == "en" ? "REPORTS" : "تقارير"
        if user_sts == "1" {
            nameArray = [DashBoard, MyProfile, SUBSCRIPTIONS, FREEACCOUNTS, VISITORTYPES, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "Subscription")!,UIImage(named: "Subscription")!,UIImage(named: "visitor_type")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else if user_sts == "2" && role == 1 {
            nameArray = [DashBoard, MyProfile, VISITORTYPES, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "visitor_type")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else if user_sts == "2" && role == 2 {
            UserDefaults.standard.set("ReportBackBtnComes", forKey: "ReportBackBtnComes")
            nameArray = [DashBoard, MyProfile, SUBSCRIPTIONS, FREEACCOUNTS, reports, LANGUAGE,  CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "Subscription")!,UIImage(named: "Subscription")!,UIImage(named: "Reporting-1")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else if user_sts == "2" && role == 3  {
            nameArray = [DashBoard, MyProfile, SUBSCRIPTIONS, FREEACCOUNTS, VISITORTYPES, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "Subscription")!,UIImage(named: "Subscription")!,UIImage(named: "visitor_type")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else if user_sts == "3" && role == 1 && comType == 1 {
            nameArray = [DashBoard, MyProfile, SUBACCOUNT, VISITORS, PASSCARDS, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "visitor_type")!,UIImage(named: "visitor_type")!,UIImage(named: "Profile")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else if user_sts == "3" && role == 1 && comType == 2 {
            nameArray = [DashBoard, MyProfile, VISITORS, PASSCARDS, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "visitor_type")!,UIImage(named: "Profile")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else if user_sts == "3" && role == 2 && comType == 1 {
            nameArray = [DashBoard, MyProfile, VISITORS, PASSCARDS, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "visitor_type")!,UIImage(named: "Profile")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        } else {
            nameArray = [DashBoard, MyProfile, USERS, VISITORS, LANGUAGE, CREATESUPPORTTICKET, ABOUTUS, TERMCondition, privacy, LOGOUT]
            imageArray = [UIImage(named: "dashboard-1")!,UIImage(named: "Profile")!,UIImage(named: "visitor_type")!,UIImage(named: "visitor_type")!,UIImage(named: "language")!,UIImage(named: "ticket")!,UIImage(named: "About Us")!,UIImage(named: "Terms & Conditions")!,UIImage(named: "Privacy & Policy")!,UIImage(named: "Logout")!]
        }
        
        
        doSetupUI()
      tblView.reloadData()
       
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        doSetupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doSetupUI()
        
    }
    
    func clickCellEvent(completion : @escaping CompletionBlock)  {
        
        menuClickBlock = completion
    }

    
}

extension LeftMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        data ? (count = nameArray.count) : (count = imageArray.count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SideMenuCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideMenuCell;
        cell.imgIcon.image = imageArray[indexPath.row] as? UIImage
        cell.lblItem.text = nameArray[indexPath.item] as? String
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        for i in 0 ..< self.arrListMenu.count
        {
            if(i==indexPath.row)
            {
                self.arrListMenu[i]["is_selected"] = "true" as AnyObject
            }
            else
            {
                self.arrListMenu[i]["is_selected"] = "false" as AnyObject
            }
            self.tblView.reloadData()
        }
        
        menuClickBlock(indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
}

extension LeftMenuViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
