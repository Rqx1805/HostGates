//
//  CommunityViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class CommunityViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var communityCollectionView: UICollectionView!
    @IBOutlet weak var communityBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet var community_Main_View: UIView!
    @IBOutlet weak var paging_index_ref: UIPageControl!
    
    var defaults:UserDefaults!
    var UserId:Int!
    var response:NSMutableArray!
    var communityId:Int!
    var myindexpath = NSIndexPath()
    var dict1 = NSDictionary()
    var roleId:Int!
    var adminuserid:Int!
    var user_sts:String!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    //MARK:- Login WebService
    @objc func HostGateGetAllCommunityDataAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
                self.response.removeAllObjects()
                self.communityCollectionView.reloadData()
//                self.removeAllOverlays()
            }
            else{
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                self.UnhideViewLayout()
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.communityCollectionView.reloadData()
//                self.removeAllOverlays()
                
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func HostGateDeleteCommunityDataAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDeleteCommunity"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }else{
                
                //                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                //                print("response: \(String(describing: self.response))")
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                Parsing().HostGateGetAllCommunity(Language: self.language, UserId: self.UserId, RoleId: self.roleId, AdminUserID: self.adminuserid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllCommunityDataAction), name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDeleteCommunity"), object: nil)
                self.communityCollectionView.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        DispatchQueue.main.async() {
            self.hideViewLayout()
//            self.showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:20)
            Parsing().HostGateGetAllCommunity(Language: self.language, UserId: self.UserId, RoleId: self.roleId, AdminUserID: self.adminuserid)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllCommunityDataAction), name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
        }
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: UserId, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
               NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    func hideViewLayout(){
        self.communityCollectionView.isHidden = true
        self.paging_index_ref.isHidden = true
        self.communityBtn.isHidden = true
    }
    
    func UnhideViewLayout(){
        self.communityCollectionView.isHidden = false
        self.paging_index_ref.isHidden = false
        self.communityBtn.isHidden = role == 1 ? true : false
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
        communityCollectionView.delegate = self
        communityCollectionView.dataSource = self
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        language = defaults.value(forKey: "Language") as? String
        UserId = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        user_sts = defaults.value(forKey: "User_Status") as? String
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        let screenWidth = UIScreen.main.bounds.size.width
        //  let screenHeight = UIScreen.main.bounds.size.height
        let LiberaryLayOut = UICollectionViewFlowLayout()
        LiberaryLayOut.itemSize = CGSize(width: screenWidth-16, height: 310)
        LiberaryLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LiberaryLayOut.minimumInteritemSpacing = 0
        LiberaryLayOut.minimumLineSpacing = 0
        LiberaryLayOut.scrollDirection = .horizontal
        
        if role == 1 {
            communityBtn.isHidden = true
        }else if role == 2 {
            
        }else {
            communityBtn.isHidden = false
        }
        
        communityCollectionView.collectionViewLayout = LiberaryLayOut
        response = NSMutableArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("AddCommunityControllerChosen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("UpdateCommunityControllerChosen"), object: nil)
        
    
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
    }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Communities" : "مجتمعات"
        self.communityBtn.setTitle(language == "en" ? "CREATE NEW COMMUNITY" : "خلق مجتمع جديد", for: .normal)
    }
    
    
    @objc func currencyItemChosen(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGetAllCommunity(Language: self.language, UserId: UserId, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllCommunityDataAction), name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGetAllCommunity(Language: self.language, UserId: UserId, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetAllCommunityDataAction), name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: nil)
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.communityCollectionView.bounds.size.width, height: self.communityCollectionView.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.communityCollectionView.backgroundView  = noDataLabel
    }
    
    //MARK:- Collection View Delegate
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        var numOfSections: Int = 0
    //        if response.count>0
    //        {
    //            numOfSections            = 1
    //            collectionView.backgroundView = nil
    //        }
    //        else
    //        {
    //
    //                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
    //                noDataLabel.text          = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //                noDataLabel.textColor     = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    //                noDataLabel.textAlignment = .center
    //                collectionView.backgroundView  = noDataLabel
    //        }
    //        return numOfSections
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        
        paging_index_ref.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paging_index_ref.numberOfPages = response.count
        return response.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AllComminutyCell
        
        if language == "en" {
            cell.ViewUserBtn.setTitle("VIEW USERS", for: .normal)
            
        }else if language == "ar" {
            cell.ViewUserBtn.setTitle("عرض المستخدمين", for: .normal)
        }
        
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.CommunitynameLbl.text = dict.value(forKey: "title") as? String
        cell.communuityAddressLbl.text = dict.value(forKey: "address") as? String
        cell.ResidentelLbl.text = dict.value(forKey: "type") as? String
        
        cell.CommunityLogoImageview.sd_setImage(with: URL(string: (dict.value(forKey: "logo") as? String)!), placeholderImage: UIImage(named: "load_logo"))
        if self.user_sts == "1" {
            cell.editBtn.isHidden = false
            cell.DeleteBtn.isHidden = false

        }else if self.user_sts == "2" && role == 1 {
            cell.editBtn.isHidden = true
            cell.DeleteBtn.isHidden = true
        }
        cell.editBtn.tag = indexPath.row
        cell.DeleteBtn.tag = indexPath.row
        cell.ViewUserBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector((HandlewEdit(_:))), for: .touchUpInside)
        cell.DeleteBtn.addTarget(self, action: #selector((HandlewDelete(_:))), for: .touchUpInside)
        cell.ViewUserBtn.addTarget(self, action: #selector((HandlewViewUser(_:))), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: communityCollectionView.frame.size.width, height: 310)
    }
    
    @objc func HandlewEdit(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: communityCollectionView)
        myindexpath = communityCollectionView.indexPathForItem(at: buttonPosition)! as NSIndexPath
        dict1 = (response.object(at: myindexpath.row) as? NSDictionary)!
        communityId = dict1.value(forKey: "community_id") as? Int
        let defaults = UserDefaults.standard
        defaults.set(communityId, forKey: "CommunityID")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditCommunityViewController") as! EditCommunityViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func HandlewDelete(_ sender: UIButton){
        let myAlert = UIAlertController(title: "HostGates", message: language == "en" ? "Are you sure to delete this community as all assigned users will be deleted?" : "هل أنت متأكد من حذف هذا المجتمع حيث سيتم حذف جميع المستخدمين المعينين؟", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            self.defaults.set("Community_view_Controller", forKey: "Delete_Check")
            let nextview = DeleteCommunityView.intitiateFromNib()
            let model = BackModel()
            nextview.buttonDoneHandler = { (UniqueName) in
                let buttonPosition = sender.convert(CGPoint.zero, to: self.communityCollectionView)
                self.myindexpath = self.communityCollectionView.indexPathForItem(at: buttonPosition)! as NSIndexPath
                self.dict1 = (self.response.object(at: self.myindexpath.row) as? NSDictionary)!
                self.communityId = self.dict1.value(forKey: "community_id") as? Int
                
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateDeleteCommunity(Language: self.language, CommunityId: self.communityId, UniqueName: UniqueName, RoleId: self.roleId)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDeleteCommunity"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDeleteCommunityDataAction), name: NSNotification.Name(rawValue: "HostGateDeleteCommunity"), object: nil)
                model.closewithAnimation()
                
            }
            nextview.buttonCancelHandler = {
                model.closewithAnimation()
            }
            model.show(view: nextview)
            
        })
        // this action can add to more button
        myAlert.addAction(okAction);
        myAlert.addAction(sayhi);
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @objc func HandlewViewUser(_ sender: UIButton){
        
        let defaults = UserDefaults.standard
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        let type = dict.value(forKey: "type") as? String
        let title = dict.value(forKey: "title") as? String
        defaults.set(type, forKey: "community_type")
        defaults.set(title, forKey: "community_name")
        defaults.synchronize()
        
        
        let buttonPosition = sender.convert(CGPoint.zero, to: communityCollectionView)
        myindexpath = communityCollectionView.indexPathForItem(at: buttonPosition)! as NSIndexPath
        dict1 = (response.object(at: myindexpath.row) as? NSDictionary)!
        communityId = dict1.value(forKey: "community_id") as? Int
        defaults.set(communityId, forKey: "CommunityID")
        defaults.synchronize()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCommunityViewController") as! AddCommunityViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createNewCommunityBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNewCommunityViewController") as! CreateNewCommunityViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:-DGLoclalization Delegate
extension CommunityViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
