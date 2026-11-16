//
//  PaymentDetailView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 16/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class PaymentDetailView: UIView {
    var buttonCancelHandler : (() -> Void)?
    
    @IBOutlet weak var payable_amount: UILabel!
    @IBOutlet weak var no_of_user_account: UILabel!
    @IBOutlet weak var userNumberLabel: UILabel!
    @IBOutlet weak var vatii: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var tota: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var subtlLbl: UILabel!
    @IBOutlet weak var discountLb: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    
    var defaults:UserDefaults!
    var nousers:Int!
    var vat:Int!
    var total:Int!
    var price:Int!
    var subtl:Int!
    var discount:Int!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    class func intitiateFromNib() -> PaymentDetailView {
        let View1 = UINib.init(nibName: "PaymentDetailView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PaymentDetailView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        nousers = defaults.integer(forKey: "NOUsers")
        price = defaults.integer(forKey: "Price")
        subtl = defaults.integer(forKey: "SubPrice")
        discount = defaults.integer(forKey: "DisCount")
        var nouse:String!
        nouse = String(nousers)
        
        userNumberLabel.text = nouse
        vat = defaults.integer(forKey: "Validity")
        
        
      
        
        if discount == 0 {
            var dis:String!
            dis = String(discount)
            self.discountLbl.text = "-$" + dis
        }else {
            var dis:String!
            dis = String(discount)
            self.discountLbl.text = "-$" + dis
        }
        
       
        
        var subtlnew:String!
        subtlnew = String(subtl)
        
        self.totalLbl.text = "$" + subtlnew
        
        
        var vt:String!
        vt = String(vat)
        if nousers == 0 {
            vatLbl.text = "$" + "0"
        }else {
            vatLbl.text = "$" + vt
        }
        
        
        
        // total = nousers*vat/100
        var tl1 = Int()
        tl1 = nousers*vat
        var str:String!
        str = String(tl1)
        subtlLbl.text = "$" + str
        
        
        //MARK:- language Code Start
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.payable_amount.text = language == "en" ? "Payable Amount" : "المبلغ المستحق"
        
        self.no_of_user_account.text = language == "en" ? "Number of user accounts" : "عدد حسابات المستخدمين"
        self.vatii.text = language == "en" ? "Per account cost with VAT(14%)" : "لكل تكلفة حساب مع ضريبة القيمة المضافة (14 ٪)"
        self.tota.text = language == "en" ? "Total" : "مجموع"
        self.subTotalLbl.text = language == "en" ? "Sub Total" : "المجموع الفرعي"
        self.discountLb.text = language == "en" ? "Discount" : "خصم"
    }
    
    @IBAction func cancleBtnActiomn(_ sender: Any) {
        buttonCancelHandler?()
    }
}

//MARK:-DGLoclalization Delegate
extension PaymentDetailView:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
