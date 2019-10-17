//
//  ListChapterOfflineC.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/24/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class ListChapterOfflineC: UIViewController {

    @IBOutlet weak var listChapTableview: UITableView!
    var listChap : [String] = []
    var nameBook : String?
    
    var allBookmark : [Bookmark]? = Bookmark.getData()
    
    var bookmark : Bookmark?
    let queue = DispatchQueue(label: "handle-bookmark")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue.async {
            for index in self.allBookmark! {
                if index.bookName == self.nameBook {
                    self.bookmark = index
                    break
                }
            }
        }
        
        showSpinner(onView: self.view)
        loadCustomCell()
        getDataFromFileManager()
        
    }
    func loadCustomCell()
    {
        let nib = UINib.init(nibName: "ListBookOfflineCell", bundle: nil)
        self.listChapTableview.register(nib, forCellReuseIdentifier: "ListBookOfflineCell")
    }
    func getDataFromFileManager()
    {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("Offline")
        let bookURL = folderURL.appendingPathComponent("\(nameBook!)")
        do {
            let files = try fileManager.contentsOfDirectory(atPath: bookURL.path)
            listChap = files
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        for i in 0...listChap.count-1
        {
            listChap[i] = listChap[i].replacingOccurrences(of: ".pdf", with: "")
            
        }
        removeSpinner()
        listChapTableview.reloadData()
    }
    
}
extension ListChapterOfflineC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listChapTableview.dequeueReusableCell(withIdentifier: "ListBookOfflineCell", for: indexPath) as! ListBookOfflineCell
        cell.txtNameBook.text = listChap[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapName = listChap[indexPath.row]
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("Offline")
        let bookURL = folderURL.appendingPathComponent("\(nameBook!)")
        let chapURL = bookURL.appendingPathComponent("\(chapName).pdf")
        
        let vc = BookPage()
        vc.fileURL = chapURL
        vc.chapterName = chapName
        vc.status = true
        
        vc.bookmark = bookmark
        vc.position = indexPath.row
        vc.allBookmark = allBookmark
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
