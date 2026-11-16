//
//  UserDashVisitoCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 25/11/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class UserDashVisitoCell: UITableViewCell {

    @IBOutlet weak var snLbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
