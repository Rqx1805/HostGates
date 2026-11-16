//
//  SendOtpView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 04/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit


class SendOtpView: UIView,UITextFieldDelegate {
    
    
    @IBOutlet weak var send_lbl: UILabel!
    @IBOutlet weak var pin_code: UILabel!
    @IBOutlet weak var pincodeLbl: UILabel!
    @IBOutlet weak var selCountryTxt: UITextField!
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var send_btn: UIButton!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?
    
    var str_country:NSString!
    var str_mobile:NSString!
    
    var defaults:UserDefaults!
    var pindcode:String!
    
    
    var nav: UIStoryboard!
    var navController : UINavigationController?
    class func intitiateFromNib() -> SendOtpView {
        let View1 = UINib.init(nibName: "SendOtpView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SendOtpView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        pindcode = defaults.value(forKey: "PINCODE") as? String
        pincodeLbl.text = pindcode
        
        
        selCountryTxt.delegate = self
        
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        
        if language == "en" {
            self.send_btn.setTitle("SEND", for: .normal)
            
        }else if language == "ar" {
            self.send_btn.setTitle("إرسال", for: .normal)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.send_lbl.text = self.language == "en" ? "Send OTP" : "إرسالمكتب المدعي العام"
            self.pin_code.text = self.language == "en" ? "Pin Code" : "الرقم السري"
            self.selCountryTxt.placeholder = self.language == "en" ? "Select Country" : "حدد الدولة"
            self.mobileNumberTxt.placeholder = self.language == "en" ? "Mobile Number" : "رقم الهاتف المحمول"
            if self.language .isEqual("en") || self.language .isEqual(""){
            self.selCountryTxt.textAlignment = .left
            self.mobileNumberTxt.textAlignment = .left
            }else if self.language .isEqual("ar") {
            self.selCountryTxt.textAlignment = .right
            self.mobileNumberTxt.textAlignment = .right
        }
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selCountryTxt {
        }else {
            
        }
    }
    
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        buttonDoneHandler?()
    }
}

