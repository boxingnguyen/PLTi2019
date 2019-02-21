//
//  BookshelfViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/14/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class BookshelfViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var borrowBookView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var bookCV: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let reuseIdentifier = "bookCell"
    var duration = Duration()
    var selectedBook = Book(name: "", author: "", image: "", catergory: .all)
    var booksArray = [Book]()
    var currentBooks = [Book]() // update book
    var effect: UIVisualEffect!
    var selectedScopeIndex = 2
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func setupBook() {
        booksArray.append(Book(name: "Nhà giả kim", author: "Paulo Coelho", image: "book1", catergory: .fiction))
        booksArray.append(Book(name: "Ngẫu hứng Trần Tiến", author: "Trần Tiến", image: "book2", catergory: .others))
        booksArray.append(Book(name: "Hoàng Lê nhất thống chí", author: "Ngô gia văn phái", image: "book3", catergory: .history))
        booksArray.append(Book(name: "Khi hơi thở hoá thinh không", author: "Paul Kalanithi", image: "book4", catergory: .selfHelf))
        booksArray.append(Book(name: "Thời gian như thứ thuốc hiện hình", author: "Dương Trung Quốc", image: "book5", catergory: .history))
        booksArray.append(Book(name: "One Piece", author: "Eiichiro Oda", image: "book6", catergory: .comics))
        
        currentBooks = booksArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavBar()
        setupBook()
        
        self.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupCollectionView() {
        let width = (view.frame.size.width - 30) / 2
        let layout = bookCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 240)
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        borrowBookView.layer.cornerRadius = 5
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
//        self.navigationItem.title = "Ours Bookshelf"
        
        searchBar.delegate = self
        searchBar.placeholder = "book's name"
        searchBar.sizeToFit()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Comics", "History", "All", "Fiction", "Self-help"]
        searchBar.selectedScopeButtonIndex = selectedScopeIndex
        
        self.navigationItem.title = "TMH TechLab Library"
    }
    
    // after searchBar's text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedBook = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedBook.isEmpty else {
            self.filterBookByScope(selectedScope: self.selectedScopeIndex)
            return
        }
        
        self.filterBookByScope(selectedScope: self.selectedScopeIndex)
        self.currentBooks = self.booksArray.filter({ (Book) -> Bool in
            return Book.name.lowercased().contains(trimmedBook.lowercased())
        })
        
        self.bookCV.reloadData()
    }
    
    func filterBookByScope(selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.comics
            })
        case 1:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.history
            })
        case 2:
            currentBooks = booksArray
        case 3:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.fiction
            })
        case 4:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.selfHelf
            })
        default:
            break
        }
        
        self.bookCV.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searchBar.text = ""
        self.selectedScopeIndex = selectedScope
        self.filterBookByScope(selectedScope: selectedScope)
    }
    
    
    @IBAction func dimissPopUp(_ sender: Any) {
        animateOut()
    }
    
    func animateIn() {
        self.view.addSubview(borrowBookView)
        borrowBookView.center = self.view.center
        
        borrowBookView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        borrowBookView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.borrowBookView.alpha = 1
            self.borrowBookView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.borrowBookView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.borrowBookView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.borrowBookView.removeFromSuperview()
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
    
    
    @IBAction func backHome(_ sender: Any) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = stboard.instantiateViewController(withIdentifier: "homeVC")
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
}

extension BookshelfViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BookshelfCollectionViewCell
        
        cell.bookName.text = currentBooks[indexPath.row].name
        cell.author.text = currentBooks[indexPath.row].author
        cell.bookImg.image = UIImage(named: currentBooks[indexPath.row].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.backgroundColor = UIColor.darkGray
        // show popUp
        self.animateIn()
        
        // get information of selected book
        let currentCell = collectionView.cellForItem(at: indexPath) as! BookshelfCollectionViewCell
        
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
