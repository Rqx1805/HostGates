//
//  ResidentListCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ResidentListCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var buliding_no: UILabel!
    @IBOutlet weak var buildNoLbl: UILabel!
    @IBOutlet weak var unit_no: UILabel!
    @IBOutlet weak var unitNoLbl: UILabel!
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var reverseBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
