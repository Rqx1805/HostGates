//
//  SubAccountsCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SubAccountsCell: UITableViewCell {

    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emial: UILabel!
    @IBOutlet weak var id_no: UILabel!
    @IBOutlet weak var Id_No: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
