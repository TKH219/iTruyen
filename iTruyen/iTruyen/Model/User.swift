//
//  User.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/10/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import Foundation
import Firebase
class User{
    var Id : String?
    var Name : String?
    var listFavorite : [String]?
    var listViewed: [String]?
    let ref = Database.database().reference()
    init()
    {
        
    }
    init(Id: String,Name: String,listFavorite: [String],listViewed: [String])
    {
        self.Id=Id
        self.Name=Name
        self.listFavorite=listFavorite
        self.listViewed=listViewed
    }
    func saveToFirebase()
    {
        let userRef = ref.child("Users").child(Id!)
        let dict = ["Id": self.Id,
                    "Name": self.Name,
                    "listFavorite": self.listFavorite,
                    "listViewed": self.listViewed ] as [String : Any]
        userRef.setValue(dict)
    }
   
}
