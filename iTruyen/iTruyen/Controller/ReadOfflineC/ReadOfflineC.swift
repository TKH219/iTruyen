//
//  ReadOfflineC.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/24/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class ReadOfflineC: UIViewController {
    @IBOutlet weak var listBookTableView: UITableView!
    var listBookName: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show spinner
        showSpinner(onView: self.view)
        //Set title
        self.navigationItem.title = "Danh Sách Truyện Đã Tải"
        //Load custom cell
        loadCustomCell()
        //Get data from Filemanager
        getDataFromFileManager()
        
    }
    
    func loadCustomCell()
    {
        let nib = UINib.init(nibName: "ListBookOfflineCell", bundle: nil)
        self.listBookTableView.register(nib, forCellReuseIdentifier: "ListBookOfflineCell")
    }
    func getDataFromFileManager()
    {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("Offline")
        
        // Get contents in directory: '.' (current one)
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: folderURL.path)
            listBookName = files
            //listBookName.remove(at: 0)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        removeSpinner()
        listBookTableView.reloadData()
    }

    
}
extension ReadOfflineC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBookName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listBookTableView.dequeueReusableCell(withIdentifier: "ListBookOfflineCell", for: indexPath) as! ListBookOfflineCell
        cell.txtNameBook.text = listBookName[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListChapController") as! ListChapterOfflineC
        vc.nameBook = listBookName[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteInFilemanager(bookName: listBookName[indexPath.row])
            self.listBookName.remove(at: indexPath.row)
            listBookTableView.reloadData()
        }
    }
    func deleteInFilemanager(bookName: String)
    {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent("Offline")
        let bookURL = folderURL.appendingPathComponent(bookName)
        do {
            try fileManager.removeItem(atPath: bookURL.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}
