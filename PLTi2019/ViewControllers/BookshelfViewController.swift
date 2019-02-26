//
//  BookshelfViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/14/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class BookshelfViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var itemButtonLogin: UIBarButtonItem!
    
    @IBOutlet var borrowBookView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var bookCV: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Property
    private let reuseIdentifier = "bookCell"
    var duration = Duration()
    var selectedBook = Book(id: "", name: "", author: "", image: "", catergory: .all, isBorrow: false)
    var booksArray = [Book]()
    var currentBooks = [Book]() // update book
    var chooseBooks = [Book]() //choose book
    var effect: UIVisualEffect!
    var selectedScopeIndex = 2
    var selectBookIndex: Int = 0 // get row selected for update array
    
    var indexPath: IndexPath?
    
    var getEmailToCheck: String = ""
    var user_id: String = ""
    
    // MARK: System
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        setupBook()
        self.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentBooks.removeAll()
        
        // check login
        let userDefault = UserDefaults.standard
        getEmailToCheck = userDefault.string(forKey: "email") ?? ""
        user_id = userDefault.string(forKey: "id") ?? ""
        
        self.tabBarController?.tabBar.isHidden = false
        
        if getEmailToCheck != "" {
            // show itembuttom Login
            itemButtonLogin.image = UIImage(named: "signIn")
        } else {
            // show itembuttom Logout
            itemButtonLogin.image = UIImage(named: "signOut")
        }
        
    }
    
    // MARK : Function
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
        
        searchBar.delegate = self
        searchBar.placeholder = "book's name"
        searchBar.sizeToFit()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Comics", "Fiction", "All", "Self-help", "Borrowed"]
        searchBar.selectedScopeButtonIndex = selectedScopeIndex
        self.navigationItem.title = "TMH TechLab Library"
    }
    
    func setupBook() {
        ApiService.shared.apiListBooks(book_id: "", user_login: "", success: { (books) in
            guard books.count > 0 else {
                return
            }
            
            self.booksArray = books // (tap mượn, không mượn)
            
            self.currentBooks = books.filter({ (book) -> Bool in
                book.isBorrow == false  // không mượn sách
            })
            
            self.chooseBooks = books.filter({ (book) -> Bool in
                book.isBorrow == true  // mượn sách
            })
            
            self.bookCV.reloadData()
        }) { (err) in
            print("Error \(err.localizedDescription)")
        }
    }
    
    //MARK: SearchBar
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
                book.catergory == BookType.comics && book.isBorrow == false
                
            })
        case 1:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.fiction && book.isBorrow == false
            })
        case 2:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.isBorrow == false
            })
        case 3:
            currentBooks = booksArray.filter({ (book) -> Bool in
                book.catergory == BookType.selfHelf && book.isBorrow == false
            })
        case 4:
            currentBooks = chooseBooks
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
    
    // MARK: Button
    @IBAction func itemButtonLogin(_ sender: Any) {
        guard getEmailToCheck != "" else {
            // go to Login
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
        // logout
        itemButtonLogin.image = UIImage(named: "signOut")
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "user")
        userDefault.removeObject(forKey: "email")
        userDefault.removeObject(forKey: "id")
        
        getEmailToCheck = ""
    }
    
    @IBAction func dimissPopUp(_ sender: Any) {
        animateOut()
    }
 
    @IBAction func borrowBook(_ sender: Any) {
        // send infor of selected book and duration to api
        print(self.duration.day)
        
        if getEmailToCheck != "", user_id != "", selectedBook.isBorrow == false {
            // push
            print("da dang nhap rui, cho phep muon")
            animateOut()
            
            // save date_borrow to db
            ApiService.shared.apiListBooks(book_id: selectedBook.id, user_login: user_id, success: { (listBookBorrow) in
                print("Update database")
            }) { (err) in
                print("Error \(err.localizedDescription)")
            }
            let alert = UIAlertController(title: "", message: "You have successfully borrowed books", preferredStyle: UIAlertController.Style.alert)
            
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.currentBooks = self.booksArray.filter({ (book) -> Bool in
                    book.id != self.selectedBook.id && book.isBorrow == false
                })
                
                // update bookArray
                for (index, element) in self.booksArray.enumerated() {
                    if element.id == self.selectedBook.id {
                        self.booksArray[index].isBorrow = true
                    }
                }
                
                // update currentBooks
                self.currentBooks[self.selectBookIndex].isBorrow = true
                
                // update item select to choosebook
                self.bookCV.reloadData()
//                if self.indexPath != nil {
//                    self.bookCV.reloadItems(at: [self.indexPath!])
//                } else {
//                    self.bookCV.reloadData()
//                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // hide popUp
            animateOut()
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            loginViewController.selectBook = selectedBook
            loginViewController.delegate = self
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    
    @IBAction func backHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: animate
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
        UIView.animate(withDuration: 0.0, animations: {
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
    
}

//MARK: Extention

extension BookshelfViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BookshelfCollectionViewCell
        
        cell.bookName.text = currentBooks[indexPath.row].name
        cell.author.text = currentBooks[indexPath.row].author
        let url = URL(string: currentBooks[indexPath.row].image)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            cell.bookImg.image = UIImage(data: data!)
        } else {
            cell.bookImg.image = UIImage(named: "bookDefault")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.backgroundColor = UIColor.darkGray
        // show popUp
        self.animateIn()
        
        // get information of selected book
//        let currentCell = collectionView.cellForItem(at: indexPath) as! BookshelfCollectionViewCell
        
//        self.selectedBook = currentBooks[indexPath.row]
//        self.selectedBook.name = currentCell.bookName.text!
//        self.selectedBook.author = currentCell.author.text!
//        self.selectedBook.id = currentCell.id.text!
        
        self.selectBookIndex = indexPath.row
        
        self.indexPath = indexPath
        
//        print(self.selectedBook.name)
//        print("da login \(getEmailToCheck)")
        if getEmailToCheck != "" {
//            chooseBooks.append(self.selectedBook)
            self.selectedBook = currentBooks[indexPath.row]
            chooseBooks.append(currentBooks[indexPath.row])
        } else {
            chooseBooks.removeAll()
        }
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

extension BookshelfViewController: selectBookDelegate {
    func chooseBookReload(_ result: Book) {
        if result.name != "" {
            chooseBooks.append(result)
        }
    }
}
