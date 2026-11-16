//
//  PaytabPaymentView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 20/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class PaytabPaymentView: UIView {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardnumberLbl: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var cardDetalLbl: UILabel!
    @IBOutlet weak var othercardBtn: UIButton!
    
    var buttonCancelHandler : (() -> Void)?
    var buttonOtherCardHandler : (() -> Void)?
    var buttonPayHandler : (() -> Void)?
    
    var defaults: UserDefaults!
    var language:String!
    var cardno:String!
    class func intitiateFromNib() -> PaytabPaymentView {
        let View1 = UINib.init(nibName: "PaytabPaymentView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PaytabPaymentView
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        cardno = defaults.value(forKey: "CardNumber") as? String
        self.cardnumberLbl.text = cardno
        
         DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if self.language == "en" {
            self.payBtn.setTitle("PAY", for: .normal)
            self.othercardBtn.setTitle("OTHER CARD", for: .normal)
            }else if self.language == "ar" {
            self.payBtn.setTitle("دفع", for: .normal)
            self.othercardBtn.setTitle("بطاقة أخرى", for: .normal)
        }
            self.cardDetalLbl.text = self.language == "en" ? "Saved Card" : "البطاقة المحفوظة"
        }
        payBtn.layer.cornerRadius = 5
    }
    @IBAction func payBtnAction(_ sender: Any) {
        buttonPayHandler?()
    }
    
    @IBAction func otherCardBtnAction(_ sender: Any) {
         buttonOtherCardHandler?()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
         buttonCancelHandler?()
    }
    
}
