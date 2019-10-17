//
//  PageCell.swift
//  iTruyen
//
//  Created by HanLTP on 4/18/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import PDFKit

class PageCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 15)
        
        pageNum.font = UIFont.systemFont(ofSize: 13)
        pageNum.textAlignment = .center
        pageNum.frame = CGRect(x: 0, y: imgView.bounds.height, width: bounds.width, height: 15)
        addSubview(imgView)
        addSubview(pageNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let pageNum = UILabel()
    
    let imgView = UIImageView()
    
    func updateCell(_ page : PDFPage, _ pageNumber : Int) {
        
        let pdfPage = page.pageRef
        
        let pageRect = pdfPage?.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: (pageRect?.size)!)
        let img = renderer.image { (ctx) in
            UIColor.white.set()
            ctx.fill(pageRect!)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect!.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(pdfPage!)
        }
        
        imgView.clipsToBounds = true
        imgView.image = img
        
        pageNum.text = "\(pageNumber)"
        
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.3)
                self.alpha = 1
            }
            else {
                self.transform = CGAffineTransform.identity
                self.alpha = 0.3
            }
        }
    }
}
