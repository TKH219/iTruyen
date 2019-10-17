//
//  HomeCell.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/17/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var txtNameCL: UILabel!
    @IBOutlet weak var BookCL: UICollectionView!
    var listBook : [Book] = []
    var vc : HomeVC?
    
    var view : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadCustomCell()
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
    }
    @objc func nameOfFunction(notif: NSNotification) {
        DispatchQueue.main.async {
            self.BookCL.reloadData()
        }
    }
    
    func setupCell(vc : HomeVC) {
        self.vc = vc
    }
    
    func loadCustomCell()
    {
        self.BookCL.delegate = self
        self.BookCL.dataSource = self
        let layoutNewest : UICollectionViewFlowLayout = {
            let l = UICollectionViewFlowLayout()
            l.scrollDirection = .horizontal
            l.itemSize = CGSize(width: UIScreen.main.bounds.width/3 , height: UIScreen.main.bounds.height/2.5 )
            l.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            return l
        }()
        BookCL.register(UINib.init(nibName: "TopBookCell" , bundle: nil), forCellWithReuseIdentifier: "TopBookCell" )
        BookCL.collectionViewLayout = layoutNewest
    }
    
}
extension HomeCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listBook.count == 0
        {
            return 0
        }
        else
        {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BookCL.dequeueReusableCell(withReuseIdentifier: "TopBookCell", for: indexPath) as! TopBookCell
        let dict = listBook[indexPath.row]
        cell.imgTopBook.image = UIImage(named: "ezgif-1-b5f51508f69a.png")
        cell.txtBookName.text = dict.Name
        cell.setupShadow()
        DispatchQueue.global().async { [weak self] in
            guard let newSelf = self else {return}
            if let imageUrl = URL(string: dict.Image!) {
                do {
                    let imageData = try Data(contentsOf: imageUrl as URL)
                    DispatchQueue.main.async {
                        cell.imgTopBook.image = UIImage(data: imageData)
                        cell.imgTopBook.contentMode = .scaleToFill
                        cell.imgTopBook.clipsToBounds = true
                    }
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if listBook.count > 0 {
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewPage") as! PreviewPage
            let dict = listBook[indexPath.row]
            view.getName = dict.Name!
            view.getAuthor = dict.Author!
            view.getLike = String(dict.Like!)
            view.getView = String(dict.View!)
            view.getIntro = dict.Intro!
            view.getStatus = dict.Status!
            view.getImage = dict.Image!
            view.getCoverPhoto = dict.CoverPhoto!
            view.getChapter = dict.ChapterCount!
            view.getId = dict.Id!
            
            self.vc!.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    
}
