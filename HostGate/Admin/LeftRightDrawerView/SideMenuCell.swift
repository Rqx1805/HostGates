//
//  SideMenuCell.swift
//  RideShare
//
//  Created by sensussoft on 1/3/18.
//  Copyright © 2018 sensussoft. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet var lblItem: UILabel!
    @IBOutlet weak var viewCounter: UIView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var viewSepretor: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var dGlocale = DGLocalization()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        lblItem.font = UIFont(name: "Medium", size: 16.0)
        //        lblItem.textColor = UIColor.white
        
        lblCounter.font = UIFont(name: "Medium", size: 11)
        lblCounter.textColor = UIColor.white
        
        viewCounter.backgroundColor = UIColor.black
        //viewCounter.applyCircle()
        
        viewSepretor.backgroundColor = UIColor(white: 1, alpha: 0.2)
        
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
//        self.lblItem.text = "".localize
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//MARK:-DGLoclalization Delegate
extension SideMenuCell:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
