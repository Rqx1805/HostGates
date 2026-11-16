//
//  listCellView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 02/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class listCellView: UITableViewCell {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
