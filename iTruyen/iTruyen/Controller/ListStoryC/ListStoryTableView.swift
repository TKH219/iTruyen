//
//  ListStoryTableView.swift
//  iTruyen
//
//  Created by HungVD11 on 4/9/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase

class ListStoryTableView: UITableViewController, myDelegate2 {
    var getData = String()
    var ref: DatabaseReference!
    
    var book = Book()
    
    var listBook: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func didFetchData(datas: [Book]) {
        self.listBook = datas
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "ListStoryTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ListStoryTableViewCell")
        
        book.delegate = self
    
        book.getListBook(setData: getData)
        
        if listBook.count > 0 {
            removeSpinner()
        } else {
            showSpinner(onView: self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBook.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListStoryTableViewCell", for: indexPath) as! ListStoryTableViewCell
        if listBook.count > 0 {
            self.removeSpinner()
            cell.titleBook.text = self.listBook[indexPath.row].Name
            cell.authorBook.text = self.listBook[indexPath.row].Author
            DispatchQueue.global().sync { [weak self] in
                guard self != nil else {return}
                if let imageUrl = URL(string: self!.listBook[indexPath.row].Image!) {
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
            cell.viewAndUpdate.text = "Xem: \(self.listBook[indexPath.row].View!) - \(self.listBook[indexPath.row].UpdateDay!)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listBook.count > 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PreviewPage") as! PreviewPage
            let dict = listBook[indexPath.row]
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
}
