//
//  Book.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/12/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import Foundation
import Firebase

protocol myDelegate2: class {
    func didFetchData(datas: [Book])
}

class Book {
    var Id: String?
    var Author: String?
    var ChapterCount: Int?
    var CoverPhoto: String?
    var Genre: String?
    var Image: String?
    var Intro: String?
    var Like: Int?
    var Name: String?
    var Status: String?
    var UpdateDay: String?
    var UploadDay: String?
    var View: Int?
    
    var ref: DatabaseReference!
    weak var delegate: myDelegate2?
    
    init()
    {
        
    }
    
    init(Id: String,Author: String,ChapterCount: Int,CoverPhoto: String,Genre: String,Image: String,Intro: String,Like: Int,Name: String,Status: String,
         UpdateDay: String,UploadDay: String,View: Int)
    {
        self.Id = Id
        self.Author = Author
        self.ChapterCount = ChapterCount
        self.CoverPhoto = CoverPhoto
        self.Genre = Genre
        self.Image = Image
        self.Intro = Intro
        self.Like = Like
        self.Name = Name
        self.Status = Status
        self.UpdateDay = UpdateDay
        self.UploadDay = UploadDay
        self.View = View
    }
    
    func getListBook(setData: String) {
        ref = Database.database().reference()
        ref.child("Book").observe(.value, with: { snapshot in
            var listbook: [Book] = []
            let value = snapshot.value as? NSDictionary
            
            for nBook in value! {
                let val = nBook.value as? NSDictionary
                self.Id = val?["Id"] as? String ?? ""
                
                self.Author = val?["Author"] as? String ?? ""
                
                self.ChapterCount = val?["ChapterCount"] as? Int ?? 0
                
                self.CoverPhoto = val?["CoverPhoto"] as? String ?? ""
                
                self.Genre = val?["Genre"] as? String ?? ""
                
                self.Image = val?["Image"] as? String ?? ""
                
                self.Intro = val?["Intro"] as? String ?? ""
                
                self.Like = val?["Like"] as? Int ?? 0
                
                self.Name = val?["Name"] as? String ?? ""
                
                self.Status = val?["Status"] as? String ?? ""
                
                self.View = val?["View"] as? Int ?? 0
                
                self.UploadDay = val?["UploadDay"] as? String ?? ""
                
                self.UpdateDay = val?["UpdateDay"] as? String ?? ""
                
                if self.Genre == setData {
                    listbook.append(Book(Id: self.Id!, Author: self.Author!, ChapterCount: self.ChapterCount!, CoverPhoto: self.CoverPhoto!, Genre: self.Genre!, Image: self.Image!, Intro: self.Intro!, Like: self.Like!, Name: self.Name!, Status: self.Status!, UpdateDay: self.UpdateDay!, UploadDay: self.UploadDay!, View: self.View!))
                } else if self.Author == setData {
                    listbook.append(Book(Id: self.Id!, Author: self.Author!, ChapterCount: self.ChapterCount!, CoverPhoto: self.CoverPhoto!, Genre: self.Genre!, Image: self.Image!, Intro: self.Intro!, Like: self.Like!, Name: self.Name!, Status: self.Status!, UpdateDay: self.UpdateDay!, UploadDay: self.UploadDay!, View: self.View!))
                }
            }
            self.delegate?.didFetchData(datas: listbook)
        })
    }
}
