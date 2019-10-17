//
//  Genre.swift
//  iTruyen
//
//  Created by SangNM3 on 4/16/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import Foundation

class Genre {
    var id: String?
    var name: String?
    
    init() {}
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
