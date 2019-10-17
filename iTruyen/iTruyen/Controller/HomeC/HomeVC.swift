//
//  HomeVC.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/12/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase
class HomeVC: UIViewController{
    var listBook : [Book] = []
    var listTopBook : [Book] = []
    var listLikeBook : [Book] = []
    let ref = Database.database().reference()
    @IBOutlet weak var HomeCL: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCustomCell()
        getFromFirebase()
    }
    
    func getFromFirebase()
    {
        self.showSpinner(onView: self.view)
        let bookRef = self.ref.child("Book")
        bookRef.observe(.value) { (data) in
            var newListBook: [Book] = []
            for bookFB in data.children {
                let newBook = Book()
                let bookSnap = bookFB as! DataSnapshot
                let dict = bookSnap.value as! [String:Any]
                let image = dict["Image"] as! String
                let uploadday = dict["UploadDay"] as! String
                let name = dict["Name"] as! String
                let view = dict["View"] as! Int
                //Fix full
                let author = dict["Author"] as! String
                let chaptercount = dict["ChapterCount"] as! Int
                let coverphoto = dict["CoverPhoto"] as! String
                let genre = dict["Genre"] as! String
                let id = dict["Id"] as! String
                let intro = dict["Intro"] as! String
                let status = dict["Status"] as! String
                let updateday = dict["UpdateDay"] as! String
                let like = dict["Like"] as! Int
                newBook.Author = author
                newBook.ChapterCount = chaptercount
                newBook.CoverPhoto = coverphoto
                newBook.Genre = genre
                newBook.Id = id
                newBook.Image = image
                newBook.Name = name
                newBook.Like = like
                newBook.Status = status
                newBook.UploadDay = uploadday
                newBook.UpdateDay = updateday
                newBook.Intro = intro
                newBook.View = Int(view)
                newBook.Like = Int(like)
                newListBook.append(newBook)
            }
            self.saveToList(listBookGet: newListBook)
        }
    }
    
    func saveToList(listBookGet : [Book])
    {
        listLikeBook = listBookGet
        listBook = listBookGet
        listTopBook = listBookGet
        
        listBook.sort { (Book1, Book2) -> Bool in
            if let view1 = Book1.UploadDay?.toDate, let view2 = Book2.UploadDay?.toDate {
                return view1 > view2
            }
            else
            {
                return true
            }
        }
        listTopBook.sort { (Book1, Book2) -> Bool in
            if let view1 = Book1.View, let view2 = Book2.View {
                return view1 > view2
            }
            else
            {
                return true
            }
        }
        listLikeBook.sort { (Book1, Book2) -> Bool in
            if let view1 = Book1.Like, let view2 = Book2.Like {
                return view1 > view2
            }
            else
            {
                return true
            }
        }
        DispatchQueue.main.async() {
            self.HomeCL.reloadData()
        }
        self.removeSpinner()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
        
    }
    func loadCustomCell()
    {
        let layoutTop : UICollectionViewFlowLayout = {
            let l = UICollectionViewFlowLayout()
            l.scrollDirection = .vertical
            l.itemSize = CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height/2.5 )
            l.minimumInteritemSpacing = 5
            return l
        }()
        HomeCL.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        HomeCL.collectionViewLayout = layoutTop
    }
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HomeCL.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        if indexPath.row == 0
        {
            cell.txtNameCL.text = "Mới Nhất"
            cell.listBook = Array(listBook.prefix(10))
        }
        else if indexPath.row == 1
        {
            cell.txtNameCL.text = "Xem Nhiều Nhất"
            cell.listBook = Array(listTopBook.prefix(10))
            
        }
        else if indexPath.row == 2
        {
            cell.txtNameCL.text = "Thích Nhiều Nhất"
            cell.listBook = Array(listLikeBook.prefix(10))
            
        }
        cell.setupCell(vc: self)
        return cell
    }
    
    
}
var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.color = .red
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
