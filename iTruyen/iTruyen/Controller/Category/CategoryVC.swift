//
//  CategoryVCViewController.swift
//  iTruyen
//
//  Created by HaTK1 on 4/12/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase

class CategoryVC: UIViewController {
    
    let ref: DatabaseReference! = Database.database().reference()
    var listFirstCategory: [Genre] = [] {
        didSet {
            self.firstFilterCL.reloadData()
        }
    }
    
    var listSecondCategory : [String] = [] {
        didSet {
            self.secondFilterCL.reloadData()
        }
    }
    
    @IBOutlet weak var firstFilterCL: UICollectionView!
    @IBOutlet weak var secondFilterCL: UICollectionView!
    @IBOutlet weak var lblFirstTitleCategory: UILabel!
    @IBOutlet weak var lblSecondTitleCategory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Danh Mục"
        self.lblFirstTitleCategory.text = "Thể Loại"
        self.lblSecondTitleCategory.text = "Tác Giả"
        loadCustomCell()
        let genreRef = ref.child("Genre")
        genreRef.observe(.childAdded, with: { (DataSnapshot) in
            let data = DataSnapshot.value as! [String:Any]
            let genreName = data["Name"] as! String
            let genreID = data["Id"] as! String
            self.listFirstCategory.append(Genre(id: genreID, name: genreName))
        })
        
        let authorRef = ref.child("Book")
        authorRef.observe(.childAdded) { (DataSnapshot) in
            let data = DataSnapshot.value as! [String:Any]
            let authorName = data["Author"] as! String
            self.addListAuthor(authorName: authorName)
        }
    }
    
    func addListAuthor(authorName: String) {
        var flag : Bool = false
        for category in listSecondCategory {
            if authorName == category {
                flag = true
                break
            }
        }
        
        if flag == false {
            listSecondCategory.append(authorName)
        }
    }
    
    
    func loadCustomCell() {
        firstFilterCL.register(UINib(nibName: "CustomCLCell", bundle: nil), forCellWithReuseIdentifier: "CustomCLCell")
        secondFilterCL.register(UINib(nibName: "CustomCLCell", bundle: nil), forCellWithReuseIdentifier: "CustomCLCell")
        firstFilterCL.dataSource = self
        firstFilterCL.delegate = self
        firstFilterCL.collectionViewLayout = UICollectionViewFlowLayout()
        secondFilterCL.delegate = self
        secondFilterCL.dataSource = self
        secondFilterCL.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension CategoryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.firstFilterCL {
            return listFirstCategory.count
        } else {
            return listSecondCategory.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCLCell", for: indexPath) as! CustomCLCell
        if collectionView == self.firstFilterCL {
            cell.lblFilterName.text = listFirstCategory[indexPath.row].name
        } else {
            cell.lblFilterName.text = listSecondCategory[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 18.0
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/8)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListBook") as! ListStoryTableView
        // Create a instance of View Controller in here
        
        if collectionView == self.firstFilterCL {
            let dict = listFirstCategory[indexPath.row]
            storyboard.getData = dict.id!
            navigationController?.pushViewController(storyboard, animated: true)
        } else {
            storyboard.getData = listSecondCategory[indexPath.row]
            navigationController?.pushViewController(storyboard, animated: true)
        }
    }
}
