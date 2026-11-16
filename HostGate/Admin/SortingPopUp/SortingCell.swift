//
//  SortingCell.swift
//  HostGate
//
//  Created by tarun-mac-6 on 10/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SortingCell: UITableViewCell {

    @IBOutlet weak var sortLbl: UILabel!
    
    class func intiatefromNib() -> SortingCell {
        let cell = UINib.init(nibName: "SortingCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! SortingCell
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
