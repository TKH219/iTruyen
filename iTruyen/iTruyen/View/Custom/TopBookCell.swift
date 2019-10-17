//
//  TopBookCell.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/16/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class TopBookCell: UICollectionViewCell {

    @IBOutlet weak var imgTopBook: UIImageView!
    @IBOutlet weak var txtBookName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        imgTopBook.image = nil
        super.prepareForReuse()
    }
    func setupShadow()
    {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 6, height: 6)
        layer.shadowOpacity = 0.5
    }

}
