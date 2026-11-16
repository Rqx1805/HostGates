//
//  FreeAccountCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 05/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class FreeAccountCell: UITableViewCell {

    @IBOutlet weak var admin_gate: UILabel!
    @IBOutlet weak var adminLbl: UILabel!
    @IBOutlet weak var date_of_activate: UILabel!
    @IBOutlet weak var dateDeactiveLbl: UILabel!
    @IBOutlet weak var expiry_date: UILabel!
    @IBOutlet weak var exprireLbl: UILabel!
    @IBOutlet weak var no_of_account: UILabel!
    @IBOutlet weak var noofAccountLbl: UILabel!
    @IBOutlet weak var no_of_account_use: UILabel!
    @IBOutlet weak var noofaccountunusedLbl: UILabel!
    @IBOutlet weak var vaildity: UILabel!
    @IBOutlet weak var validityLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
