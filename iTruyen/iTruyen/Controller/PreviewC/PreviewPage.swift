//
//  PreviewPage.swift
//  iTruyen
//
//  Created by TranNTH on 4/11/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase

class PreviewPage: UIViewController, UITableViewDelegate, UITableViewDataSource, myDelegate {
    
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var authorBook: UILabel!
    @IBOutlet weak var viewBook: UILabel!
    @IBOutlet weak var likeBook: UILabel!
    @IBOutlet weak var chapterBook: UILabel!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var introBook: UIView!
    @IBOutlet weak var chapterTableView: UITableView!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var introBookContent: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    var ref: DatabaseReference! = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    var setHistoryBookID = Set<String>()
    var setLikedBookID = Set<String>()
    var didLiked: Bool?

    var allBookmark : [Bookmark]? = Bookmark.getData()
    
    var bookmark : Bookmark?
    let queue = DispatchQueue(label: "handle-bookmark")
    
    var status : Bool?
    var bookURL : URL?
    let queueCheck = DispatchQueue(label: "check-urlOffline")
    
    var getId = String()
    var getName = String()
    var getAuthor = String()
    var getView = String()
    var getLike = String()
    var getChapter = Int()
    var getIntro = String()
    var getStatus = String()
    var getCoverPhoto = String()
    var getImage = String()
    
    var content = Content()
    var listChapter: [Content] = [] {
        didSet {
            DispatchQueue.main.async {
                self.chapterTableView.reloadData()
            }
        }
    }
    
