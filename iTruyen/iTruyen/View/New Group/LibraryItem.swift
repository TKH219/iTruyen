//
//  LibraryItem.swift
//  iTruyen
//
//  Created by SangNM3 on 4/16/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class LibraryItem: UITableViewCell {

    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var imageBook: UIImageView!
    
    @IBOutlet weak var descriptionChapter: UILabel!
    
    @IBOutlet weak var lastChapter: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
