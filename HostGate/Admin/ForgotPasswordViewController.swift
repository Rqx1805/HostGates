//
//  ForgotPasswordViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var next_btn: UIButton!
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var dGlocale = DGLocalization()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.emailTxt.placeholder = language == "en" ? "Email" : "البريد الإلكتروني"
        if language == "en" {
            self.next_btn.setTitle("Next", for: .normal)
            
        }else if language == "ar" {
            self.next_btn.setTitle("التالى", for: .normal)
        }
        
        if language .isEqual("en") || language .isEqual(""){
            self.emailTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.emailTxt.textAlignment = .right
        } 
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK:-DGLoclalization Delegate
extension ForgotPasswordViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}


