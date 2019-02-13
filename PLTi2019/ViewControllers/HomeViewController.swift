//
//  HomeViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/12/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var addBookView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var bookCV: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let reuseIdentifier = "bookCell"
    var selectedBook = Book()
    var duration = Duration()
    
    var arrayBooks:[[String]] = [["Nhà giả kim", "Paulo Coelho", "book1"], ["Ngẫu hứng Trần Tiến", "Trần Tiến", "book2"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"], ["Khi hơi thở hoá thinh không", "Paul Kalanithi", "book4"], ["Thời gian như thứ thuốc hiện hình", "Dương Trung Quốc", "book5"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"], ["Hoàng Lê thống chí", "Ngô gia văn phái", "book3"]]
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let width = (view.frame.size.width - 30) / 2
        let layout = bookCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 280)
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        addBookView.layer.cornerRadius = 5
        
        self.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func dimissPopUp(_ sender: Any) {
        animateOut()
    }
    
    func animateIn() {
        self.view.addSubview(addBookView)
        addBookView.center = self.view.center
        
        addBookView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addBookView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.addBookView.alpha = 1
            self.addBookView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.addBookView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addBookView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.addBookView.removeFromSuperview()
        }
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        
        if let day = components.day, let month = components.month, let year = components.year {
            duration.day = day
            duration.month = month
            duration.year = year
        }
    }
    
    @IBAction func borrowBook(_ sender: Any) {
        // send infor of selected book and duration to api
        print(self.duration.day)
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! HomeCollectionViewCell

        cell.bookName.text = arrayBooks[indexPath.row][0]
        cell.author.text = arrayBooks[indexPath.row][1]
        cell.bookImg.image = UIImage(named: arrayBooks[indexPath.row][2])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // show popUp
        self.animateIn()
        
        // get information of selected book
        let currentCell = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        
        
        
        self.selectedBook.name = currentCell.bookName.text!
        self.selectedBook.author = currentCell.author.text!
            
        print(self.selectedBook.name)
        
//
//        let cell = collectionView.cellForItem(at: indexPath)
        
//        Briefly fade the cell on selection
//        UIView.animate(withDuration: 0.5,
//                       animations: {
//                        //Fade-out
//                        cell?.alpha = 0.5
//        }) { (completed) in
//            UIView.animate(withDuration: 0.5,
//                           animations: {
//                            //Fade-out
//                            cell?.alpha = 1
//            })
//        }
        

    }
    
}
