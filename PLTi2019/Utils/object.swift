//
//  books.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/13/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import Foundation

class Book {
    var name:           String = ""
    var author:         String = ""
    var image:          String = ""
    var catergory:      BookType
    
    init(name: String, author: String, image: String, catergory: BookType) {
        self.name = name
        self.author = author
        self.image = image
        self.catergory = catergory
    }
}

class Duration {
    var day:            Int = 0
    var month:          Int = 0
    var year:           Int = 0
}

enum BookType: String {
    case comics = "Comics"
    case history = "History"
    case fiction = "Fiction"
    case selfHelf = "Self-help"
    case others = "Others"
    case all = "All"
}
