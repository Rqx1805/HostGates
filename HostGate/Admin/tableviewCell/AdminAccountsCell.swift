//
//  AdminAccountsCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class AdminAccountsCell: UITableViewCell {

    @IBOutlet weak var txtOwnerName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var PhoneNumberlbl: UILabel!
    @IBOutlet weak var IdNumberLbl: UILabel!
    @IBOutlet weak var RoleNumberLbl: UILabel!
    @IBOutlet weak var rolelbl: UILabel!
    @IBOutlet weak var idnumberlbl: UILabel!
    
    @IBOutlet weak var EyeButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
