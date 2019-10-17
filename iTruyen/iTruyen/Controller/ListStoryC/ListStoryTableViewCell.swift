//
//  ListStoryTableViewCell.swift
//  iTruyen
//
//  Created by NguyenDQ1 on 4/9/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class ListStoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var titleBook: UILabel!
    @IBOutlet weak var authorBook: UILabel!
    @IBOutlet weak var viewAndUpdate: UILabel!
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.imageBook.frame
        rectShape.position = self.imageBook.center
        rectShape.path = UIBezierPath(roundedRect: self.imageBook.bounds, byRoundingCorners: [.bottomRight , .topRight, .topLeft, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        
        self.imageBook.layer.backgroundColor = UIColor.lightGray.cgColor
        self.imageBook.layer.mask = rectShape
        
        backgroundCell.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCell.layer.borderWidth = 0.5
        backgroundCell.layer.cornerRadius = 10
        backgroundCell.backgroundColor = .white
        backgroundCell.layer.shadowOffset = CGSize(width: 2, height: 3)
        backgroundCell.layer.shadowRadius = 3
        backgroundCell.layer.shadowOpacity = 0.6
        backgroundCell.layer.masksToBounds = false
        backgroundCell.layer.shadowColor = #colorLiteral(red: 0.06124514249, green: 0.06124514249, blue: 0.06124514249, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundCell.backgroundColor = .white
    }
    
}
