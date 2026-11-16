//
//  ResSortCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 02/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class ResSortCell: UITableViewCell {
    
    @IBOutlet weak var sortLbl: UILabel!
    class func intiatefromNib() -> ResSortCell {
        let cell = UINib.init(nibName: "ResSortCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! ResSortCell
        return cell
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
