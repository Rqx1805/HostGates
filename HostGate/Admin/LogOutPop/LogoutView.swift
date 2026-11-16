//
//  LogoutView.swift
//  SOOOM
//
//  Created by tarun-mac-6 on 03/04/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class LogoutView: UIView {
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesbtn: UIButton!
    
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?
    
    
    @IBOutlet weak var logLbl: UILabel!
    class func intitiateFromNib() -> LogoutView {
        let View1 = UINib.init(nibName: "LogoutView", bundle: nil).instantiate(withOwner: self, options: nil).first as! LogoutView
        
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noBtn.layer.cornerRadius = 5
        yesbtn.layer.cornerRadius = 5
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        if language == "en" {
            self.noBtn.setTitle("NO", for: .normal)
            self.yesbtn.setTitle("YES", for: .normal)
            
        }else if language == "ar" {
            self.noBtn.setTitle("لا", for: .normal)
            self.yesbtn.setTitle("نعم", for: .normal)
        }
        self.logLbl.text = language == "en" ? "Are you sure you want to logout?" : "هل أنت متأكد أنك تريد تسجيل الخروج؟"
    }
    
    
   
    
    @IBAction func noBtnAction(_ sender: Any) {
        self.buttonCancelHandler?()
    }
    @IBAction func yesBtnAction(_ sender: Any) {
        self.buttonDoneHandler?()
    }
    
}


