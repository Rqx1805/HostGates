//
//  GateVisitorRecordCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class GateVisitorRecordCell: UITableViewCell {

    @IBOutlet weak var visitor_name: UILabel!
    @IBOutlet weak var view_btn: UIButton!
    @IBOutlet weak var check_in_btn: UIButton!
    @IBOutlet weak var check_out_btn: UIButton!
    @IBOutlet weak var pin: UILabel!
    @IBOutlet weak var pin_lbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var visitor_type_lbl: UILabel!
    @IBOutlet weak var complete_lbl: UILabel!
    @IBOutlet weak var visitor_count: UILabel!
    @IBOutlet weak var visitor_count_lbl: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var date_time_lbl: UILabel!
    @IBOutlet weak var building_no: UILabel!
    @IBOutlet weak var building_no_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
