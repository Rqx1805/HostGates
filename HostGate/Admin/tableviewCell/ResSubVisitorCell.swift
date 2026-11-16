//
//  ResSubVisitorCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ResSubVisitorCell: UITableViewCell {

    @IBOutlet weak var visitor_name: UILabel!
    @IBOutlet weak var view_btn: UIButton!
    @IBOutlet weak var edit_btn: UIButton!
    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var pin: UILabel!
    @IBOutlet weak var pinLbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var visitor_count: UILabel!
    @IBOutlet weak var visitor_countLbl: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var expected_time: UILabel!
    @IBOutlet weak var expected_timelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
