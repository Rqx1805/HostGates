//
//  ResVisitorRecordCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ResVisitorRecordCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var cancleBtb: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var cancleBtnWidthCons: NSLayoutConstraint!
    @IBOutlet weak var deleteBtnWidthCons: NSLayoutConstraint!
    @IBOutlet weak var hostnameLbl: UILabel!
    @IBOutlet weak var creatorLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var viewbtnCons: NSLayoutConstraint!
    @IBOutlet weak var pincode: UILabel!
    @IBOutlet weak var accpet_reject_stack_view: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptBtn.layer.cornerRadius = 5
        rejectBtn.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
