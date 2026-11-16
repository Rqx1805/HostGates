//
//  ContactUserCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ContactUserCell: UITableViewCell {

    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var assinGateNo: UILabel!
    @IBOutlet weak var unitNumber: UILabel!
    @IBOutlet weak var buildNUmber: UILabel!
    @IBOutlet weak var idnumber: UILabel!
    @IBOutlet weak var unit_numberlbl: UILabel!
    @IBOutlet weak var buliding_numberlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
