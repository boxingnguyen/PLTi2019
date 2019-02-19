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

enum MenuTitle: String {
    case visit = "Let's go around the TMH TechLab!"
    case book = "TMH TechLab Library"
    case printer = "Let's learn how to print 3d objects!"
}

class User: NSObject, NSCoding {
    var username: String
    var email: String
    var password: String

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
        
    }

    required convenience init(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        self.init(username: username, email: email, password: password)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
    }
}
