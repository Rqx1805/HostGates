//
//  ComVistCell.swift
//  HostGate
//
//  Created by MAC-25 on 13/02/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit

class ComVistCell: UITableViewCell {

    @IBOutlet weak var view_btn_ref: UIButton!
    @IBOutlet weak var hostNameLbl: UILabel!
    @IBOutlet weak var CreatorLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var meLbl: UILabel!
    @IBOutlet weak var typeLb: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var vpountLbl: UILabel!
    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var dateTimeLb: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var stsLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
