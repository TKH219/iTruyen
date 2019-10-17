//
//  Content.swift
//  iTruyen
//
//  Created by TranNTH on 4/18/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import Foundation
import Firebase

protocol myDelegate: class {
    func didFetchData(datas: [Content])
}

class Content {
    var idBook: String?
    var idChapter: String?
    var chapterName: String?
    var chapterLink: String?
    var chapterUpload: String?
    
    var ref: DatabaseReference!
    weak var delegate: myDelegate?
    
    init() {}
    
    init(idBook: String, idChapter: String, chapterName: String, chapterLink: String, chapterUpload: String) {
        self.idBook = idBook
        self.idChapter = idChapter
        self.chapterName = chapterName
        self.chapterLink = chapterLink
        self.chapterUpload = chapterUpload
    }
    
    func getChapterBook(idbook: String) {
        ref = Database.database().reference()
        ref.child("Content").child(idbook ?? "1000CNA").observe(.value, with: { snapshot in
            var listChapter: [Content] = []
            let value = snapshot.value as? NSDictionary
            
            for nChapter in value! {
                let val = nChapter.value as? NSDictionary
                
                self.idChapter = (nChapter.key as! String)
                
                self.chapterName = val?["ChapName"] as? String ?? ""
                
                self.chapterLink = val?["Link"] as? String ?? ""
                
                self.chapterUpload = val?["Upload"] as? String ?? ""
                
                listChapter.append(Content(idBook: "", idChapter: self.idChapter!, chapterName: self.chapterName!, chapterLink: self.chapterLink!, chapterUpload: self.chapterUpload!))
            }
            self.delegate?.didFetchData(datas: listChapter)
        })
    }
}
