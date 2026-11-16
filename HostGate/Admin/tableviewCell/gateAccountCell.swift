//
//  gateAccountCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class gateAccountCell: UITableViewCell {

    
    @IBOutlet weak var gate_name: UILabel!
    @IBOutlet weak var gate_name_lbl: UILabel!
    @IBOutlet weak var gate_no: UILabel!
    @IBOutlet weak var gate_no_lbl: UILabel!
    @IBOutlet weak var unique_name: UILabel!
    @IBOutlet weak var unique_name_lbl: UILabel!
    
    
    @IBOutlet weak var Eyebutton: UIButton!
    @IBOutlet weak var Editbutton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
