//
//  SubscriptionCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var expirylbl: UILabel!
    @IBOutlet weak var activatelbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var expDateLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var unuserAcconylbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var unused: UILabel!
    @IBOutlet weak var plan_price: UILabel!
    @IBOutlet weak var validity_month: UILabel!
    @IBOutlet weak var renewBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
