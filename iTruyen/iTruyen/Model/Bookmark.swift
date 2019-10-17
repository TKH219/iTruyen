//
//  Bookmark.swift
//  iTruyen
//
//  Created by HanLTP on 4/26/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import Foundation

class Bookmark : Codable {
    var bookName : String?
    var currentPage : [Int]?
    
    init(bookName: String, currentPage: [Int]) {
        self.bookName = bookName
        self.currentPage = currentPage
    }
    
    init() {
        
    }

    class func setData(bookmark: [Bookmark]){
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bookmark) {
            defaults.set(encoded, forKey: "Bookmark")
        }
    }

    class func getData() -> [Bookmark]? {
        let defaults = UserDefaults.standard
        if let savedBookmark  = defaults.object(forKey: "Bookmark") as? Data {
            let decoder = JSONDecoder()
            if let loadedBookmark = try? decoder.decode([Bookmark].self, from: savedBookmark) {
                return loadedBookmark
            }
        }
        return nil
    }
    
}
