//
//  FinReportCell.swift
//  HostGate
//
//  Created by Vipul on 28/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class FinReportCell: UITableViewCell {
    
    @IBOutlet weak var title_lbl_ref: UILabel!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var type_lbl_ref: UILabel!
    @IBOutlet weak var type_lbl: UILabel!
    @IBOutlet weak var no_of_assignied_user_lbl_ref: UILabel!
    @IBOutlet weak var no_of_assignied_user_lbl: UILabel!
    @IBOutlet weak var no_of_users_lbl_ref: UILabel!
    @IBOutlet weak var no_of_users_lbl: UILabel!
    @IBOutlet weak var no_of_sub_users_lbl_ref: UILabel!
    @IBOutlet weak var no_of_sub_users_lbl: UILabel!
    @IBOutlet weak var no_of_visit_records_lbl_ref: UILabel!
    @IBOutlet weak var no_of_visit_records_lbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
