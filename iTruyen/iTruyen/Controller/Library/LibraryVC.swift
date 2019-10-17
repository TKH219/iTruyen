//
//  LibraryVC.swift
//  iTruyen
//
//  Created by HaTK1 on 4/16/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class LibraryVC: UIViewController {

    @IBOutlet weak var txtLiked: UILabel!
    @IBOutlet weak var txtHistory: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var likedTableView: UITableView!
 
    let notFoundHistoryBookLabel = UILabel()
    let notFoundLikedBookLabel = UILabel()
    
    let ref: DatabaseReference! = Database.database().reference()
    var userId = (Auth.auth().currentUser?.uid)!
    var listLikedBookID: [String] = []
    var listHistoryBookID: [String] = []
    var didChangedDataAtListLikedBook = false
    var didChangedDataAtListHistoryBook = false
    var isFirstTimeGetData = true
    var listLikedBook: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.likedTableView.reloadData()
            }
        }
    }

    var listHistoryBook: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            let userRef = self.ref.child("Users").child(self.userId)
            userRef.observe(.value, with: { (DataSnapshot) in
                let data = DataSnapshot.value as! [String:Any]
                var isExist = false
                for (key, value) in data {
                    if key == "History" {
                        if self.didChangedDataAtListHistoryBook == true {
                            self.listHistoryBook.removeAll()
                        }
                        
                        self.listHistoryBookID = value as! [String]
                    }
                    
                    if key == "Liked" {
                        if self.didChangedDataAtListLikedBook == true {
                            self.listLikedBook.removeAll()
                        }
                        
                        isExist = true
                        self.listLikedBookID = value as! [String]
                    }
                }
                
                if isExist == false {
                    self.listLikedBookID = []
                }
                
                self.getDataFromFirebase()
            })
    }
    
    func getDataFromFirebase() {
        if self.didChangedDataAtListLikedBook == true {
            self.listLikedBook.removeAll()
        } else if self.didChangedDataAtListHistoryBook == true {
            self.listHistoryBook.removeAll()
        } else {
            self.listHistoryBook.removeAll()
            self.listLikedBook.removeAll()
        }
        
        
        
        if listHistoryBookID.count == 0 {
            self.listHistoryBook = []
            self.likedTableView.reloadData()
        } else {
            for id in listHistoryBookID {
                if isFirstTimeGetData == true || didChangedDataAtListHistoryBook == true {
                    getBookFromFirebase(bookId: id, isLikedBook: false)
                }
            }
        }
        
        if listLikedBookID.count != 0 {
            for id in listLikedBookID {
                if isFirstTimeGetData == true || didChangedDataAtListLikedBook == true {
                    getBookFromFirebase(bookId: id, isLikedBook: true)
                }
            }
        } else {
            self.listLikedBook = []
            self.likedTableView.reloadData()
        }
    }
    
    
    
    func getBookFromFirebase(bookId: String, isLikedBook: Bool) {
        let book = Book()
        let bookRef = ref.child("Book").child(bookId)
        bookRef.observe(.value, with: {(DataSnapshot) in
            let data = DataSnapshot.value as! [String: Any]
            book.Author = data["Author"] as? String
            book.ChapterCount = data["ChapterCount"] as? Int
            book.CoverPhoto = data["CoverPhoto"] as? String
            book.Genre = data["Genre"] as? String
            book.Id = data["Id"] as? String
            book.Image = data["Image"] as? String
            book.Intro = data["Intro"] as? String
            book.Like = data["Like"] as? Int
            book.Name = data["Name"] as? String
            book.Status = data["Status"] as? String
            book.View = data["View"] as? Int
            book.UpdateDay = data["UpdateDay"] as? String
            book.UploadDay = data["UploadDay"] as? String
            
            if isLikedBook == true {
                if self.listLikedBook.count == 0 {
                    self.listLikedBook.append(book)
                } else {
                    var flag : Bool = false
                    for item in self.listLikedBook {
                        if item.Id == book.Id {
                            flag = true
                        }
                    }
                    
                    if flag == false {
                            self.listLikedBook.append(book)
                        }
                }
            } else {
                if self.listHistoryBook.count == 0 {
                    self.listHistoryBook.append(book)
                } else {
                    var flag : Bool = false
                    for item in self.listHistoryBook {
                        if item.Id == book.Id {
                            flag = true
                        }
                    }

                    if flag == false {
                        self.listHistoryBook.append(book)
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logOutButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        logOutButton.setImage(UIImage(named: "logout.png"), for: UIControl.State.normal)
        logOutButton.addTarget(self, action: #selector(signOut), for: UIControl.Event.touchUpInside)
        logOutButton.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        self.navigationItem.title = "Thư Viện"
        self.txtLiked.text = "Đã Thích"
        self.txtHistory.text = "Lịch sử"
        self.historyTableView.rowHeight = UITableView.automaticDimension
        self.historyTableView.estimatedRowHeight = 125.0
        self.historyTableView.register(UINib(nibName: "LibraryItem", bundle: nil), forCellReuseIdentifier: "LibraryItem")
        self.likedTableView.register(UINib(nibName: "LibraryItem", bundle: nil), forCellReuseIdentifier: "LibraryItem")
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        likedTableView.dataSource = self
        likedTableView.delegate = self
    }
    
    @objc func signOut() {
        print("Did tag button sign out")
        let alert = UIAlertController(title: "Đăng Xuất", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Có", style: .default) { (UIAlertAction) in
            try! Auth.auth().signOut()
            
            self.navigationController?.popToRootViewController(animated: true)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.present(loginVC, animated: false)
        }
        
        let cancelAction = UIAlertAction(title: "Không", style: .cancel) { (UIAlertAction) in
            print("dont log out")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if tableView == self.likedTableView {
            if !self.listLikedBookID.isEmpty {
                tableView.separatorStyle = .singleLine
                numOfSections = 1
                tableView.backgroundView = nil
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "Không tìm thấy cuốn sách nào cả !!!"
                noDataLabel.textColor = .black
                noDataLabel.textAlignment = .center
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
                tableView.backgroundColor = .clear
            }
        } else {
            if !self.listHistoryBookID.isEmpty {
                tableView.separatorStyle = .singleLine
                numOfSections = 1
                tableView.backgroundView = nil
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "Không tìm thấy cuốn sách nào cả !!!"
                noDataLabel.textColor = .black
                noDataLabel.textAlignment = .center
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
                tableView.backgroundColor = .clear
            }
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.likedTableView {
            return listLikedBook.count
        } else {
            return listHistoryBook.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryItem", for: indexPath) as! LibraryItem
        if tableView == self.likedTableView {
            let imageURL = URL(string: self.listLikedBook[indexPath.row].Image!)
            cell.imageBook.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "loading.jpg"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
            cell.name.text = listLikedBook[indexPath.row].Name
            cell.lastChapter.text = "Chapter: \(listLikedBook[indexPath.row].ChapterCount!)"
            cell.descriptionChapter.text = listLikedBook[indexPath.row].Intro
        } else {
            let imageURL = URL(string: (self.listHistoryBook[indexPath.row].Image) ?? "")
            cell.imageBook.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "loading.jpg"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
            cell.name.text = listHistoryBook[indexPath.row].Name
            cell.lastChapter.text = "Chapter: \(listHistoryBook[indexPath.row].ChapterCount!)"
            cell.descriptionChapter.text = listHistoryBook[indexPath.row].Intro
        }
    
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let userRef = ref.child("Users").child(userId)
        self.isFirstTimeGetData = false
        if editingStyle == .delete {
            if tableView == self.historyTableView {
                listHistoryBookID.remove(at: indexPath.row)
                didChangedDataAtListHistoryBook = true
                userRef.child("History").setValue(listHistoryBookID)
            } else {
                listLikedBookID.remove(at: indexPath.row)
                didChangedDataAtListLikedBook = true
                userRef.child("Liked").setValue(listLikedBookID)
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.historyTableView {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PreviewPage") as! PreviewPage
            let book = listHistoryBook[indexPath.row]
            vc.getName = book.Name!
            vc.getAuthor = book.Author!
            vc.getLike = String(book.Like!)
            vc.getView = String(book.View!)
            vc.getIntro = book.Intro!
            vc.getStatus = book.Status!
            vc.getImage = book.Image!
            vc.getCoverPhoto = book.CoverPhoto!
            vc.getChapter = book.ChapterCount!
            vc.getId = book.Id!
            navigationController?.pushViewController(vc, animated: true)

        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PreviewPage") as! PreviewPage
            let book = listLikedBook[indexPath.row]
            vc.getName = book.Name!
            vc.getAuthor = book.Author!
            vc.getLike = String(book.Like!)
            vc.getView = String(book.View!)
            vc.getIntro = book.Intro!
            vc.getStatus = book.Status!
            vc.getImage = book.Image!
            vc.getCoverPhoto = book.CoverPhoto!
            vc.getChapter = book.ChapterCount!
            vc.getId = book.Id!
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
