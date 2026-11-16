//
//  DeleteCommunityView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 17/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class DeleteCommunityView: UIView {
    

    @IBOutlet weak var yesbtn: UIButton!
    @IBOutlet weak var note_lbl: UILabel!
    @IBOutlet weak var delete_user_lbl: UILabel!
    
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : ((_ UniqueName : String) -> Void)?
    
    @IBOutlet weak var UniqueNameTxt: UITextField!
    var str_uniquename:NSString!
    @IBOutlet weak var TXTview: UIView!
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var deleteCheck: String!
    
    class func intitiateFromNib() -> DeleteCommunityView {
        let View1 = UINib.init(nibName: "DeleteCommunityView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DeleteCommunityView
        
        
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        TXTview.layer.cornerRadius = 5
        TXTview.layer.borderColor = UIColor(red: 22/255, green: 34/255, blue: 52/255, alpha: 1).cgColor
        TXTview.layer.borderWidth = 1
        yesbtn.layer.cornerRadius = 5
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        deleteCheck = defaults.value(forKey: "Delete_Check") as? String  
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if self.language == "en" {
                self.yesbtn.setTitle("DELETE", for: .normal)
                self.UniqueNameTxt.textAlignment = .left
                
            }else if self.language == "ar" {
                self.yesbtn.setTitle("حذف", for: .normal)
                self.UniqueNameTxt.textAlignment = .right
            }
            self.UniqueNameTxt.placeholder = self.language == "en" ? "Username" : "اسم المستخدم"
            
            if self.deleteCheck == "User_Account_View_Controller"{
                self.delete_user_lbl.text = self.language == "en" ? "Delete User" : "مسح المستخدم"
                self.note_lbl.text = self.language == "en" ? "Note :: Please enter the username to delete the user." : "ملاحظة :: الرجاء إدخال اسم المستخدم لحذف المستخدم."
            }else if self.deleteCheck == "Community_view_Controller"{
                self.delete_user_lbl.text = self.language == "en" ? "Delete Community" : "حذف المجتمع"
                self.note_lbl.text = self.language == "en" ? "Note :: Please enter the unique name to delete the community." : "ملاحظة :: الرجاء إدخال الاسم الفريد لحذف المجتمع."
                self.UniqueNameTxt.placeholder = self.language == "en" ? "Unique Name" : "اسم فريد"
            }else if self.deleteCheck == "Gate_Account_View_Controller"{
                self.delete_user_lbl.text = self.language == "en" ? "Delete Gate" : "حذف بوابة"
                self.note_lbl.text = self.language == "en" ? "Note :: Please enter the username to delete the gate." : "ملاحظة :: الرجاء إدخال اسم المستخدم لحذف البوابة."
            }else if self.deleteCheck == "Admin_Account_View_Controller"{
                self.delete_user_lbl.text = self.language == "en" ? "Delete Staff" : "حذف الموظفين"
                self.note_lbl.text = self.language == "en" ? "Note :: Please enter the username to delete the staff." : "ملاحظة :: الرجاء إدخال اسم المستخدم لحذف الموظفين."
            }else if self.deleteCheck == "ResSubAccountsViewController"{
                self.delete_user_lbl.text = self.language == "en" ? "Delete User" : "مسح المستخدم"
                self.note_lbl.text = self.language == "en" ? "Note :: Please enter the username to delete the user." : "ملاحظة :: الرجاء إدخال اسم المستخدم لحذف المستخدم."
            }
            
            
        }
    }
    
    
    
    @IBAction func noBtnAction(_ sender: Any) {
        self.buttonCancelHandler?()
    }
    @IBAction func yesBtnAction(_ sender: Any) {
        str_uniquename = UniqueNameTxt.text! as NSString
        if str_uniquename .isEqual(to: "") {
            if self.deleteCheck == "Community_view_Controller"{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter unique name." : "يرجى إدخال اسم فريد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
        }else {
            self.buttonDoneHandler?(UniqueNameTxt.text!)
        }
    }
    
    
}
