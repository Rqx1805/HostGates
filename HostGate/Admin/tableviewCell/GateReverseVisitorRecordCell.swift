//
//  GateReverseVisitorRecordCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class GateReverseVisitorRecordCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var visNameLbl: UILabel!
    @IBOutlet weak var unit_no: UILabel!
    @IBOutlet weak var pinLbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var visTypeLbl: UILabel!
    @IBOutlet weak var stsLbl: UILabel!
    @IBOutlet weak var visitor_count: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var building_no: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var editwidthCons: NSLayoutConstraint!
    @IBOutlet weak var deleteWidthCons: NSLayoutConstraint!
    @IBOutlet weak var viewBtnrightCons: NSLayoutConstraint!
    @IBOutlet weak var status_lbl_refffff: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
