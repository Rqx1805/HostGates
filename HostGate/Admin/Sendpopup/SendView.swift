//
//  SendView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SendView: UIView,UITextViewDelegate {
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    
    @IBOutlet weak var send_msg: UILabel!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var messageView: UITextView!
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : (() -> Void)?
    
    class func intitiateFromNib() -> SendView {
        let View1 = UINib.init(nibName: "SendView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SendView
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            self.messageView.layer.cornerRadius = 5
            self.messageView.layer.borderColor = UIColor.gray.cgColor
            self.messageView.layer.borderWidth = 1
            self.messageView.delegate = self
            self.messageView.text = self.language == "en" ? "Message" : "رسالة"
            
            if self.language == "en" {
                self.send_btn.setTitle("SEND", for: .normal)
                
            }else if self.language == "ar" {
                self.send_btn.setTitle("إرسال", for: .normal)
            }
            self.send_msg.text = self.language == "en" ? "Send Message" : "إرسال رسالة"
        }
        
    }
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        buttonDoneHandler?()
    }
    
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == " Message" || textView.text == "رسالة" {
            textView.text = ""
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = language == "en" ? "Message" : "رسالة"
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
}