    func didFetchData(datas: [Content]) {
        self.listChapter = datas
        self.listChapter.sort { (Chapter1, Chapter2) -> Bool in
            if let cell1 = Chapter1.idChapter, let cell2 = Chapter2.idChapter {
                return cell1 > cell2
            }
            else
            {
                return true
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        ref.child("Book/\(self.getId)/View").setValue(Int(self.getView)! + 1)
        ref.child("Users").child(self.userId!).child("History").setValue(Array(self.setHistoryBookID))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queueCheck.async {
            var flag = 0
            self.getLinkFolder()
            let fileManager = FileManager.default
            do {
                let files = try fileManager.contentsOfDirectory(atPath: self.bookURL!.path)
                let chapterQuantity = files.count
                for index in self.allBookmark! {
                    if index.bookName == self.getName {
                        if chapterQuantity != self.getChapter {
                            self.status = false
                            flag = 1
                        }
                    }
                }
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            if flag == 0 { self.status = self.checkExistFolder() }
        }

        queue.async {
            var flag = 0
            if self.allBookmark == nil {
                self.allBookmark = []
                self.setBookmarkDefault()
            } else {
                for index in self.allBookmark! {
                    if index.bookName == self.getName {
                        
                        if index.currentPage?.count != self.getChapter {
                            let number = self.getChapter - (index.currentPage?.count)!
                            for _ in 0..<number {
                                index.currentPage?.insert(0, at: 0)
                            }
                        }
                        Bookmark.setData(bookmark: self.allBookmark!)
                        self.bookmark = index
                        flag = 1
                        break
                    }
                }
                if flag == 0 {
                    self.setBookmarkDefault()
                }
            }
        }
        
        chapterTableView.isHidden = true
        introBook.isHidden = false
        chapterTableView.delegate = self
        chapterTableView.dataSource = self
        content.delegate = self
        DispatchQueue.main.async {
            self.content.getChapterBook(idbook: self.getId)
            self.setdata()
        }
        
        let userRef = ref.child("Users").child(userId!)
        userRef.observe(.value, with: { (DataSnapshot) in
            let data = DataSnapshot.value as! [String:Any]
            for (key, value) in data {
                if key == "History" && self.setHistoryBookID.isEmpty {
                    self.setHistoryBookID = Set(value as! [String])
                }
                
                if key == "Liked" && self.setLikedBookID.isEmpty {
                    self.setLikedBookID = Set(value as! [String])
                }
            }
            
            self.checkLike()
            self.setHistoryBookID.insert(self.getId)
        })
    }
    
    func checkLike() {
        for id in self.setLikedBookID {
            if self.getId == id {
                self.didLiked = true
                self.buttonLike.setImage(UIImage(named: "Preview_Liked.png"), for: .normal)
                return
            }
        }
        
        self.didLiked = false
        self.buttonLike.setImage(UIImage(named: "Preview_Like.png"), for: .normal)
    }
    
    func setdata() {
        self.nameBook.text = getName
        self.authorBook.text = getAuthor
        self.viewBook.text = getView
        self.likeBook.text = getLike
        self.chapterBook.text = String(getChapter)
        self.introBookContent.text = getIntro
        self.Status.text = getStatus
        
        DispatchQueue.main.async {
            let url = URL(string: self.getImage)
            let data = try? Data(contentsOf: url!)
            self.imageBook.image = UIImage(data: data!)

            let url2 = URL(string: self.getCoverPhoto)
            let data2 = try? Data(contentsOf: url2!)
            self.coverPhoto.image = UIImage(data: data2!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapLike(_ sender: Any) {
        if self.didLiked == true {
            self.didLiked = false
            self.buttonLike.setImage(UIImage(named: "Preview_Like.png"), for: .normal)
            setLikedBookID.remove(self.getId)
            self.getLike = String(Int(self.getLike)! - 1)
            self.likeBook.text = self.getLike
        } else {
            self.didLiked = true
            self.buttonLike.setImage(UIImage(named: "Preview_Liked.png"), for: .normal)
            setLikedBookID.insert(self.getId)
            self.getLike = String(Int(self.getLike)! + 1)
            self.likeBook.text = self.getLike
        }
        
        ref.child("Book/\(self.getId)/Like").setValue(Int(self.getLike)!)
        ref.child("Users").child(userId!).child("Liked").setValue(Array(setLikedBookID))
    }
    
    
    @IBAction func segmentAction(_ sender: Any) {
        switch segmented.selectedSegmentIndex {
        case 0:
            chapterTableView.isHidden = true
            introBook.isHidden = false
        case 1:
            chapterTableView.isHidden = false
            introBook.isHidden = true
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath)
        
        if listChapter.count > 0 {
            cell.textLabel?.text = self.listChapter[indexPath.row].chapterName
            cell.detailTextLabel?.text = self.listChapter[indexPath.row].chapterUpload
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookPage()
        
        if status == true {
            let chapURL = bookURL!.appendingPathComponent("\(self.listChapter[indexPath.row].chapterName!).pdf")
            vc.fileURL = chapURL
            vc.chapterName = self.listChapter[indexPath.row].chapterName
            vc.status = status!
        } else {
            vc.urlString = self.listChapter[indexPath.row].chapterLink
            vc.chapterName = self.listChapter[indexPath.row].chapterName
        }
        
        vc.bookmark = bookmark
        vc.position = indexPath.row
        vc.allBookmark = allBookmark
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapDownload(_ sender: Any) {
        DispatchQueue.global().async {
            for i in 0...self.listChapter.count-1{
                self.downloadPDF(UrlString: self.listChapter[i].chapterLink!)
            }
        }
        showSpinner(onView: self.view)
    }
    func downloadPDF(UrlString: String)
    {
        guard let url = URL(string: UrlString) else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func setBookmarkDefault() {
        let defaultPage : [Int] = Array(repeating: 0, count: getChapter)
        let bookmark : Bookmark = Bookmark(bookName: getName, currentPage: defaultPage)
        allBookmark?.append(bookmark)
        Bookmark.setData(bookmark: allBookmark!)
        self.bookmark = bookmark
    }
    
    func checkExistFolder() -> Bool {
        if bookURL!.hasDirectoryPath == true {
            return true
        } else { return false }
    }
    
    func getLinkFolder() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let folderURL = documentsURL.appendingPathComponent("Offline")
        bookURL = folderURL.appendingPathComponent("\(getName)")
    }
}
var count : Int = 0
extension PreviewPage: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        var temp = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if temp == 1.0
        {
            count = count + 1
        }
        if(count == listChapter.count)
        {
            print(count)
            print(listChapter.count)
            Helper.app.showAlert(title: "Thông Báo", message: "Download thành công", vc: self)
            count = 0
            removeSpinner()
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsURL.appendingPathComponent("Offline")
        let bookURL = folderURL.appendingPathComponent("\(getName)")
        do {
            try FileManager.default.createDirectory(at: bookURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        let fileURL = bookURL.appendingPathComponent(url.lastPathComponent)
        
        
        try? FileManager.default.removeItem(at: fileURL)
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
