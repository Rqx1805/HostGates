//
//  ComListCell.swift
//  HostGate
//
//  Created by MAC-25 on 13/02/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class ComListCell: UITableViewCell {

  
    @IBOutlet weak var comNameLb: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var comtypeLb: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var no_of_users_lbl_ref: UILabel!
    @IBOutlet weak var no_of_users_lbl: UILabel!
    @IBOutlet weak var no_of_subusers_lbl_ref: UILabel!
    @IBOutlet weak var no_of_subusers_lbl: UILabel!
    @IBOutlet weak var no_of_gates_lbl_rf: UILabel!
    @IBOutlet weak var no_of_gates_lbl: UILabel!
    @IBOutlet weak var no_of_visit_records_lbl_ref: UILabel!
    @IBOutlet weak var no_of_visit_records_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
