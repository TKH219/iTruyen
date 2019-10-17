//
//  LibraryViewController.swift
//  iTruyen
//
//  Created by SangNM3 on 4/16/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtLiked: UILabel!
    @IBOutlet weak var txtHistory: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var likedTableView: UITableView!
    
    var listLikedBook: [Book] = [] {
        didSet {
            likedTableView.reloadData()
        }
    }
    
    
    var listBookHistory: [Book] = [] {
        didSet {
            historyTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtTitle.text = "Thư Viện"
        self.txtLiked.text = "Đã Thích"
        self.txtHistory.text = "Lịch sử"
        self.historyTableView.register(UINib(nibName: "LibraryItem", bundle: nil), forCellReuseIdentifier: "LibraryItem")
        self.likedTableView.register(UINib(nibName: "LibraryItem", bundle: nil), forCellReuseIdentifier: "LibraryItem")
        historyTableView.dataSource = self
        historyTableView.delegate = self
        likedTableView.dataSource = self
        likedTableView.delegate = self
    }
    
    
}
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.likedTableView {
            return listLikedBook.count
        } else {
            return listBookHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}
