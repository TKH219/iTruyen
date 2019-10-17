//
//  FindVC.swift
//  iTruyen
//
//  Created by HanLTP on 4/24/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase

class FindVC: UIViewController {

    @IBOutlet weak var bookListTableView: UITableView!
    
    let searchBar = UISearchBar()
    let ref : DatabaseReference! = Database.database().reference()
    
    var bookList : [Book] = []
    var filteredData : [Book] = []
    var waiting = false
    
    let frameView = UIView()
    let frameHeight = UIScreen.main.bounds.height
    let imgSearch = UIImageView()
    let labelSearch = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBook()
        
        let nib = UINib.init(nibName: "ListStoryTableViewCell", bundle: nil)
        self.bookListTableView.register(nib, forCellReuseIdentifier: "ListStoryTableViewCell")
        
        bookListTableView.delegate = self
        bookListTableView.dataSource = self
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupLogoSearch()
    }
    
    func getBook() {
        let bookRef = ref.child("Book")
        bookRef.observe(.value) { (data) in
            var newListBook: [Book] = []
            for bookFB in data.children {
                let newBook = Book()
                let bookSnap = bookFB as! DataSnapshot
                let dict = bookSnap.value as! [String:Any]
                let like = dict["Like"] as! Int
                let intro = dict["Intro"] as! String
                let status = dict["Status"] as! String
                let image = dict["Image"] as! String
                let coverPhoto = dict["CoverPhoto"] as! String
                let author = dict["Author"] as! String
                let updateDay = dict["UpdateDay"] as! String
                let name = dict["Name"] as! String
                let view = dict["View"] as! Int
                let chapter = dict["ChapterCount"] as! Int
                let id = dict["Id"] as! String
                
                newBook.Like = like
                newBook.Intro = intro
                newBook.Status = status
                newBook.Image = image
                newBook.CoverPhoto = coverPhoto
                newBook.Author = author
                newBook.UpdateDay = updateDay
                newBook.Name = name
                newBook.View = Int(view)
                newBook.ChapterCount = chapter
                newBook.Id = id
                newListBook.append(newBook)
            }
            self.bookList = newListBook
        }
    }
    
    func setupLogoSearch() {
        
        frameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frameView)
        frameView.widthAnchor.constraint(equalToConstant: frameHeight / 3).isActive = true
        frameView.heightAnchor.constraint(equalToConstant: frameHeight / 3).isActive = true
        frameView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        frameView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        imgSearch.translatesAutoresizingMaskIntoConstraints = false
        frameView.addSubview(imgSearch)
        imgSearch.centerXAnchor.constraint(equalTo: frameView.centerXAnchor, constant: 0).isActive = true
        imgSearch.topAnchor.constraint(equalTo: frameView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        imgSearch.widthAnchor.constraint(equalToConstant: frameHeight * 3 / 12).isActive = true
        imgSearch.heightAnchor.constraint(equalToConstant: frameHeight * 3 / 12).isActive = true
        imgSearch.image = UIImage(named: "searching-background")
        
        labelSearch.translatesAutoresizingMaskIntoConstraints = false
        frameView.addSubview(labelSearch)
        labelSearch.centerXAnchor.constraint(equalTo: frameView.centerXAnchor, constant: 0).isActive = true
        labelSearch.bottomAnchor.constraint(equalTo: frameView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        labelSearch.widthAnchor.constraint(equalToConstant: frameHeight / 3).isActive = true
        labelSearch.heightAnchor.constraint(equalToConstant: frameHeight / 15).isActive = true
        labelSearch.text = "Find something..."
        labelSearch.textAlignment = .center
        labelSearch.textColor = .black
    }

}


extension FindVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredData.count == 0 {
            bookListTableView.isHidden = true
            frameView.isHidden = false
        } else {
            bookListTableView.isHidden = false
            frameView.isHidden = true
        }
        
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListStoryTableViewCell", for: indexPath) as! ListStoryTableViewCell
        
        cell.imageBook.image = UIImage(named: "loading")
        DispatchQueue.global().async { [weak self] in
            guard let newSelf = self else {return}
            if let imageUrl = URL(string: self!.filteredData[indexPath.row].Image!) {
                do {
                    let imageData = try Data(contentsOf: imageUrl as URL)
                    DispatchQueue.main.async {
                        cell.imageBook.image = UIImage(data: imageData)
                        cell.imageBook.contentMode = .scaleToFill
                        cell.imageBook.clipsToBounds = true
                    }
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        }
        
        cell.titleBook.text = filteredData[indexPath.row].Name
        cell.authorBook.text = filteredData[indexPath.row].Author
        cell.viewAndUpdate.text = "Xem: \(filteredData[indexPath.row].View!) \nNgày cập nhật: \(filteredData[indexPath.row].UpdateDay!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PreviewPage") as! PreviewPage
        let dict = filteredData[indexPath.row]
        vc.getName = dict.Name!
        vc.getAuthor = dict.Author!
        vc.getLike = String(dict.Like!)
        vc.getView = String(dict.View!)
        vc.getIntro = dict.Intro!
        vc.getStatus = dict.Status!
        vc.getImage = dict.Image!
        vc.getCoverPhoto = dict.CoverPhoto!
        vc.getChapter = dict.ChapterCount!
        vc.getId = dict.Id!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FindVC : UITableViewDelegate {
    
}

extension FindVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if waiting == false {
            showSpinner(onView: self.view)
            waiting = true
        }
        DispatchQueue.global().async { [weak self] in
            guard let newSelf = self else {return}
            
            self!.filteredData = self!.bookList.filter({ (text) -> Bool in
                
                let temp: NSString = text.Name! as NSString
                let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.bookListTableView.reloadData()
            self.removeSpinner()
            self.waiting = false
        }
        

    }
}
