//
//  RejectView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 04/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class RejectView: UIView {
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?
    
    //MARK:- IBOutlet
    @IBOutlet weak var main_lbl: UILabel!
    @IBOutlet weak var no_btn: UIButton!
    @IBOutlet weak var yes_btn: UIButton!
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    
    class func intitiateFromNib() -> RejectView {
        let View1 = UINib.init(nibName: "RejectView", bundle: nil).instantiate(withOwner: self, options: nil).first as! RejectView
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if self.language == "en" {
                self.no_btn.setTitle("NO", for: .normal)
                self.yes_btn.setTitle("YES", for: .normal)
                
            }else if self.language == "ar" {
                self.no_btn.setTitle("لا", for: .normal)
                self.yes_btn.setTitle("نعم", for: .normal)
            }
            self.main_lbl.text = self.language == "en" ? "Are you sure to reject this visitor request?" : "هل أنت متأكد من رفض طلب الزائر هذا؟"
        }
        
    }
    
    @IBAction func noBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    @IBAction func yesBtnAction(_ sender: Any) {
        buttonDoneHandler?()
    }
    
}
