//
//  ProfileBookViewController.swift
//  PLTi2019
//
//  Created by Dinh Nhinh on 2/28/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class ProfileBookViewController: UIViewController {
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var name_borrow: UILabel!
    @IBOutlet weak var date_borrow: UILabel!
    @IBOutlet weak var date_return: UILabel!
    @IBOutlet weak var max_borrow_day: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    var borrowedBook: Book = Book(id: "", name: "", author: "", image: "", catergory: .all, isBorrow: false, user_borrow_id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: borrowedBook.image)
        if url != nil {
            let data = try? Data(contentsOf: url!)
            imgBook.image = UIImage(data: data!)
        } else {
            imgBook.image = UIImage(named: "bookDefault")
        }
        name_borrow.text = borrowedBook.name
        date_borrow.text = borrowedBook.date_borrow
        date_return.text = borrowedBook.date_return
        max_borrow_day.text = "7"
        category.text = borrowedBook.catergory.rawValue
        detail.text = borrowedBook.detail
    }
    
//    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
