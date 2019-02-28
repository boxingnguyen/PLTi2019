//
//  books.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/13/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import Foundation

class Book {
    var id :            String = ""
    var name:           String = ""
    var author:         String = ""
    var image:          String = ""
    var catergory:      BookType
    var isBorrow:       Bool = false
    var user_borrow_id: String = ""
    var date_borrow:    String = ""
    var date_return:    String = ""
    var detail:         String = ""
    
    init(id: String, name: String, author: String, image: String, catergory: BookType, isBorrow: Bool, user_borrow_id: String) {
        self.id = id
        self.name = name
        self.author = author
        self.image = image
        self.catergory = catergory
        self.isBorrow = isBorrow
        self.user_borrow_id = user_borrow_id
    }
}

class Duration {
    var day:            Int = 0
    var month:          Int = 0
    var year:           Int = 0
    var hour:           Int = 0
    var minute:         Int = 0
}

enum BookType: String {
    case comics = "Comics"
//    case history = "History"
    case fiction = "Fiction"
    case selfHelf = "Self-help"
    case others = "Others"
    case all = "All"
//    case choosen = "choose"
}

enum MenuTitle: String {
    case visit = "Let's go around the TMH TechLab!"
    case book = "TMH TechLab Library"
    case printer = "Let's learn how to print 3d objects!"
}

class User: NSObject, NSCoding {
    var id : String
    var username: String
    var email: String
    var password: String

    init(id: String, username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
        self.id = id
        
    }

    // k hiêu chỗ nay để làm gì nữa
    required convenience init(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let id = aDecoder.decodeObject(forKey: "id") as! String
        self.init(id: id, username: username, email: email, password: password)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(id, forKey: "id ")
    }
}
