//
//  AllComminutyCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 16/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class AllComminutyCell: UICollectionViewCell {
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBOutlet weak var CommunityLogoImageview: UIImageView!
    @IBOutlet weak var CommunitynameLbl: UILabel!
    @IBOutlet weak var communuityAddressLbl: UILabel!
    @IBOutlet weak var ResidentelLbl: UILabel!
    @IBOutlet weak var ViewUserBtn: UIButton!
    @IBOutlet weak var communityView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.communityView.layer.cornerRadius = 5
        CommunityLogoImageview.layer.cornerRadius = CommunityLogoImageview.frame.height/2
        CommunityLogoImageview.layer.masksToBounds = true
        CommunityLogoImageview.clipsToBounds = true
        // Initialization code
    }
    
   
}
