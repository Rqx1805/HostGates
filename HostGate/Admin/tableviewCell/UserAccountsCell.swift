//
//  UserAccountsCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class UserAccountsCell: UITableViewCell {

    @IBOutlet weak var OwnerNameLbl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var PhoneNumberlbl: UILabel!

    @IBOutlet weak var UnitNumberlbl: UILabel!
    @IBOutlet weak var BuildingNumberLbl: UILabel!
    @IBOutlet weak var unit_numberLbl: UILabel!
    @IBOutlet weak var buliding_numberLbl: UILabel!
    
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
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
