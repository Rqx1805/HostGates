//
//  StartLanguageSelectVC.swift
//  HostGate
//
//  Created by Vipul on 27/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class StartLanguageSelectVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var Change_language_title_lbl_ref: UILabel!
    @IBOutlet weak var english_btn_re: UIButton!
    @IBOutlet weak var arabic_btn_ref: UIButton!
    @IBOutlet weak var next_btn_ref: UIButton!
    @IBOutlet weak var view_ref: UIView!
    @IBOutlet weak var image_view_ref: UIImageView!
    @IBOutlet weak var english_img_ref: UIImageView!
    @IBOutlet weak var arabic_img_ref: UIImageView!
    
    //MARK:- Varibales
    var checkForLanguageSelect = "5"
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_ref.layer.cornerRadius = 12
        self.view_ref.clipsToBounds = true
        self.image_view_ref.layer.cornerRadius = 12
        self.image_view_ref.clipsToBounds = true
        self.arabic_btn_ref.setTitle("عربى", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //MARK:- IBAction
    @IBAction func english_btn_action(_ sender: Any) {
        self.english_img_ref.image = UIImage(named: "icons8-tick-box-64")
        self.arabic_img_ref.image = UIImage(named: "")
        let defaults = UserDefaults.standard
        defaults.set("en", forKey: "Language")
        checkForLanguageSelect = "1"
    }
    @IBAction func arabic_btn_action(_ sender: Any) {
        self.arabic_img_ref.image = UIImage(named: "icons8-tick-box-64")
        self.english_img_ref.image = UIImage(named: "")
        let defaults = UserDefaults.standard
        defaults.set("ar", forKey: "Language")
        checkForLanguageSelect = "2"
    }
    
    @IBAction func next_btn_action(_ sender: Any) {
        if checkForLanguageSelect == "5"{
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Select language", buttonTitle: "OK")
        }else{
            UserDefaults.standard.set("LanguageFill", forKey: "checkController")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
