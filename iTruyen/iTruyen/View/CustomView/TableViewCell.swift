//
//  TableViewCell.swift
//  iTruyen
//
//  Created by SangNM3 on 4/16/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var filterName1: UILabel!
    @IBOutlet weak var filterName2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
